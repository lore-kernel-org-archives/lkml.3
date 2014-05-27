Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaE0IaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:30:24 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:59123 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaE0IaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:30:18 -0400
Date: Tue, 27 May 2014 09:30:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <a0393675@ti.com>
Cc: Mark Brown <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 5/5] regulator: tps65917: Add Regulator driver for
 tps65917 PMIC
Message-ID: <20140527083012.GA5875@lee--X1>
References: <1401098197-647-1-git-send-email-j-keerthy@ti.com>
 <1401098197-647-6-git-send-email-j-keerthy@ti.com>
 <20140526150052.GP22111@sirena.org.uk>
 <538404F2.9000505@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <538404F2.9000505@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>This patch adds support for TPS65917 PMIC regulators.
> >>
> >>The regulators set consists of 5 SMPSs and 5 LDOs. The output
> >>voltages are configurable and are meant to supply power to the
> >>main processor and other components.
> >This appears to look *very* like the Palmas driver, should it not be
> >sharing code with that?  If it were just data tables it'd be less of a
> >concern but there's quite a bit of actual code here.
> Yes it is. The difference is in the entire register space of the regulators
> between the two. There are other differences in how the ramp delay
> is configured and SMPS ordering. The difference is also a bit in the
> programming
> sequence. I agree that largely it is Palmas based. I did not want to
> add more
> checks in the probe of the palmas driver. Hence came up with a new one.
> 
> Coming to sharing the code, can we have 2 drivers which share the common
> functions with separate data and specific functions?

Yes, that is what the match functionality is for.  Once you know which
driver you're dealing with, you can call specific initialisation
functions and/or supplement generic generic data structures with device
specific ones.

> I just simply do not want to add anything more to the palmas driver
> probe function.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
