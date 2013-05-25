Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3EYMsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 08:48:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48180 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab3EYMsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 08:48:20 -0400
Date: Sat, 25 May 2013 21:48:14 +0900
From: Tejun Heo <tj@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Message-ID: <20130525124814.GA8489@mtj.dyndns.org>
References: <20130522221737.GA12339@mtj.dyndns.org>
 <519DC926.4000106@redhat.com>
 <20130523090222.GA26592@mtj.dyndns.org>
 <519DE5AD.7080303@redhat.com>
 <20130524014405.GB16882@mtj.dyndns.org>
 <519F12FF.6090809@redhat.com>
 <CAOS58YODjkSF=V7wADqbn_z8c6bmj=r03hWxEs5B1O+1cd0n6g@mail.gmail.com>
 <1369456502.5008.5.camel@dabdike>
 <20130525083713.GA6179@mtj.dyndns.org>
 <51A09D1D.3040706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A09D1D.3040706@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 01:14:37PM +0200, Paolo Bonzini wrote:
> > Don't think we can.  It'd be a behavior change clearly visible to
> > userland at this point.
> 
> We can (and even for MMC) if it is a build-time configuration knob.  It
> would satisfy those people who want the CVE fixed, as long as userspace
> gets some configurability.

I don't think that's a good idea.  We can gradually try to phase it
out by triggering warning message if SG_IO commands are issued to !MMC
devices but I'm not sure that'd be worth the effort.

> > * Merge the patch to give out SG_IO access along with write access, so
> >   the use cases which want to give out SG_IO access can do so
> >   explicitly and be fully responsible for the device.  This makes
> >   sense to me.  If one wants to be allowed to issue raw commands to
> >   the hardware, one takes the full responsibility.
> 
> That's not possible; it would make it impossible to do things like using
> a privileged helper to open the file and passing it back via SCM_RIGHTS
> to an unprivileged program (running as the user).  This is the ptrace
> attack that you mentioned.

I have no idea what you're talking about.  I'm describing the same
thing you implemented and posted.

-- 
tejun
