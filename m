Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaKKCNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 21:13:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51219 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKKCNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 21:13:23 -0500
Date: Mon, 10 Nov 2014 21:13:19 -0500 (EST)
Message-Id: <20141110.211319.1983610686941713044.davem@davemloft.net>
To: luto@amacapital.net
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-arch@vger.kernel.org,
        viro@zeniv.linux.org.uk, richard.weinberger@gmail.com, hpa@zytor.com,
        mingo@kernel.org, keescook@chromium.org
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct
 task_struct
From: David Miller <davem@davemloft.net>
In-Reply-To: <CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
	<alpine.DEB.2.11.1410291908290.5308@nanos>
	<CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 18:13:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Nov 2014 14:03:23 -0800

> On Wed, Oct 29, 2014 at 11:12 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Wed, 29 Oct 2014, Andy Lutomirski wrote:
>>
>>> If an attacker can cause a controlled kernel stack overflow,
>>> overwriting the restart block is a very juicy exploit target.
>>> Moving the restart block to struct task_struct prevents this
>>> exploit.
>>>
>>> Note that there are other fields in thread_info that are also easy
>>> targets, at least on some architectures.
>>>
>>> It's also a decent simplification, since the restart code is more or
>>> less identical on all architectures.
>>
>> I think that's the most important change. Moving common stuff into
>> common code. The side effect of slightly reducing the attack surface
>> is nice, but as Al pointed out not really the big win here.
> 
> Having gotten exactly zero feedback from any arch maintainer outside
> of x86, am I supposed to pester people further?

No objections wrt. sparc and if things break I'll help fix it.
