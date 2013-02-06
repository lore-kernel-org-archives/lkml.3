Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3BFKX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 05:23:58 -0500
Received: from 8bytes.org ([85.214.48.195]:37178 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3BFKXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:23:55 -0500
Date: Wed, 6 Feb 2013 11:23:50 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: lethal@linux-sh.org, magnus.damm@gmail.com, linux@arm.linux.org.uk,
        horms@verge.net.au, laurent.pinchart@ideasonboard.com,
        matsu@igel.co.jp, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dhobsong@igel.co.jp, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/4] iommu/shmobile: Add iommu driver for Renesas
 IPMMU modules
Message-ID: <20130206102348.GA2634@8bytes.org>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
 <1358765669-14567-2-git-send-email-hdk@igel.co.jp>
 <20130201135456.GG25591@8bytes.org>
 <20130205.194209.52400155.hdk@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205.194209.52400155.hdk@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Feb  6 11:23:53 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51122f3922971615814882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 07:42:09PM +0900, Hideki EIRAKU wrote:
> From: Joerg Roedel <joro@8bytes.org>

> > Why is it necessary to call dma_map_single() for IOMMU page-tables?
> > usually the dma_* functions call into IOMMU drivers, so why are they
> > used inside an IOMMU driver?
> 
> I use dma_map_single() for flushing the page table to the IOMMU
> device.  The dma_map_ops set by arch/arm/mm/dma-mapping.c are
> per-device (unlike the intel-iommu).  The dma_* functions call into
> IOMMU drivers if the device is attached by arm_iommu_attach_device(),
> but I am using a NULL device here, so that shouldn't happen.

Okay, I applied the patches to a new arm/shmobile branch. Will push them
out soon. The use of the dma_* functions is dangerous anyway (but it
works for now). Please send a follow-on patch to replace the use of the
dma_* functions in the driver with explicit flushing routines. This
protects the code from any future changes in the dma-api implementation.


	Joerg


