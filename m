Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061Ab3FEXDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:03:14 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36349 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab3FEXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:03:13 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/3] irq: Set multiple MSI descriptor data for multiple IRQs
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, tglx@linutronix.de,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
In-Reply-To: <1358235536-32741-2-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com> <1358235536-32741-2-git-send-email-qiudayu@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 00:03:08 +0100
Message-Id: <20130605230308.8CC093E10E4@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 15:38:54 +0800, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> Multiple MSI only requires the IRQ in msi_desc entry to be set as
> the value of irq_base.
> 
> This patch implements the above mentioned technique.
> 
> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>

Hi Mike,

question below...

> ---
> +int irq_set_multiple_msi_desc(unsigned int irq_base, unsigned int nvec,
> +				struct msi_desc *entry)
> +{
> +	unsigned long flags, i;
> +	struct irq_desc *desc;
> +
> +	for (i = 0; i < nvec; i++) {
> +		desc = irq_get_desc_lock(irq_base + i, &flags,
> +					IRQ_GET_DESC_CHECK_GLOBAL);
> +		if (!desc)
> +			return -EINVAL;
> +		desc->irq_data.msi_desc = entry;
> +		if (i == 0 && entry)
> +			entry->irq = irq_base;

It's not clear to me why this code only sets the irq value for the first
desc. Why don't the other descs in the array want (irq_base + i) here? A
comment describing what is going on would be appropriate and helpful.

g.
