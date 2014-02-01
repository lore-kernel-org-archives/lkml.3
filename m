Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbaBAVh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 16:37:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34326 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbaBAVh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 16:37:28 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20140201211710.20281.qmail@science.horizon.com>
References: <20140201211710.20281.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt flag
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 01 Feb 2014 13:36:54 -0800
To: George Spelvin <linux@horizon.com>, torvalds@linux-foundation.org
CC: jack@suse.cz, linux-kernel@vger.kernel.org, maarten-baert@hotmail.com,
        mingo@kernel.org, nate@thatsmathematics.com, priikone@iki.fi,
        sbsiddha@gmail.com, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org
Message-ID: <0b88762d-f9f9-419b-9c3e-a18f5458471c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be good to know how often #3 happens on a real workload.

On February 1, 2014 1:17:10 PM PST, George Spelvin <linux@horizon.com> wrote:
>> .. which *does* actually bring up something that might work, and
>might
>> be a good idea: remove the "restore math state or set TS" from the
>> normal kernel paths *entirely*, and move it to the "return to user
>> space" phase.
>
>This definitely seems much more sensible.  For processors without
>optimized context save/restore, the decision whether to restore eagerly
>is best made once the kernel has decided what it's returning *to*.
>
>From an interrupt handler, there are now three cases:
>1) FPU not in use, available for immediate use.
>2) FPU in use by user-space; save to <location> before using.
>3) FPU in use by kernel code; may not be used (unless we want
>   to add nested FPU state save hair).

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
