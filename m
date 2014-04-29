Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbaD2HQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:16:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57219 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbaD2HQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:16:09 -0400
Message-ID: <535F5173.5030301@zytor.com>
Date: Tue, 29 Apr 2014 00:14:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Lutomirski <amluto@gmail.com>
CC: comex <comexk@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com> <535EDEC5.7030209@zytor.com> <535EDF67.3090501@linux.intel.com> <CAObL_7HVOjpgp0=Ot9ih2tb6x7xv6MGstu-Krad+rrO4cVqyTg@mail.gmail.com> <CAObL_7FZRji6ivcVvTQ4r=KULCA760fr_wKqkjaYKGL=KLOQRA@mail.gmail.com> <535F108C.9010001@linux.intel.com> <535F205F.9040101@zytor.com> <535F2C66.9090902@zytor.com>
In-Reply-To: <535F2C66.9090902@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 09:36 PM, H. Peter Anvin wrote:
> 
> There are still things that need fixing: we need to go through the
> espfix path even when returning from NMI/MC (which fortunately can't
> nest with taking an NMI/MC on the espfix path itself, since in that case
> we will have been interrupted while running in the kernel with a kernel
> stack.)
> 
> (Cc: Rostedt because of the NMI issue.)
> 

NMI is fine: we go through irq_return except for nested NMI.  There are
only three IRETs in the kernel (irq_return, nested_nmi_out, and the
early trap handler) and all of them are good.

I think we just need to clean up the PV aspects of this and then we
should be in good shape.  I have done a bunch of cleanups to the
development git tree.

I'm considering making 16-bit segment support a EXPERT config option for
both 32- and 64-bit kernels, as it seems like a bit of a waste for
embedded systems which don't need this kind of backward compatibility.
Maybe that is something that can be left for someone else to implement
if they feel like it.

	-hpa

