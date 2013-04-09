Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935170Ab3DIJlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:41:36 -0400
Received: from 8bytes.org ([85.214.48.195]:35259 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab3DIJle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:41:34 -0400
Date: Tue, 9 Apr 2013 11:41:32 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] iommu/amd: Add logic to decode AMD IOMMU event flag
Message-ID: <20130409094132.GD6858@8bytes.org>
References: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364947610-3327-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 11:41:33 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5163e24d23676244681801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:06:50PM -0500, Suthikulpanit, Suravee wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Add logic to decode AMD IOMMU event flag based on information from AMD IOMMU specification.
> This should simplify debugging IOMMU errors.  Also, dump DTE information in additional cases.
> 
> This is an example:
> AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0000000000000000 flags=0x0fff]
> AMD-Vi: Flags details: Guest NX=1 User Intr Present Write No-Perm Rsrv-Bit Translation
> AMD-Vi: Type of error: (0x7) 
> AMD-Vi: (Note: Please refer to AMD IOMMU specification for details.)
> AMD-Vi: DTE[0]: 6000003fa75e2403
> AMD-Vi: DTE[1]: 0000000000000014
> AMD-Vi: DTE[2]: 2000003fa5e09011
> AMD-Vi: DTE[3]: 0000000000000000

This example should look like this instead:

AMD-Vi: Event logged [IO_PAGE_FAULT device=51:00.0 domain=0x0000 address=0x0 flags: G NX US I P Wr Rsvd Tr]

by default. When the user passes amd_iommu=verbose on the cmd-line then
you can print additional information like "type of error" or the dump
the DTE.


	Joerg


