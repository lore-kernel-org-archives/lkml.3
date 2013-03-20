Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab3CTLrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:47:51 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34945 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3CTLrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:47:49 -0400
Date: Wed, 20 Mar 2013 11:47:45 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Message-ID: <20130320114745.GA448@srcf.ucam.org>
References: <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
 <20130319172506.GA11969@srcf.ucam.org>
 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
 <20130319182810.GA13003@srcf.ucam.org>
 <1363718456.2377.71.camel@dabdike.int.hansenpartnership.com>
 <20130319185003.GA13301@srcf.ucam.org>
 <1363734031.2377.77.camel@dabdike.int.hansenpartnership.com>
 <20130319231756.GA21071@srcf.ucam.org>
 <1363766403.2373.3.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363766403.2373.3.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 08:00:03AM +0000, James Bottomley wrote:

> I agree with this.  But I do think the volatile secret key scheme, where
> you discard the key immediately after use is the more secure one because
> it relies on fewer secrets (and, indeed, no secrets at all after the
> event).  It's a case where transparency encourages better security
> architecture.

That somewhat depends what you're securing against. There's an argument 
that reusing this key is actually sufficiently secure so long as the 
only way to obtain it is with physical access to the machine - that way 
you don't have an nvram update cycle every boot. Exposing these 
variables to userspace doesn't make it impossible to produce a secure 
system, but it does remove some choices that were previously available.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
