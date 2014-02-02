Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaBBB54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 20:57:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37602 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaBBB5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 20:57:54 -0500
Message-ID: <52EDA60A.50906@zytor.com>
Date: Sat, 01 Feb 2014 17:57:30 -0800
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
References: <alpine.DEB.2.10.1401301442170.2769@minerva.lan>	<CA+55aFz_CYQGxukpRb5zF5SZ9ZWqpvohoUzqdEb-3+bR_FMnWA@mail.gmail.com>	<CALmL7E9LRZCPH5EuS_Jm-iJzpKnWj4OsXmS44VYDpLoDKPfVxA@mail.gmail.com>	<CA+55aFz-=9L=K2O-yB5f9R-w40PzXJ5xEXcinnUdUF1QHO7KMQ@mail.gmail.com>	<CALmL7E9j5Rv8ZqUZXZh-dfNu_-7XWK_EoNjZHpuAwtG7jpk9+g@mail.gmail.com>	<52ED9EA9.7080009@zytor.com>	<CALmL7E_ijZStgyxj4Gnn69sEF-kv+eBE64+J7OBfn-K4cbBmJg@mail.gmail.com>	<CA+55aFw-im55F=6PJ1T-=dtmb4+NcnRpZ9nxx=+khUe+sLNxxw@mail.gmail.com>	<CALmL7E_D=aK-PZQe43wZueWqJ_YNXhaFagTSr=K1Xk-xwLLh+w@mail.gmail.com> <CA+55aFxzYMCXop7KSUi9EuaTF-m4qpbM4ahrELW8gKHDZVwkZA@mail.gmail.com>
In-Reply-To: <CA+55aFxzYMCXop7KSUi9EuaTF-m4qpbM4ahrELW8gKHDZVwkZA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2014 05:51 PM, Linus Torvalds wrote:
> On Sat, Feb 1, 2014 at 5:47 PM, Suresh Siddha <sbsiddha@gmail.com> wrote:
>>
>> So if the restore failed, we should do something like drop_init_fpu(),
>> which will restore init-state to the registers.
>>
>> for eager-fpu()  paths we don't use clts() stts() etc.
> 
> Uhhuh. Ok.
> 
> Why do we do that, btw? I think it would make much more sense to just
> do what I *thought* we did, and just make it a context-switch-time
> optimization ("let's always switch FP state"), not make it a huge
> semantic difference.
> 

Twiddling CR0.TS is pretty slow if we're not taking advantage of it.

	-hpa


