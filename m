Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3FRPvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:51:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50520 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab3FRPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:51:42 -0400
Message-ID: <51C0820B.4020404@wwwdotorg.org>
Date: Tue, 18 Jun 2013 09:51:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: linux-omap@vger.kernel.org, broonie@kernel.org, ldewangan@nvidia.com,
        sameo@linux.intel.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        gg@slimlogic.co.uk
Subject: Re: [PATCH v2 1/4] MFD: Palmas: Check if interrupts property exists
 and then only request irq
References: <1371549692-7361-1-git-send-email-j-keerthy@ti.com> <1371549692-7361-2-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371549692-7361-2-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 04:01 AM, J Keerthy wrote:
> Check if interrupts property exists and then only request irq.
> On some boards INT line might not be connected to a valid
> irq line on the application processor. Hence keeping a check
> before requesting irq.

When there is no interrupts property, surely i2c->irq == 0, which is an
invalid IRQ, and hence there's no need to check this before copying the
value?

In other words, I think this whole patch could just be:

+ 	palmas->irq = i2c->irq;

right?
