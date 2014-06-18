Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaFRPyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:54:00 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:49695 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaFRPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:53:58 -0400
Date: Wed, 18 Jun 2014 16:53:56 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Mark Salter <msalter@redhat.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] arm64: support reboot and power off via EFI runtime
Message-ID: <20140618155356.GR24049@console-pimps.org>
References: <1403023514-1352-1-git-send-email-msalter@redhat.com>
 <CAL_JsqJUMMRwUn+PUiFweDOywgLCbKiWfDTLDSfJqE9oTV5gYw@mail.gmail.com>
 <1403102507.32688.42.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403102507.32688.42.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun, at 10:41:47AM, Mark Salter wrote:
> On Wed, 2014-06-18 at 09:09 -0500, Rob Herring wrote:
> > On Tue, Jun 17, 2014 at 11:45 AM, Mark Salter <msalter@redhat.com> wrote:
> > > Add handlers for arm_pm_resestart and pm_power_off which use EFI
> > 
> > typo.
> > 
> > > runtime services ResetSystem call to perform the functions. These
> > > handlers are only installed if no handler currently exists. This
> > > allows PSCI to take priority over EFI for these functions.
> > >
> > > Signed-off-by: Mark Salter <msalter@redhat.com>
> > > ---
> > >  arch/arm64/kernel/efi.c | 40 ++++++++++++++++++++++++++++++++++++++++
> > 
> > Where's the arm32 version? Surely this could be shared with all
> > arches. pm_power_off is at least architecturally independent. We
> > should do the same for restart/reboot. I'm not saying do that now, but
> > at least put it in the right place for that to happen.
> > 
> > Rob
> 
> Good point. So the right place would be drivers/firmware/efi I think.
> Add a CONFIG_EFI_RESET with default off. I suppose we could also
> go ahead and s/arm_pm_restart/pm_restart/ kernel-wide or have an
> ifdef in the code (or depends on ARM64 || ARM in Kconfig) until we
> do so.
> 
> [Matt Fleming CC'd]
 
Heh, this is timely. I wrote some patches last week to use
EfiResetSystem() for ACPI Hardware Reduced platforms,

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=efi/reboot

so it would definitely be good if we could try and solve both of our
problems simultaneously.

Let me post that patch series to kickoff the discussion.

-- 
Matt Fleming, Intel Open Source Technology Center
