Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3G3B3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 21:29:31 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55883 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751266Ab3G3B3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 21:29:30 -0400
Message-ID: <1375147768.2075.91.camel@joe-AO722>
Subject: Re: [PATCH v2] iommu: Add event tracing feature to iommu
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: joro@8bytes.org, alex.williamson@redhat.com, Varun.Sethi@freescale.com,
        aik@ozlabs.ru, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, tony@atomide.com, ohad@wizery.com,
        andreas.herrmann@calxeda.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        shuahkhan@gmail.com
Date: Mon, 29 Jul 2013 18:29:28 -0700
In-Reply-To: <1375147366-2922-1-git-send-email-shuah.kh@samsung.com>
References: <1375147366-2922-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-29 at 19:22 -0600, Shuah Khan wrote:
> Add tracing feature to iommu to report various iommu events. Classes
> iommu_group, iommu_device, iommu_map_unmap, and iommu_amd_event are defined.

Hi again Shuah

> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
[]
> @@ -2159,6 +2160,15 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
>  	printk(KERN_INFO
>  	       "IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
>  	       pci_name(pdev), start, end);
> +
> +	{
> +		trace_amd_event("Event", 0x1, pdev->devfn, 0, start, 2);
> +		trace_remove_device_from_group(0, &pdev->dev);
> +		trace_attach_device_to_domain(&pdev->dev);
> +		trace_detach_device_from_domain(&pdev->dev);
> +		trace_map(start, end, 1024);
> +		trace_unmap(start, end, 1024);
> +	}

Aren't these parentheses superfluous and
so the indent too deep too?


