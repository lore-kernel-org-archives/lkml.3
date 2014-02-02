Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaBBB0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:26:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37392 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaBBB02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:26:28 -0500
Message-ID: <52ED9EA9.7080009@zytor.com>
Date: Sat, 01 Feb 2014 17:26:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Suresh Siddha <sbsiddha@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Nate Eldredge <nate@thatsmathematics.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maarten Baert <maarten-baert@hotmail.com>, Jan Kara <jack@suse.cz>,
        George Spelvin <linux@horizon.com>, Pekka Riikonen <priikone@iki.fi>
Subject: Re: [PATCH] Make math_state_restore() save and restore the interrupt
 flag
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com> <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
In-Reply-To: <CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 05:06 PM, Suresh Siddha wrote:
> 
> so I will Ack for option "b", as option "a" breaks the features which
> don't take into account cr0.TS.
> 

Even "b" does that, no?  "a" should be fine as long as we don't ever use
those features in the kernel, even under kernel_fpu_begin/end().

> Meanwhile I have the patch removing the delayed dynamic allocation for
> non-eager fpu. will post it after some testing.

Thanks.

	-hpa


