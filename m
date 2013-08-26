Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3HZSNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:13:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab3HZSN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:13:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Zhao <rizhao@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Richard Zhao <linuxzsc@gmail.com>
Subject: Re: [PATCH] DMA: let filter functions of of_dma_simple_xlate possible check of_node
Date: Mon, 26 Aug 2013 20:15:17 +0200
Message-ID: <3565907.5flGSRLgMJ@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.10.95; x86_64; ; )
In-Reply-To: <20130826141057.GQ2748@intel.com>
References: <1375408800-11789-1-git-send-email-rizhao@nvidia.com> <2811939.DFy94j5OEx@avalon> <20130826141057.GQ2748@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:MWA1nc9UbXCXjAALg8G1/I4EOsltLPasQ99TsLgb5+N
 eMxUL0DRqqgkKCi3CiTiO9RNO2bd3ZENd038XgtecrSrLteEGh
 K+B+ryiswg6iqlHe8oYYHkhhj10DT1R2sgk/hm6QaBByKB8Kfg
 egPrOplnj2YhPg0htuUX2jZz2u+I70nCQLapNUTSDPi1BjREyn
 IOH1k+YQWhFbsin6BWFVEh3Bt0AxAnZUuro8mkCgHCq1IxXItR
 l6q/K/+8XXg2tQYU5u1sFJ3/xsyV49f5zX+neNEd6CCfcw317a
 Ej4YLDWFoQqA0NmdqERTMZ1BQwG0N2Rsikegdy48CuQ7Np81nx
 EvHKcXm2FT02vNirRCa8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 August 2013 19:40:57 Vinod Koul wrote:
> Why does DT need the fliter function in the first place. The DT enabled drivers
> should not even have a filter function...
> 
> The dmaengine core calls the optional filter function. This needs to be
> implemented in driver in order for driver to check if the channel is what it
> needs or not.

You only just merged the dma_get_slave_channel() patch, which allows having
no filter function. Up to Linux-3.11, the filter was always needed but
could be 'static' and only called by the xlate function. Now the xlate
function can pick a channel itself.

> And the selection should be done for the cases where you dont have programmable
> mux in dmac. For programmable ones passing slave_id in dma_slave_config should
> be fine.

I think passing a slave_id from the slave driver is never correct with DT,
since the ID is a property of the system rather than the slave device, so
the driver has no access to it. Drivers have to always take the settings
from DT and ignore what dma_slave_config() sets later.

	Arnd
