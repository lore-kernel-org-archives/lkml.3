Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaCASTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 13:19:55 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:33370 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbaCASTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 13:19:54 -0500
Date: Sat, 1 Mar 2014 18:19:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
Message-ID: <20140301181951.GA984@srcf.ucam.org>
References: <53102AB9.40600@linux.intel.com>
 <20140228062325.GA3246@srcf.ucam.org>
 <53102F3C.4020806@linux.intel.com>
 <20140228064413.GA4900@srcf.ucam.org>
 <531032A0.8090903@linux.intel.com>
 <5310CBB7.4030407@linux.intel.com>
 <53110977.8080907@linux.intel.com>
 <53121496.8060603@linux.intel.com>
 <20140301172256.GA29417@srcf.ucam.org>
 <53121961.2080209@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53121961.2080209@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2014 at 01:31:13AM +0800, Li, Aubrey wrote:
> On 2014/3/2 1:22, Matthew Garrett wrote:
> > No. The EFI reboot call jumps into the firmware and executes code.
> 
> Firmware actually writes CF9.

Your firmware writes CF9. Other firmware may hit some other addresses. 
We don't know what the behaviour of that firmware will be if it takes a 
fault in the process.

By and large the rule when it comes to dealing with firmware interaction 
is "Copy Windows as closely as possible". Older versions of Windows 
didn't appear to hit the EFI reset vector, but if they're doing it now 
then we should do the same - but we should only do so once we have an 
expectation that it'll work rather than dumping an oops all over 
someone's screen. And, as I keep saying, the code to handle this case is 
written. Let's just make sure that your code ends up behind it in the 
queue.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
