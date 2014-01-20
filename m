Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaATQs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 11:48:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaATQsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 11:48:53 -0500
Message-ID: <52DD5368.5020301@redhat.com>
Date: Mon, 20 Jan 2014 17:48:40 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>, tj@kernel.org
CC: sergei.shtylyov@cogentembedded.com, kishon@ti.com,
        b.zolnierkie@samsung.com, arnd@arndb.de, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 0/4] ata: ahci_platform: Add PHY support and OMAP support
References: <1390228888-5537-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1390228888-5537-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/20/2014 03:41 PM, Roger Quadros wrote:
> Hi,
>
> Some platforms have a PHY hooked up to the SATA controller.
> The PHY needs to be initialized and powered up for SATA to work.
> We do that using the Generic PHY framework in PATCH 3.
>
> In order to support SATA on the OMAP platforms we need to runtime
> resume the device before use. PATCH 4 takes care of that.

Thanks for keeping me in the loop on this. I'm afraid this conflicts
quite a bit with my recent ahci_platform.c work, not a big problem
really, the series can go in either way.

Your phy support will slot nicely into the new ahci_platform_get_resources
and ahci_platform_enable_resources functions my refactoring introduces,
looking at it from this pov it might be better / easier to rebase your series
on top of the v4 of my series I've just send.

Which brings me to one comment about your series why are you not doing phy_exit
and phy_init on suspend resp. resume ? The phy can use quite a bit of power,
if the phy init / exit end up in ahci_platform_enable_resources /
ahci_platform_disable_resources, this will happen automatically for better or
worse. So it would be good to test if this would work or not ...

Thanks & Regards,

Hans
