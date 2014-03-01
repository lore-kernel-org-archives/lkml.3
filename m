Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaCAOC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 09:02:28 -0500
Received: from www84.your-server.de ([213.133.104.84]:54035 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaCAOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 09:02:26 -0500
Message-ID: <1393682521.982.26.camel@wall-e.seibold.net>
Subject: Re: [PATCH v2 0/4] vDSO fixes, on top of tip/x86/vdso
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sat, 01 Mar 2014 15:02:01 +0100
In-Reply-To: <CALCETrW5Z07cn+-r2qnyUDaC_XMujYtcT4zV2ztCOwo4qbfj9w@mail.gmail.com>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
	 <cover.1393545985.git.luto@amacapital.net>
	 <1393572804.1019.14.camel@wall-e.seibold.net>
	 <CALCETrW5Z07cn+-r2qnyUDaC_XMujYtcT4zV2ztCOwo4qbfj9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 28.02.2014, 12:15 -0800 schrieb Andy Lutomirski:
> On Thu, Feb 27, 2014 at 11:33 PM, Stefani Seibold <stefani@seibold.net> wrote:
> > Am Donnerstag, den 27.02.2014, 16:18 -0800 schrieb Andy Lutomirski:
> >> I'd still like someone else to confirm that the 32-bit vDSO is working
> >> on all common configurations before I'm happy with it, but this should
> >> be a considerable improvement.
> >>
> >> Someone who maintains the clock code should review the changes in:
> >>
> >>     commit 0fc8a237cbe98a06962f5ea37d24fc2369e23c74
> >>     Author: Stefani Seibold <stefani@seibold.net>
> >>     Date:   Wed Feb 19 10:09:10 2014 +0100
> >>
> >>         x86, vdso: Add 32-bit VDSO time support for the 64-bit kernel
> >>
> >> very carefully.
> >>
> >> There's still something extremely questionable about VDSO_PAGES in the
> >> 32-bit vDSO code.  It appears to be terminally screwed up, and AFAICS it
> >> only works at all because none of the 32-bit vDSO images ever exceed
> >> 4096 bytes.
> >>
> >
> > The 4096 bytes limit was not introduced by the patch set. It is still
> > there for compatibility reason.
> 
> Compatibility with what?  And it doesn't look like there's a sane 4k
> "limit".  It looks like the code with confuse itself and crash if the
> image exceeds 4k.
> 

Compatibility with the VDSO compat mode! Since the address is fixed in
the FIXMAP area and should not changed there is no easy way to extend
the size of the code.

One possibility is to move the VDSO code before the VDSO compat fixmap
area and create a helper VDSO for the VDSO compat fixmap page, which has
a kind a trampolin code which calls the real VDSO. But this would result
in a performance regression for the VDSO compat mode.

- Stefani

