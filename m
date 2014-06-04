Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaFDNjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:39:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:37136 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaFDNjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:39:41 -0400
Date: Wed, 4 Jun 2014 15:39:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH 01/21] irq: add devres version of OF IRQ mapping
 routines
In-Reply-To: <1401880402-30091-2-git-send-email-nyushchenko@dev.rtsoft.ru>
Message-ID: <alpine.DEB.2.10.1406041538270.3319@nanos>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru> <1401880402-30091-2-git-send-email-nyushchenko@dev.rtsoft.ru>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, nyushchenko@dev.rtsoft.ru wrote:

> From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
> 
> Many drivers use devres to manage their resources, and at the same time
> use irq_of_parse_and_map() / irq_dispose_mapping(). This creates problem
> on driver unload paths and on error paths:
> - it is invalid to call irq_dispose_mapping() while IRQ handler is still
>   installed,
> - devres moves removal of IRQ handler out of driver,
> - without explicit devres support for IRQ mapping, irq_dispose_mapping()
>   stays in driver and thus gets called while IRQ handler is still
>   installed.
> 
> This patch adds devm_irq_create_of_mapping() and devm_irq_of_parse_and_map()
> routines to be used by drivers for correct release of resources.
> 
> Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
