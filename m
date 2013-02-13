Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902Ab3BMIQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:16:33 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:37516 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3BMIQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:16:32 -0500
Date: Wed, 13 Feb 2013 12:16:27 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@amd.com, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, Asias He <asias@redhat.com>
Subject: Re: [tip:x86/cpu] x86, AMD: Enable WC+ memory type on family 10
 processors
Message-ID: <20130213081627.GL22249@moon>
References: <1359495169-23278-1-git-send-email-ostr@amd64.org>
 <tip-f0322bd341fd63261527bf84afd3272bcc2e8dd3@git.kernel.org>
 <20130213001626.GA30512@pd.tnic>
 <511ADC79.6040007@zytor.com>
 <CAOJsxLH71KTFbkm5h9AuquC04cJ0NmtCiUjSevkxqLYRBPPi8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLH71KTFbkm5h9AuquC04cJ0NmtCiUjSevkxqLYRBPPi8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:06:25AM +0200, Pekka Enberg wrote:
> On Wed, Feb 13, 2013 at 2:21 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >>> +                       rdmsrl(MSR_AMD64_BU_CFG2, value);
> >>> +                       value &= ~(1ULL << 24);
> >>> +                       wrmsrl(MSR_AMD64_BU_CFG2, value);
> >>> +               }
> >>>         }
> >>>
> >>>         rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
> >>
> >>
> >> However, the more serious issue is that that same kernel #GPs when
> >> booted in kvm. It seems it cannot stomach that specific MSR, see the
> >> second "<-- trapping instruction" below and that BU_CFG2 MSR landing in
> >> %ecx in the line before that.
> >>
> >> Oh, and this happens only with the kvm executable (/usr/bin/kvm) in
> >> debian testing. If I use qemu from git, it passes over init_amd just
> >> fine.
> >>
> >> Hmmm..
> >
> > It #GPs on an MSR, which tends to be a bug in the VMM; RDMSR/WRMSR generally
> > kick out to the VMM.  There isn't a huge lot of work we can do about that...
> >
> > I think Qemu defaults to ignoring unknown-to-it MSRs whereas maybe kvmtool
> > croaks?  Pekka?
> 
> I think we should also be fine. Cyrill?

Never was #gp on unknown msr register access, so I think
we're safe. But maybe Borislav may give lkvm a shot just
to be sure?
