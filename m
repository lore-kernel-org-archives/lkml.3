Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaHTNDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:03:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43715 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751976AbaHTNDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:03:08 -0400
Message-ID: <1408539787.21533.79.camel@hornet>
Subject: Re: [PATCH v2] video: ARM CLCD: Fix calculation of bits-per-pixel
From: Pawel Moll <pawel.moll@arm.com>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 20 Aug 2014 14:03:07 +0100
In-Reply-To: <1408538464.3858.43.camel@linaro1.home>
References: <1408538464.3858.43.camel@linaro1.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 13:41 +0100, Jon Medhurst (Tixy) wrote:
> If the device-tree specifies a max-memory-bandwidth property then the
> CLCD driver uses that to calculate the bits-per-pixel supported,
> however, this calculation is faulty for two reasons.
> 
> 1. It doesn't ensure that the result is a sane value, i.e. a power of 2
>    and <= 32 as the rest of the code assumes.
> 
> 2. It uses the displayed resolution and calculates the average bandwidth
>    across the whole frame. It should instead calculate the peak
>    bandwidth based on the pixel clock.
> 
> This patch fixes both the above.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>

Acked-by: Pawel Moll <pawel.moll@arm.com>

