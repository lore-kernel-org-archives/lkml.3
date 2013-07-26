Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705Ab3GZVhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:37:19 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:46632 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760010Ab3GZVhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130726211844.GB8508@moon>
References: <20130726201807.GJ8661@moon> <CALCETrUJa-Y40vnb6YOPry0dCXb3zCQ0y19i2yHWdzKR75HUzg@mail.gmail.com>
 <20130726211844.GB8508@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 26 Jul 2013 14:36:51 -0700
Message-ID: <CALCETrW7Ukh8KfKzpNgRc1D_5OK1o7bmEmFbtQTYoSoFiOSeKw@mail.gmail.com>
Subject: Re: [PATCH] mm: Save soft-dirty bits on file pages
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 2:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, Jul 26, 2013 at 01:55:04PM -0700, Andy Lutomirski wrote:
>> On Fri, Jul 26, 2013 at 1:18 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > Andy reported that if file page get reclaimed we loose soft-dirty bit
>> > if it was there, so save _PAGE_BIT_SOFT_DIRTY bit when page address
>> > get encoded into pte entry. Thus when #pf happens on such non-present
>> > pte we can restore it back.
>> >
>>
>> Unless I'm misunderstanding this, it's saving the bit in the
>> non-present PTE.  This sounds wrong -- what happens if the entire pmd
>
> It's the same as encoding pgoff in pte entry (pte is not present),
> but together with pgoff we save soft-bit status, later on #pf we decode
> pgoff and restore softbit back if it was there, pte itself can't disappear
> since it holds pgoff information.

Isn't that only the case for nonlinear mappings?

--Andy
