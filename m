Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaBAURU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 15:17:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33579 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375AbaBAURH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 15:17:07 -0500
Message-ID: <52ED562B.60703@zytor.com>
Date: Sat, 01 Feb 2014 12:16:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Suresh Siddha <sbsiddha@gmail.com>,
        Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>	<52ED4C96.6020703@zytor.com> <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
In-Reply-To: <CA+55aFxex2ymO3k_udRL=yT9xF5PtRx=O2O2vtL76PBUE0fNtg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 11:46 AM, Linus Torvalds wrote:
> 
> .. which *does* actually bring up something that might work, and might
> be a good idea: remove the "restore math state or set TS" from the
> normal kernel paths *entirely*, and move it to the "return to user
> space" phase.
> 

The task switch code would have to be aware in case of preemption,
though.  The nice thing about *that* is that we could probably
completely drop the notion that we can't preempt an FPU-using kernel task.

	-hpa

