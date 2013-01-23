Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3AWHGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:06:10 -0500
Received: from 8bytes.org ([85.214.48.195]:45271 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3AWHGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:06:08 -0500
Date: Wed, 23 Jan 2013 08:06:04 +0100
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, bp@alian8.de,
        linux-kernel@vger.kernel.org, udovdh@xs4all.nl,
        ssg.sos.patches@amd.com
Subject: Re: [PATCH 1/1] AMD Family15h Model10-1Fh erratum 746 Workaround
Message-ID: <20130123070604.GT25591@8bytes.org>
References: <1358896750-5199-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358896750-5199-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 23 08:06:05 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50ff8bdd22976589219376
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 05:19:10PM -0600, Suthikulpanit, Suravee wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> @@ -1171,6 +1195,8 @@ static int iommu_init_pci(struct amd_iommu *iommu)
>  		for (i = 0; i < 0x83; i++)
>  			iommu->stored_l2[i] = iommu_read_l2(iommu, i);
>  	}
> +	
> +	amd_iommu_apply_erratum_746(iommu);

This will also be applied to RD890 IOMMUs, right? This workaround should
be limited to Trinity IOMMUs.

Udo, can you please test if you can trigger the erratum again with this
patch?


	Joerg


