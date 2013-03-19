Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3CSRZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:25:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49750 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab3CSRZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:25:11 -0400
Date: Tue, 19 Mar 2013 17:25:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Message-ID: <20130319172506.GA11969@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
 <20130319014850.GA28934@srcf.ucam.org>
 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
 <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 05:17:27PM +0000, James Bottomley wrote:
> On Tue, 2013-03-19 at 16:35 +0000, Matthew Garrett wrote:
> > On Tue, Mar 19, 2013 at 08:14:45AM +0000, James Bottomley wrote:
> > 
> > > Any security assumptions that rely on inability to read certain
> > > information aren't really going to be that secure.  Inability to modify,
> > > sure, but inability to read, not really.
> > 
> > Well, I guess that's public/private key cryptography screwed.
> 
> Well, OK, it's ex-BIOS writers we're dealing with, so I won't say no-one
> would be stupid enough to come up with a security scheme embedding
> Private Keys in BS+NV variables, but I would have thought the fact that
> Linux would blow the lid off it might be a good incentive not to do it
> and thus a plus point for this patch.

The hibernation scheme we'd discussed involved having the first stage 
loader generating a keypair and handing half of it to the OS for 
encryption of the hibernation partition, then handing the other half to 
the OS on the next boot so it can decrypt it. That requires non-RT 
variables to be restricted from OS visibility.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
