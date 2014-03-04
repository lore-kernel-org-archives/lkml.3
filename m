Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbaCDPGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:06:25 -0500
Received: from 8bytes.org ([85.214.48.195]:58514 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757276AbaCDPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:06:23 -0500
Date: Tue, 4 Mar 2014 16:06:17 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Bill Sumner <bill.sumner@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        zhenhua@hp.com
Subject: Re: [PATCHv3 0/6] Crashdump Accepting Active IOMMU
Message-ID: <20140304150611.GE2799@8bytes.org>
References: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389391652-52422-1-git-send-email-bill.sumner@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar  4 16:06:22 2014
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5315ebee20861690830819
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On Fri, Jan 10, 2014 at 03:07:26PM -0700, Bill Sumner wrote:
> Bill Sumner (6):
>   Crashdump-Accepting-Active-IOMMU-Flags-and-Prototype
>   Crashdump-Accepting-Active-IOMMU-Utility-functions
>   Crashdump-Accepting-Active-IOMMU-Domain-Interfaces
>   Crashdump-Accepting-Active-IOMMU-Copy-Translations
>   Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
>   Crashdump-Accepting-Active-IOMMU-Call-From-Mainline
> 
>  drivers/iommu/intel-iommu.c | 1293 ++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 1225 insertions(+), 68 deletions(-)

This is a pretty big change, before merging I would like to get more
eyes on it. Please make sure you get more reviews on the code and the
general concept. A few things I noticed while looking at it:

* You put a lot of code into #define CONFIG_CRASH_DUMP. Isn't the same
  approach necessary to for KEXEC?

* Please get rid of all the pr_debug stuff.

* I think it makes sense to put the functions to access the IOMMU
  configuration values of the old kernel into a new file. This is better
  than adding over 1000 new lines to intel-iommu.c

* I have seen your new single-patch for this change. A single patch with
  more than 1200 changed lines is not something anyone is willing to
  review. Please split the patches again in a meaningful and bisectable
  way.


Thanks,

	Joerg


