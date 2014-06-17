Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbaFQOqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:46:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54985 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972AbaFQOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:46:33 -0400
Date: Tue, 17 Jun 2014 15:46:15 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: lenb@kernel.org, robert.moore@intel.com, lv.zheng@intel.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com
Subject: Re: [PATCH 1/4] ACPI: Support _OSI("Darwin") correctly
Message-ID: <20140617144614.GA16934@srcf.ucam.org>
References: <1401640436-1947-1-git-send-email-matthew.garrett@nebula.com>
 <1401640436-1947-2-git-send-email-matthew.garrett@nebula.com>
 <7712179.sDPAd6Ubry@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7712179.sDPAd6Ubry@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:11:36PM +0200, Rafael J. Wysocki wrote:
> On Sunday, June 01, 2014 12:33:53 PM Matthew Garrett wrote:
> > Apple hardware queries _OSI("Darwin") in order to determine whether the
> > system is running OS X, and changes firmware behaviour based on the answer.
> > The most obvious difference in behaviour is that Thunderbolt hardware is
> > forcibly powered down unless the system is running OS X. The obvious solution
> > would be to simply add Darwin to the list of supported _OSI strings, but this
> > causes problems.
> > 
> > Recent Apple hardware includes two separate methods for checking _OSI
> > strings. The first will check whether Darwin is supported, and if so will
> > exit. The second will check whether Darwin is supported, but will then
> > continue to check for further operating systems. If a further operating
> > system is found then later firmware code will assume that the OS is not OS X.
> > This results in the unfortunate situation where the Thunderbolt controller is
> > available at boot time but remains powered down after suspend.
> > 
> > The easiest way to handle this is to special-case it in the Linux-specific
> > OSI handling code. If we see Darwin, we should answer true and then disable
> > all other _OSI vendor strings.
> > 
> > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> 
> Does applying this patch without the rest of the series makes things worse
> or better on the machines in question (or perhaps it doesn't matter at all
> alone)?

On its own, I think this will do nothing.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
