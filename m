Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab3FLPIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:08:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:43933 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3FLPIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:08:50 -0400
Message-ID: <51B88EED.6090709@linutronix.de>
Date: Wed, 12 Jun 2013 17:08:29 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Oded Gabbay <ogabbay@advaoptical.com>
CC: benh@kernel.crashing.org, paulus@samba.org, leoli@freescale.com,
        galak@kernel.crashing.org, B38951@freescale.com,
        Dongsheng.Wang@freescale.com, stef.van.os@prodrive.nl, timur@tabi.org,
        davem@davemloft.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] MDIO: FSL_PQ_MDIO: Fix bug on incorrect offset of tbipa
 register
References: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
In-Reply-To: <1371041258-15298-1-git-send-email-ogabbay@advaoptical.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 02:47 PM, Oded Gabbay wrote:
> This patch fixes a bug in the fsl_pq_mdio.c module and in relevant device-tree
> files regarding the correct offset of the tbipa register in the eTSEC
> controller in some of Freescale's PQ3 and QorIQ SoC.
> The bug happens when the mdio in the device tree is configured to be compatible
> to "fsl,gianfar-tbi". Because the mdio device in the device tree points to
> addresses 25520, 26520 or 27520 (depends on the controller ID), the variable
> priv->map at function fsl_pq_mdio_probe, points to that address. However,
> later in the function there is a write to register tbipa that is actually
> located at 25030, 26030 or 27030. Because the correct address is not io mapped,
> the contents are written to a different register in the controller.
> The fix sets the address of the mdio device to start at 25000, 26000 or 27000
> and changes the mii_offset field to 0x520 in the relevant entry
> (fsl,gianfar-tbi) of the fsl_pq_mdio_match array.
> 
> Note: This patch may break MDIO functionallity of some old Freescale's SoC
> until Freescale will fix their device tree files. Basically, every device tree
> which contains an mdio device that is compatible to "fsl,gianfar-tbi" should be
> examined.

Not as is.
Please add a check for the original address. If it has 0x520 at the end
print a warning and fix it up. Please add to the patch description
which register is modified instead if this patch is not applied.
Depending on how critical this it might has to go stable.

Sebastian
