Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab3LDCyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 21:54:13 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41997 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3LDCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 21:54:10 -0500
Date: Wed, 4 Dec 2013 02:54:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv2 2/2] ACPI/platform: Add ACPI ID for Intel MBI device
Message-ID: <20131204025407.GA26448@srcf.ucam.org>
References: <1385100357-5459-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-1-git-send-email-david.e.box@linux.intel.com>
 <1386115178-7559-3-git-send-email-david.e.box@linux.intel.com>
 <20131204013001.GA25037@srcf.ucam.org>
 <20131204021703.GA8282@linux.intel.com>
 <20131204022130.GA26084@srcf.ucam.org>
 <20131204024452.GB8282@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204024452.GB8282@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:44:52PM -0800, David E. Box wrote:
> On Wed, Dec 04, 2013 at 02:21:30AM +0000, Matthew Garrett wrote:
> > Well sure, but why do you need to be a platform device at all? This 
> > functionality was intended for cases where we already have a driver for 
> > the part that enumerated it via some other mechanism. If the driver's 
> > only intended for ACPI systems then why not just be an ACPI device?
> > 
> 
> It was my understanding that with ACPI 5.0 it was becoming more common to use
> ACPI ID's exclusively for device enumeration. I originally wrote this as an
> acpi_bus driver but Rafeal advised me that the model is being phased out and
> suggeted the platform model instead.

If you're not adding ACPI support to an existing platform driver, you 
shouldn't be adding entries to acpi_platform.c. I'm not actually happy 
that I merged the ideapad-laptop patch that did the same thing - I'm 
inclined to revert it, because this really is an ugly way to do things.

Rafael, why did we convert the AC driver this way? It means we have to 
keep track of ACPI IDs in multiple places, which is worth it when it 
avoids having to write a pile of new code (such as the sdhci case) but 
doesn't seem to provide benefits otherwise.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
