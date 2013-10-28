Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3J1Gyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:54:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59951 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3J1Gyt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:54:49 -0400
Subject: Re: [RFC 9/9] of/irq: create interrupts-extended property
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
Date: Mon, 28 Oct 2013 01:54:38 -0500
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <31D756E7-A7CD-42ED-8D1D-D1B38B85E3A0@codeaurora.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-10-git-send-email-grant.likely@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 15, 2013, at 3:39 PM, Grant Likely wrote:

> The standard interrupts property in device tree can only handle
> interrupts coming from a single interrupt parent. If a device is wired
> to multiple interrupt controllers, then it needs to be attached to a
> node with an interrupt-map property to demux the interrupt specifiers
> which is confusing. It would be a lot easier if there was a form of the
> interrupts property that allows for a separate interrupt phandle for
> each interrupt specifier.
> 
> This patch does exactly that by creating a new interrupts-extended
> property which reuses the phandle+arguments pattern used by GPIOs and
> other core bindings.
> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> ---
> .../bindings/interrupt-controller/interrupts.txt   | 29 +++++++--
> arch/arm/boot/dts/testcases/tests-interrupts.dtsi  | 16 +++++
> arch/arm/boot/dts/versatile-ab.dts                 |  2 +-
> arch/arm/boot/dts/versatile-pb.dts                 |  2 +-
> drivers/of/irq.c                                   | 16 +++--
> drivers/of/selftest.c                              | 70 ++++++++++++++++++++++
> 6 files changed, 122 insertions(+), 13 deletions(-)

Acked-by: Kumar Gala <galak@codeaurora.org>

[ I think the patch should be split up so we aren't touching versatile dts as part of it ]

- k 

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

