Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJ2SNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:13:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:58067 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaJ2SNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:13:02 -0400
Date: Wed, 29 Oct 2014 19:12:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] all arches, signal: Move restart_block to struct
 task_struct
In-Reply-To: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1410291908290.5308@nanos>
References: <43c88012a4959cd427ab634906e697fbc524e847.1414604015.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Andy Lutomirski wrote:

> If an attacker can cause a controlled kernel stack overflow,
> overwriting the restart block is a very juicy exploit target.
> Moving the restart block to struct task_struct prevents this
> exploit.
> 
> Note that there are other fields in thread_info that are also easy
> targets, at least on some architectures.
> 
> It's also a decent simplification, since the restart code is more or
> less identical on all architectures.

I think that's the most important change. Moving common stuff into
common code. The side effect of slightly reducing the attack surface
is nice, but as Al pointed out not really the big win here.
 
Thanks,

	tglx
