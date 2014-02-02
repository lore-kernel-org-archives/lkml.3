Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaBBVjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:11 -0500
Received: from www84.your-server.de ([213.133.104.84]:36561 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaBBVjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:09 -0500
Message-ID: <1391377190.9266.6.camel@wall-e.seibold.net>
Subject: Re: [PATCH 7/8] Add 32 bit VDSO time support for 32 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 02 Feb 2014 22:39:50 +0100
In-Reply-To: <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
References: <1391340435-5130-1-git-send-email-stefani@seibold.net>
	 <1391340435-5130-8-git-send-email-stefani@seibold.net>
	 <CALCETrXNVoJBUncHbWWuQ7LAf2ZoWOY8uJBeg_VD1+MmwJ07Rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 02.02.2014, 08:46 -0800 schrieb Andy Lutomirski:
> On Sun, Feb 2, 2014 at 3:27 AM,  <stefani@seibold.net> wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> >
> > This patch add the time support for 32 bit a VDSO to a 32 bit kernel.
> 
> [...]
> 
> Can you address the review comments from last time around?  For
> example, this still seems to have redundant vvar and hpet mappings, it
> doesn't use the VVAR macro, it moves the 32-bit compat vDSO, etc.
> 

I will address the compat VDSO issue.

But the VVAR macro will be not a part of this patch set. If you depend
on this, feel free to create one. From my point of view this is not
feasible without a macro hacking, because the address accessing the vvar
area differs in kernel and VDSO user mode.

I also see no redundant mapping. There are two modes, one is the map of
the kernel area the other maps the VDSO into the user space area. This
is exactly the behaviour of the origin VDSO implementation.
 
> Also, the usual convention is to use [PATCH v2 3/8], etc, as subjects,
> to keep separate versions separate.
> 

Will do this.

- Stefani


