Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaCAUVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:21:47 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34271 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaCAUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:21:46 -0500
Date: Sat, 1 Mar 2014 20:21:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140301202139.GA9759@srcf.ucam.org>
References: <53102AB9.40600@linux.intel.com>
 <20140228062325.GA3246@srcf.ucam.org>
 <53102F3C.4020806@linux.intel.com>
 <20140228064413.GA4900@srcf.ucam.org>
 <531032A0.8090903@linux.intel.com>
 <5310CBB7.4030407@linux.intel.com>
 <53110977.8080907@linux.intel.com>
 <53121496.8060603@linux.intel.com>
 <20140301172256.GA29417@srcf.ucam.org>
 <53123DCF.7040500@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53123DCF.7040500@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2014 at 12:06:39PM -0800, H. Peter Anvin wrote:

> Be careful.  This is *exactly* what I tried back in checkin
> 14d7ca5c575853664d8fe4f225a77b8df1b7de7d.  We had to back that out quite
> quickly.

It's the difference between trying it before the keyboard controller and 
trying it after the keyboard controller and ACPI. It seems that it broke 
some systems where the keyboard controller worked - if we've hit the 
keyboard controller and ACPI twice, and the system is still alive, and 
if we have standard PCI ports, it doesn't seem like poking them is 
likely to make anything actively worse.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
