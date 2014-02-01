Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaBATgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 14:36:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32956 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbaBATgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 14:36:21 -0500
Message-ID: <52ED4C96.6020703@zytor.com>
Date: Sat, 01 Feb 2014 11:35:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com> <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
In-Reply-To: <CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 11:27 AM, Linus Torvalds wrote:
>
>   (a) "we don't want to restore at all, because once the kernel starts
> using math, it might do so a lot, and saving/restoring is a bad idea":
>
>    void __kernel_fpu_end(void)
>    {
>            stts();
>    }
>
> *or*
>
> Quite frankly, I'd almost lean towards (a). Comments? Does anybody
> have any loads where the kernel does a lot of fpu stuff (ie network
> encryption using the hw engines or something)? I'd really like to hear
> if it makes a difference..
>

This will obviously not protect eageronly features (MPX, LWP, ...) so 
this means those features are permanently unavailable to the kernel, 
even inside kernel_fpu_begin/end.  Now, currently I don't think we have 
any plans to use those in the kernel (at least not in a way where 
kernel_fpu_begin/end makes sense as bracketing), but it is something 
worth keeping in mind.

	-hpa

