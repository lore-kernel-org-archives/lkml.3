Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbbAOMey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:34:54 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:59829 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbbAOMex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:34:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: wstephen@codeaurora.org
Cc: jcliburn@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ethernet: atheros: Add nss-gmac driver
Date: Thu, 15 Jan 2015 13:34:48 +0100
Message-ID: <2318041.V2OJAPu7gC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <bca0eaf2183036ff6a913daea6e09ad9.squirrel@www.codeaurora.org>
References: <1420754626-30121-1-git-send-email-wstephen@codeaurora.org> <5550127.3sXOcCISZN@wuerfel> <bca0eaf2183036ff6a913daea6e09ad9.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:w6AL74BLoi1aP4kf96cAwG5/C5OdzR488rpzbfn4atGgg6nc/6W
 2OuPPS88h6Bv/kfB2tci1CIuNRMvK/TGSIvAq6DInpBXX6N6Ye5BcyHxQjqz/RERXh3E+un
 a3RpJmXzY4YPgSJ9+I+9XEMbpjBnggoakJ0ZlZVPO9vIjb7qnUutAz9nvOTxoIbr+2V+Kh5
 QCD0FA25co5A+e7HDQj2g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2015 08:12:51 wstephen@codeaurora.org wrote:
> 
> The nss-gmac driver is for the internal GMAC IP in the Qualcomm IPQ806x
> SoC. There are 2 ARM cores and 2 NSS cores inside the IPQ806x SoC. The
> main purpose of these NSS cores is to offload the networking stack from
> the ARM cores to achieve high performance at routing/ipsec..etc without
> exhausting the ARM core CPU cycles. There is another nss-drv driver for
> the NSS cores.

I see.

> The nss-gmac driver is designed to work standalone or with the nss-drv
> driver so the switchable data plane overlay was implemented. When it
> worked standalone, the data plane is running on the ARM core as a standard
> networking driver.

How do you decide which way it gets used on a particular system?

> The nss-drv driver can take over the data plane and
> offload it to the NSS cores. The STMicro stmmac driver does not have this
> kind of overlay design so is not suitable for IPQ806x. This is why we
> don't based on the stmmac driver

Which kind of offload is implemented specifically? 'data plane' sounds
fairly generic and could mean anything, and the code isn't readable enough
in its current form for me to find out.

	Arnd
