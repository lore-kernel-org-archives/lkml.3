Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3HMA4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:56:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37513 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756428Ab3HMA4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:56:38 -0400
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Mon, 12 Aug 2013 19:56:33 -0500
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <BA285A30-3E38-4F7A-BD5E-3271AD1A46BE@codeaurora.org>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 12, 2013, at 1:46 PM, Sebastian Hesselbarth wrote:

> This patch adds a check for DT passed reset-gpios property and deasserts/
> asserts reset pin on probe/remove with configurable delay. Corresponding
> binding documentation is also updated.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-pci@vger.kernel.org
> ---
> .../devicetree/bindings/pci/mvebu-pci.txt          |    2 ++
> drivers/pci/host/pci-mvebu.c                       |   33 +++++++++++++++++++-
> 2 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/mvebu-pci.txt b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
> index 638673a..f2fa261 100644
> --- a/Documentation/devicetree/bindings/pci/mvebu-pci.txt
> +++ b/Documentation/devicetree/bindings/pci/mvebu-pci.txt
> @@ -76,6 +76,8 @@ and the following optional properties:
> - marvell,pcie-lane: the physical PCIe lane number, for ports having
>   multiple lanes. If this property is not found, we assume that the
>   value is 0.
> +- reset-gpios: optional gpio to PERST#
> +- reset-delay-ms: delay in ms to wait after reset de-assertion

Both of these should probably be marvell,reset...

Does reset-delay-ms vary per board?  I can't remember where the discussion got to about configuration info.

> 
> Example:

It's usually good to update example to show all optional properties.

- k
--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

