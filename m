Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaBYXEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:04:40 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51095 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaBYXEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:04:39 -0500
Subject: Re: [PATCH v4 0/6] generic early_ioremap support
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <530CF21E.1020603@zytor.com>
Date: Tue, 25 Feb 2014 23:04:34 +0000
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <5D4B48CE-46BA-44E8-BCDE-AEACAC9973AF@arm.com>
References: <1392238575-10000-1-git-send-email-msalter@redhat.com> <1393337404.7307.51.camel@deneb.redhat.com> <20140225183012.GA27164@mudshark.cambridge.arm.com> <1393353942.26583.10.camel@deneb.redhat.com> <530CF21E.1020603@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Feb 2014, at 19:42, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/25/2014 10:45 AM, Mark Salter wrote:
>> On Tue, 2014-02-25 at 18:30 +0000, Will Deacon wrote:
>>> I'd suggest spitting the core part out from the arch-specific parts. That
>>> way, the core part can merged independently and architectures can move over
>>> as they see fit. It also signals (at least to me) that, "hey, I should
>>> probably review this" whilst my current stance is "there's a whole load of
>>> stuff under mm/ that needs to be acked first".
>>> 
>>> If you put the whole thing into next, you just run the risk of conflicts
>>> with all the arch trees.
>> 
>> I've been thinking of breaking out the common bits and x86 bits and just
>> going with that for now. There's no point in just doing the common bits
>> because it won't get tested without at least one architecture using it.
>> 
> 
> If you think it makes sense we could take the common bits + x86 and put
> them through the -tip tree.  

I’m ok with the arm64 patches to go through -tip with my ack on all
patches:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

> The other option would be to put the whole
> thread in linux-next with Acks.
> 
> As far as x86 is concerned it looks like it is mostly just code
> movement, so I'm happy giving my:
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>

Thanks. Either way works for me.

I think the series still need an ack from rmk at least on the arm patch
(4/6).

Catalin