Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab3FNA2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 20:28:54 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:48457 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab3FNA2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 20:28:52 -0400
Date: Thu, 13 Jun 2013 20:21:29 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Olof Johansson <olof@lixom.net>
cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Jon Medhurst <tixy@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Achin Gupta <achin.gupta@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [RFC PATCH v3 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
In-Reply-To: <20130613225233.GB22310@quad.lixom.net>
Message-ID: <alpine.LFD.2.03.1306132006390.18597@syhkavp.arg>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com> <1370512763-32200-3-git-send-email-lorenzo.pieralisi@arm.com> <20130613225233.GB22310@quad.lixom.net>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013, Olof Johansson wrote:

> > +	u32 status = readl_relaxed(info->baseaddr + PWC_STATUS);
> 
> Why readl_relaxed() here? Can't you use a normal readl()?

Unfortunately, on ARM readl_relaxed() _is_ the normal readl() because 
the actual readl() may have side effects.  See commit 79f64dbf68c8.


Nicolas
