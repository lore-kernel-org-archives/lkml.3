Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3BWVmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:42:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42878 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808Ab3BWVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:42:22 -0500
Message-ID: <512937A8.9050906@zytor.com>
Date: Sat, 23 Feb 2013 13:42:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/mm changes for v3.9-rc1
References: <alpine.DEB.2.02.1302221929040.22997@kaball.uk.xensource.com> <5127CE65.5010703@linux.intel.com> <CAE9FiQXHHFb0W+aJCsefRNj4p+X1+m8JOLUDz74w-nAjnhym+A@mail.gmail.com> <5127DDB3.2010309@zytor.com> <CAE9FiQWctM60VwXJYtOXwPBNLUoz966Fr1g6MPsPoJBiye88YQ@mail.gmail.com> <5127FBA4.1040506@zytor.com> <20130223003738.GA23545@phenom.dumpdata.com> <CAE9FiQVTbDkvU8KQGVoYv3kn6UeCTcdiPA2hvw21OKtNbM=XKg@mail.gmail.com> <20130223012716.GA28377@phenom.dumpdata.com> <CAE9FiQUcJiDOjv-XYYUfQAAHaZCq2Q1heR5YakGf13SYJjxyxA@mail.gmail.com> <20130223194300.GA13174@konrad-lan.dumpdata.com> <CAE9FiQVPwD14j2FGyW9NZqXqo1MyaP0M9mGcirAWo=hM8fP_Lg@mail.gmail.com>
In-Reply-To: <CAE9FiQVPwD14j2FGyW9NZqXqo1MyaP0M9mGcirAWo=hM8fP_Lg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 01:37 PM, Yinghai Lu wrote:
> On Sat, Feb 23, 2013 at 11:43 AM, Konrad Rzeszutek Wilk
> <konrad@kernel.org> wrote:
>>>>> Also you should check condition about calling xen_get_user_pgd().
>>>>
>>>> Could you elaborate please?
>>>
>>> only call xen_get_user_pgd() when it should be called.
>>
>> I should have been more explicit. When I was saying "elaborate" I was
>> soliciting for advice on the 'check condition' and how to make it robust.
>
> your 64bit xen_write_cr3_init, is just xen_write_cr3 without
> xen_get_user_pgd calling.
> plus set xen_write_cr3 to ops.write_cr3.
>
> so if you could have way to find out when xen_get_user_pgd could be used,
> new xen_write_cr3_init need to check that, then set ops.write_cr3 and
> call ops.write_cr3
> otherwise will still call slim version without update ops.write_cr3
> and bail out early.
>

Yes, and that's the right thing to do, *or* you can make the init 
version ask "do we have userspace yet" and if so switch the pointer and 
chain the other function.  The latter will save you from having to do a 
test every time.

However, the assumption that we will only set cr3 once before userspace 
is still too fragile.  It makes sense for a quick fix because 32 bits 
already had the same assumption, but this needs to be cleaned up in the 
future.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

