Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbaFNMF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 08:05:26 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35879 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaFNMFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 08:05:25 -0400
Subject: Re: kmemleak: Unable to handle kernel paging request
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1402695853.20360.17.camel@pasglop>
Date: Sat, 14 Jun 2014 13:05:18 +0100
Cc: Denis Kirjanov <kda@linux-powerpc.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D9560F26-D206-4423-ACA4-31342A73B5F9@arm.com>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com> <20140611173851.GA5556@MacBook-Pro.local> <CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com> <B01EB0A1-992B-49F4-93AE-71E4BA707795@arm.com> <CAOJe8K3LDhhPWbtdaWt23mY+2vnw5p05+eyk2D8fovOxC10cgA@mail.gmail.com> <CAOJe8K2WaJUP9_buwgKw89fxGe56mGP1Mn8rDUO9W48KZzmybA@mail.gmail.com> <20140612143916.GB8970@arm.com> <CAOJe8K3zN+fFWumKaGx3Tmv5JRZu10_FZ6R3Tjjc+nc-KVB0hg@mail.gmail.com> <20140613085640.GA21018@arm.com> <1402695853.20360.17.camel@pasglop>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Jun 2014, at 22:44, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> On Fri, 2014-06-13 at 09:56 +0100, Catalin Marinas wrote:
> 
>> OK, so that's the DART table allocated via alloc_dart_table(). Is
>> dart_tablebase removed from the kernel linear mapping after allocation?
> 
> Yes.
> 
>> If that's the case, we need to tell kmemleak to ignore this block (see
>> patch below, untested). But I still can't explain how commit
>> d4c54919ed863020 causes this issue.
>> 
>> (also cc'ing the powerpc list and maintainers)
> 
> We remove the DART from the linear mapping because it has to be mapped
> non-cachable and having it in the linear mapping would cause cache
> paradoxes. We also can't just change the caching attributes in the
> linear mapping because we use 16M pages for it and 970 CPUs don't
> support cache-inhibited 16M pages :-( And due to the MMU segmentation
> model, we also can't mix & match page sizes in that area.
> 
> So we just unmap it, and ioremap it elsewhere.

OK, thanks for the explanation. So the kmemleak annotation makes sense.

Would you please take the I patch earlier (I guess with Denis’ tested-
by). I can send it separately if more convenient.

Thanks,

Catalin