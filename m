Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaLCXx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:53:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaLCXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:53:54 -0500
Date: Wed, 3 Dec 2014 15:53:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard@nod.at>, David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct
 task_struct
Message-Id: <20141203155352.ea5322ff45c6200238c7ef51@linux-foundation.org>
In-Reply-To: <CALCETrVk0EBL0vk8kjOhjkMAOaxXukCdSptzfHU=g1s7JChXiQ@mail.gmail.com>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
	<alpine.DEB.2.11.1410291908290.5308@nanos>
	<CALCETrWtBCFXzwCAh8fpeFv-EvPxYW20oRmFk1iCYwUvpft=Rw@mail.gmail.com>
	<20141110.211319.1983610686941713044.davem@davemloft.net>
	<5461EA6B.9020305@nod.at>
	<CALCETrUZhbx-PN8A168khFr6ve_9vdkSiwOcQ-hZbqu4po8hnQ@mail.gmail.com>
	<20141203153721.30b32472145aa560921bdc1e@linux-foundation.org>
	<CALCETrVk0EBL0vk8kjOhjkMAOaxXukCdSptzfHU=g1s7JChXiQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014 15:38:29 -0800 Andy Lutomirski <luto@amacapital.net> wrote:

> Yes, exactly.
> 
> >
> > Spelling this out in the changelog would be useful for the ignorant and
> > the forgetful ;)
> 
> Want a new version, or will you fix it up yourself?
> 

I think I can work that out.

A couple of linux-next things to check:

- arch/arm/include/asm/thread_info.h:arm_restart_block has
  disappeared from the thread_info.

- the reference to ti->restart_block in arch/arm/kernel/traps.c has
  vanished.  I couldn't find anywhere where it was moved to.
