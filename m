Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbaDITXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:23:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDITXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:23:21 -0400
Date: Wed, 9 Apr 2014 12:25:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: *S-Par-Maintainer <SParMaintainer@unisys.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unisys: staging: Check for s-Par firmware before
 initializing s-Par modules
Message-ID: <20140409192552.GA11506@kroah.com>
References: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F09@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 02:04:50PM -0500, Romer, Benjamin M wrote:
> This patch adds a function, is_spar_system(), to check that s-Par
> firmware is present, and then uses this function at the beginning of
> each module to verify that the modules are being run on an s-Par system
> before beginning initialization. If the firmware is not detected, the
> module will return a failure code.
> 
> Checking for s-Par firmware uses the cpuid instruction to verify that
> the processor is running with virtualization turned on, and then uses a
> second cpuid instruction to check that the hypervisor ID is
> "UnisysSpar64".

Why not use the cpuid infrastructure to automatically load/bind your
code and not rely on it being loaded "by hand"?  Doesn't that work for
CPU types already?

> Additionally, some minor clean-up was done on copyright tags and
> unnecessary messages were removed from the visorchipset_main() function.

Patches need to do only one thing, so can you please split this up in to
multiple patches, each one only doing one thing.

> This patch was tested with KVM to ensure that the modules do not load
> when s-Par firmware is not present, and tested with s-Par 4.0.12 to
> verify that the modules load correctly when the firmware is present.
> 
> Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>

You forgot to add a "Reported-by:" line here, and possibly a
"Tested-by:" if someone tested it and reported that it solved the
problem.  Proper attribution is very important.

thanks,

greg k-h
