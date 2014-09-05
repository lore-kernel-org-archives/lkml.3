Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaIERzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:55:16 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:64225 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIERzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:55:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kumar Gala <galak@codeaurora.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] PCI: keystone: update to support multiple pci ports
Date: Fri, 05 Sep 2014 19:54:58 +0200
Message-ID: <7260053.FoBVhTXVfj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com>
References: <1409938782-31460-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:hZPDJP7/wBCDO4cuf5dTFAQiXf/8HkhazyIgRt7oX0G
 CP9QrFcAc8ZAKU1Loh4cElvgrjS8dUdg7VA4cFLwXUIM9+EJH5
 QFev8FgkTThr8qPU2gH9VP69n37j0PhzFND79EE2+117kAabap
 vQdQvuAFU7sPb0t5ggCbZ4wfidSPCakt3FbF7oPU+fZSbqV88e
 1325IJdOu/KCrRT9/B6WF6TGgIXCSKzL9o79/SW36fYTuKK6ci
 lx+3nwfTJfHBxSmty+UC5cOkuVcdjJW+jy0lJsxFB9n8QCv4Qg
 cLM9fMxHS6Tb0iH9/MJ6MM+WjkJSI3TM2OcxWlBEKCP4Kd9soN
 aGvKAatxaR01Icpz2SY4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 13:39:42 Murali Karicheri wrote:
> +
>         /* enable RC mode in devcfg */
>         val = readl(reg_p);
> -       val &= ~PCIE_MODE_MASK;
> -       val |= PCIE_RC_MODE;
> +       port_id <<= 1;
> +       val &= ~(PCIE_MODE_MASK << port_id);
> +       val |= (PCIE_RC_MODE << port_id);
>         writel(val, reg_p);
> +       devm_iounmap(dev, reg_p);
> +       devm_release_mem_region(dev, res->start, resource_size(res));

This looks like it's a shared register of some sort that doesn't
really belong into the registers of a particular port. Could it
be that it's actually for the PHY?

	Arnd
