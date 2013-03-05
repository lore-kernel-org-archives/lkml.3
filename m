Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab3CEClu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:41:50 -0500
Received: from linux-sh.org ([111.68.239.195]:45206 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3CEClt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:41:49 -0500
Date: Tue, 5 Mar 2013 11:41:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de
Subject: Re: [PATCH 2/3] irq: Add hw continuous IRQs map to virtual
 continuous IRQs support
Message-ID: <20130305024110.GB14275@linux-sh.org>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358235536-32741-3-git-send-email-qiudayu@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 03:38:55PM +0800, Mike Qiu wrote:
> Adding a function irq_create_mapping_many() which can associate
> multiple MSIs to a continous irq mapping.
> 
> This is needed to enable multiple MSI support for pSeries.
> 
> +int irq_create_mapping_many(struct irq_domain *domain,
> +		irq_hw_number_t hwirq_base, int count)
> +{

Other than the other review comments already made, I think you can
simplify this considerably by simply doing what irq_create_strict_mappings() does,
and relaxing the irq_base requirements.

In any event, as you are creating a new interface, I don't think you want
to carry around half of the legacy crap that irq_create_mapping() has to
deal with. We made the decision to avoid this with irq_create_strict_mappings()
intentionally, too.
