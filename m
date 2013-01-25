Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416Ab3AYDUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:20:19 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57474 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3AYDUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:20:14 -0500
Date: Fri, 25 Jan 2013 03:20:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Howells <dhowells@redhat.com>
Cc: Kyle McMartin <kyle@redhat.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, jstancek@redhat.com,
        Stephan Mueller <stephan.mueller@atsec.com>
Subject: Re: [PATCH] MODSIGN: flag modules that use cryptoapi and only
 panic if those are unsigned
Message-ID: <20130125032007.GA15926@srcf.ucam.org>
References: <20130124190610.GI6538@redacted.bos.redhat.com>
 <20130122184357.GD6538@redacted.bos.redhat.com>
 <8615.1358940375@warthog.procyon.org.uk>
 <50FFFF48.6020608@atsec.com>
 <9620.1359072894@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9620.1359072894@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 12:14:54AM +0000, David Howells wrote:

> You can't rely on someone trying to sneak a dodgy crypto module in to set the
> flag when they build it.  The detection thus needs to be done in the kernel
> during the module load.
> 
> Can you search the module image for "crypto_register_" I wonder?  If that's
> there, it's a crypto module.

If you're trying to protect against malice rather than accident, what's 
going to stop the module from just finding and modifying data structures 
itself? If you want to panic if you've just loaded something that might 
compromise your crypto implementations, you've got to panic on all 
unsigned module loads.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
