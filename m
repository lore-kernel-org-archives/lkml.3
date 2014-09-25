Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaIYTM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:12:28 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:59179 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaIYTM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:12:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Date: Thu, 25 Sep 2014 21:12:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, Peter.Chen@freescale.com,
        balbi@ti.com, p.zabel@pengutronix.de,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com> <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201409252112.07513.arnd@arndb.de>
X-Provags-ID: V02:K0:djO3anmtm66rX2Q0CvwK2fIiP4zir5aRSsB4a1wSZJm
 cxRO9HaMOH2kunxXmW5Ez/WAJ4CPkrKu2BCpDNvdcRXeFDk9mi
 oYTHJACFekZR+GcVYPlM2QbASL2dmfI4pwGP2Y8ouboTL6+jc2
 jzlcLOERiUxZ5CWighqUueiJVl9g53t3ZF9ikstB76iqt1N7B6
 iYmZZ2RICfntycQeNQKeMyKKds/044+Of9PC8hjQ8NgOlww2hj
 HmStDRcHbsG4m/yhtgWnuIa42D17L1DZQlhmUSE1mZwGxCAC2g
 DFvDHdauqbeW5Q4GeObJlXwV/BrEI4KKu0298xGJ7/K3Q0g2MO
 JhQz7smth6tLgijAr1u0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014, Antoine Tenart wrote:
> +static int ci_hdrc_usb2_dt_probe(struct device *dev,
> +                                struct ci_hdrc_platform_data *ci_pdata)
> +{
> +       ci_pdata->phy = of_phy_get(dev->of_node, 0);

FWIW, I accidentally built a kernel with this driver enabled and got a warning
for this code. The problem is that ci_pdata->phy is a 'struct usb_phy' pointer,
while of_phy_get() returns a generic 'struct phy'. While the two have similar
behavior, they are not the same thing and this can't work.

	Arnd
