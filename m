Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3HDOEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:04:39 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55130 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab3HDOEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:04:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] acpi: video: improve quirk check
Date: Sun, 04 Aug 2013 16:14:52 +0200
Message-ID: <1871173.mr3paKNt7s@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s2CnJ5O5wspeG3-hYOTKwBLHbaZ1AbfHQ=rYEQRpeJW2g@mail.gmail.com>
References: <1375472229-1563-1-git-send-email-felipe.contreras@gmail.com> <CAOzJMDQwte=7VtfQzW9DyQpt+pbe48STDEGhLis62Y0tG78G1w@mail.gmail.com> <CAMP44s2CnJ5O5wspeG3-hYOTKwBLHbaZ1AbfHQ=rYEQRpeJW2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 04, 2013 01:54:21 AM Felipe Contreras wrote:
> On Sat, Aug 3, 2013 at 8:47 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> > On Sun, Aug 4, 2013 at 6:20 AM, Felipe Contreras
> > <felipe.contreras@gmail.com> wrote:
> >> On Sat, Aug 3, 2013 at 4:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> >>> Do we still need to revert commit efaa14c if this patch is applied?
> >>
> >> I guess not. At least in this machine changing the backlight works
> >> correctly, whereas in v3.11-rc3 it was all weird, and v3.7-v3.10
> >> didn't work at all. I cannot see how it would affect negatively other
> >> machines.
> >
> > That commit makes hotkey emit notifications, and it's not the
> > problem of "booting into a black screen", that problem is due to
> > broken _BQC.
> 
> The broken _BQC has been there for quite some time, hasn't it?
> 
> Either way, without efaa14c, changing the backlight doesn't work at
> all either way, so there's no black screen, because there cannot be.
> 
> > BTW, the efaa14c will also make screen off at level 0 according
> > to Felipe, who consider this is a bug. But since it is required to
> > let firmware emit notifications on hotkey press, I think user will
> > want it.
> 
> With or without efaa14c, level 0 makes the screen off, or at least it
> would, if the control worked at all. So efaa14c is one step forward,
> but two back, my patch removes the two steps back, but we are still
> not at the level of what my blacklisting patch does, for that we would
> need to fix two issues:
> 
> 1. Fix the retrieval of the last level at boot
> 2. Fix level 0 (yes, I consider that a regression)
> 
> But we cannot achieve either of those for v3.11, the only
> possibilities seem to be either a) revert efaa14c, or b) keep it and
> apply my patch. Anything else doesn't seem to be a possible or
> sensible option, and I vote for b).

I've already said I'm going to do that for 3.11.

Thanks,
Rafael

