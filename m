Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaAPPQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:16:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57934 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaAPPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:16:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH V2] net/dt: Add support for overriding phy configuration from device tree
Date: Thu, 16 Jan 2014 16:16:46 +0100
Message-ID: <7510122.cayuQ6qt8r@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1389883631-1480-1-git-send-email-matthew.garrett@nebula.com>
References: <20140116135905.GV20094@book.gsilab.sittig.org> <1389883631-1480-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:vB+irDd/vOioB+nyVMq2099RG9xn5Ht7mLosOtlzs4t
 3FWNcvBEL+m9tgoS1Xvwf9Gk8dN+PJKQo1PTRV8GTJJ/W1VSsQ
 CtPM7SBtiLAxUEGfiDWgtZVJvL50daE9VrQQwFOpp2TaIBJsmH
 QtMLhRNl6tAnPp5KnD+59I4moLi0J8yJoKY+dkZtv3tczDzOm3
 cLaqn/2LFgRHIRVYbCRrLUcFumzhDHHvA1XfL/49/zstSDlSyF
 3Be7nkezzkEXQpxPsxF2/itHRbvjXaf1drwztx7qsr/QfmssOV
 Juubj/Hagmd3wLZJrq/eBbNQRJwxAaqXWELSzsx1X9la8Dm2h5
 ilxJXny5betKRnBs+DGo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 January 2014 09:47:11 Matthew Garrett wrote:
> +               if (!of_property_read_u32(np, "phy-mii-advertise-10half",
> +                                          &tmp)) {
> +                       if (tmp) {
> +                               *val |= ADVERTISE_10HALF;
> +                               phydev->advertising |= SUPPORTED_10baseT_Half;
> +                       } else {
> +                               phydev->advertising &=
> +                                       ~(SUPPORTED_10baseT_Half);
> +                       }
> +
> +                       *mask |= ADVERTISE_10HALF;
> +               }
> +               if (!of_property_read_u32(np, "phy-mii-advertise-10full",
> +                                          &tmp)) {
> +                       if (tmp) {
> +                               *val |= ADVERTISE_10FULL;
> +                               phydev->advertising |= SUPPORTED_10baseT_Full;
> +                       } else {
> +                               phydev->advertising &=
> +                                       ~(SUPPORTED_10baseT_Full);
> +                       }
> +
> +                       *mask |= ADVERTISE_10FULL;
> +               }
> 

Just a style suggestion: rather than almost duplicating the same 12 lines
of code for each property, I think it can be split out into a helper
function.

	Arnd

