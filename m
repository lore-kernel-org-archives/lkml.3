Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaFYWCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:02:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51730 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaFYWCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:02:13 -0400
Message-ID: <53AB46E0.5010908@wwwdotorg.org>
Date: Wed, 25 Jun 2014 16:02:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org> <1403072180-4944-3-git-send-email-abrestic@chromium.org>
In-Reply-To: <1403072180-4944-3-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
> The Tegra XHCI controller communicates requests to the host through
> a mailbox interface.  Host drivers which can handle these requests,
> such as the Tegra XUSB pad controller driver and upcoming Tegra XHCI
> host controller driver, can send messages and register to be notified
> of incoming messages.

> diff --git a/include/linux/tegra-xusb-mbox.h b/include/linux/tegra-xusb-mbox.h

> +extern int tegra_xusb_mbox_register_notifier(struct tegra_xusb_mbox *mbox,
> +					     struct notifier_block *nb);
> +extern void tegra_xusb_mbox_unregister_notifier(struct tegra_xusb_mbox *mbox,
> +						struct notifier_block *nb);
> +extern int tegra_xusb_mbox_send(struct tegra_xusb_mbox *mbox,
> +				enum tegra_xusb_mbox_cmd cmd, u32 data);
> +extern struct tegra_xusb_mbox *
> +tegra_xusb_mbox_lookup_by_phandle(struct device_node *np, const char *prop);

This seems to use a custom API. I've seen mention of a mailbox
subsystem, and I assume that has a standardized API. Should this driver
implement that instead?
