Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3ALKNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:13:18 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49272 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3ALKNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:13:15 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1357957789.2168.11.camel@joe-AO722>
References: <20130111234813.170A620004E@hpza10.eem.corp.google.com>
	<50F0BFAA.10902@infradead.org>
	<20130112131713.749566c8d374cd77b1f2885e@canb.auug.org.au>
	<1357957789.2168.11.camel@joe-AO722>
Date: Sat, 12 Jan 2013 11:13:14 +0100
Message-ID: <CA+icZUVMY76bRFgUumZy0G-FFM=80iwfSFSopHMwHRYfgKjLjA@mail.gmail.com>
Subject: Re: mmotm 2013-01-11-15-47 uploaded (x86 asm-offsets broken)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@infradead.org>, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 3:29 AM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2013-01-12 at 13:17 +1100, Stephen Rothwell wrote:
>> On Fri, 11 Jan 2013 17:43:06 -0800 Randy Dunlap <rdunlap@infradead.org> wrote:
>> >
>> > b0rked.
>> >
>> > Some (randconfig?) causes this set of errors:
>
> I guess that's when CONFIG_HZ is not an even divisor of 1000.
> I suppose this needs to be worked on a bit more.
>
>

I remember this patch from Joe come up with a pending patch in
net-next.git#master [1] (I mention this as I have not seen hit it in
latest Linux-Next whereas this latest mmotm includes it [2]).

$ grep "config HZ_" kernel/Kconfig.hz
        config HZ_100
        config HZ_250
        config HZ_300
        config HZ_1000

As I see Randy has in his kernel-config:

# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300

So there is a problem for the value "300" (only)?

Regards,
- Sedat -


[1] http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commitdiff;h=c10d73671ad30f54692f7f69f0e09e75d3a8926a
[2] http://git.cmpxchg.org/?p=linux-mmotm.git&a=search&h=HEAD&st=commit&s=softirq

> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
