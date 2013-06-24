Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3FXHlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:41:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36936 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585Ab3FXHlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:41:21 -0400
Date: Mon, 24 Jun 2013 09:41:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: suravee.suthikulpanit@amd.com, iommu@lists.linux-foundation.org,
        ddutile@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] iommu/amd: IOMMU Error Reporting/Handling/Filtering
Message-ID: <20130624074117.GA26766@pd.tnic>
References: <1369250155-12226-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130621151459.GK11309@8bytes.org>
 <20130621155933.GA24385@pd.tnic>
 <20130621162455.GN11309@8bytes.org>
 <20130621173625.GH22006@pd.tnic>
 <20130624072648.GQ11309@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130624072648.GQ11309@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:26:48AM +0200, Joerg Roedel wrote:
> On Fri, Jun 21, 2013 at 07:36:25PM +0200, Borislav Petkov wrote:
> 
> > IOW, what specific functionality in EDAC are you actually thinking of?
> 
> Okay, my believe until yesterday was that EDAC provides a consistent way
> to report hardware errors to userspace. That seems to be wrong. This in
> mind I think having a trace-point for that makes sense.
> 
> But this trace-point must not be specific to a single IOMMU driver, I
> want it generic enough so that it can be used by all common IOMMU
> drivers to report hardware misbehaviors to userspace.

Yep, either that or you define a TRACE_EVENT_CLASS which contains common
error info which all iommu drivers report, and those which want to
report more specific information pertaining only to them, then they need
to define a tracepoint based on the iommu event class.

Check the sources for examples.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
