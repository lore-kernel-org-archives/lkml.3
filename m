Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbaJXN7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:59:05 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58208 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbaJXN7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:59:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        Srikanth Vemula <svemula@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Michal Simek <michals@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support
Date: Fri, 24 Oct 2014 15:58:51 +0200
Message-ID: <1967130.oYyZRWCcEF@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7dc11ef7ccec49bcb052c30b9aa916c3@BL2FFO11FD044.protection.gbl>
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com> <3236720.MHeqOodrCV@wuerfel> <7dc11ef7ccec49bcb052c30b9aa916c3@BL2FFO11FD044.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cIXADOZAnH+N+yn6gJUM3U/DqqZ6R7EXNHCAFVEd57B
 IgNe5rNbQ9Q2/Q0UQeyAd6X2Kl0PzxoDlXnX9Utxb11k1N4wgd
 5oWLswdnV6CfChZAFtBweyGtY9YM0ADntDk3T3hiqCsbBP9RmY
 3rpwe4Gc0uL0OGngT9SDEP7VQLjguBUcAcHFvx9xfD8niX5trT
 FLSDtGzK6zeiWItsxsszgbH09NYXQAKoFjU+MwGneE424WbBW+
 o2SdqAwweeoE90OEh/afNL1x0ZlsygDhbewr3VM9aggXazqGd5
 RzH0jbSVYmiAC+7xxcldyJGqV5IPGWTFow4UBfzc33Q1/QxEMC
 egvaKjHRspqtze3MGfVI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2014 12:08:26 Appana Durga Kedareswara Rao wrote:
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> > On Tuesday 21 October 2014 09:06:13 Appana Durga Kedareswara Rao wrote:
> > > The above mentioned API's  and structures will be used by the dma test
> > > client driver's to set hardware configuration information. The dma
> > > client drivers are not mainlined  yet and it is Internally used by
> > > our git-tree  to test the DMA functionality in loopback .
> > 
> > I would suggest you add the test driver into the main dmaengine driver
> > file directly then, so you don't need to export the symbols. If there are
> > important reasons to keep that as separate files, just move the header to
> > the drivers/dma/ directory and add the test driver there.
> 
> Sorry I forgot to mention the below things in the mail .The Config API's and
> structures not only used by the dmaengine driver's but also used by
> the  various IP's  (Ex: Ethernet driver and SRIO driver these drivers are
> under development).For example the Ethernet driver is resides under
> drivers/net/ethernet but it needs to set some specific configuration
> parameters of the dma that's why created a separate header file for the h/w
> configurable parameters.

That is a bug in the ethernet driver, and we should not merge such code.

Please fix those drivers before submitting them, so they don't rely on
additional interfaces beyond what the DMA engine API provides.

If you need something that the common interface is missing, you can
send a patch to extend the dmaengine core driver, but more likely it
already does what you need and you are just not using it right.

	Arnd

