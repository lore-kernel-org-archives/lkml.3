Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaBAXk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 18:40:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36695 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205AbaBAXkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 18:40:51 -0500
Message-ID: <52ED85DD.6020402@zytor.com>
Date: Sat, 01 Feb 2014 15:40:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>, torvalds@linux-foundation.org
CC: jack@suse.cz, linux-kernel@vger.kernel.org, maarten-baert@hotmail.com,
        mingo@kernel.org, nate@thatsmathematics.com, priikone@iki.fi,
        sbsiddha@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <20140201211710.20281.qmail@science.horizon.com>
In-Reply-To: <20140201211710.20281.qmail@science.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 01:17 PM, George Spelvin wrote:
>> .. which *does* actually bring up something that might work, and might
>> be a good idea: remove the "restore math state or set TS" from the
>> normal kernel paths *entirely*, and move it to the "return to user
>> space" phase.
> 
> This definitely seems much more sensible.  For processors without
> optimized context save/restore, the decision whether to restore eagerly
> is best made once the kernel has decided what it's returning *to*.
> 
> From an interrupt handler, there are now three cases:
> 1) FPU not in use, available for immediate use.
> 2) FPU in use by user-space; save to <location> before using.
> 3) FPU in use by kernel code; may not be used (unless we want
>    to add nested FPU state save hair).
> 

OK, let's circle back for a bit.  We have an active bug, and we clearly
have a lot of restructuring that could/should be done.  We need to fix
the bug first; if we're going to a bunch of restructuring then that
ought to be separate.  The first bit is how we fix the immediate bug.

	-hpa

