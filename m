Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3CSS2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:28:16 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50420 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab3CSS2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:28:15 -0400
Date: Tue, 19 Mar 2013 18:28:10 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-efi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/efi: pull NV+BS variables out before we exit boot
 services
Message-ID: <20130319182810.GA13003@srcf.ucam.org>
References: <1363596014.2412.8.camel@dabdike.int.hansenpartnership.com>
 <20130319014850.GA28934@srcf.ucam.org>
 <1363680885.2377.11.camel@dabdike.int.hansenpartnership.com>
 <20130319163531.GA10879@srcf.ucam.org>
 <1363713447.2377.60.camel@dabdike.int.hansenpartnership.com>
 <20130319172506.GA11969@srcf.ucam.org>
 <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363717411.2377.68.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 06:23:31PM +0000, James Bottomley wrote:

> The scheme we discussed, unless something radically changed, was to
> convey a temporary key pair via a mechanism to later verify the
> hybernate kernel on a resume.  That only requires reboot safe knowledge
> of the public key.  The private key can be conveyed in BS only (not NV),
> and should be consumed (as in deleted) by the OS when it receives it, so
> it wouldn't be exposed by this patch.

It requires the key to survive the system being entirely powered down, 
which means it needs to be BS+NV. It shouldn't be possible for userspace 
to access this key.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
