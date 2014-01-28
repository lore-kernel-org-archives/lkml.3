Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaA1Lda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:33:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:32392 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbaA1Ld1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:33:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,735,1384329600"; 
   d="scan'208";a="445750927"
Date: Tue, 28 Jan 2014 17:02:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Lars-Peter Clausen <lars@metafoo.de>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Gross <agross@codeaurora.org>,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Message-ID: <20140128113242.GJ10628@intel.com>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org>
 <1390890471-14882-3-git-send-email-agross@codeaurora.org>
 <52E772DF.6000604@metafoo.de>
 <4697306.PPWWh8UGTE@wuerfel>
 <20140128111756.GE15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128111756.GE15937@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:17:57AM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 28, 2014 at 10:16:53AM +0100, Arnd Bergmann wrote:
> > On Tuesday 28 January 2014 10:05:35 Lars-Peter Clausen wrote:
> > > Why does the direction needs to be specified in specifier? I see two
> > > options, either the direction per is fixed in hardware. In that case the DMA
> > > controller node should describe which channel is which direction. Or the
> > > direction is not fixed in hardware and can be changed at runtime in which
> > > case it should be set on a per descriptor basis.
> > 
> > Normally the direction is implied by dmaengine_slave_config().
> 
> No.  The direction argument in there is deprecated - we've been talking
> about removing it for some time.
> 
> DMA engine drivers should store all parameters of the configuration, and
> then select the appropriate ones when preparing a transfer (which itself
> involves a direction.)

Right all the prep_ calls for slave cases have explcit direction argument so
sending it using slave config makes no sense. So will remove it after the merge
window closes and fix :)

--
~Vinod
> 
> Not doing this implies that if you have a half-duplex device, you have to
> repeatedly issue a dmaengine_slave_config() call, a prepare call, and a
> submit call to the DMA engine code for every segment you want to transfer.
> We don't need that kind of DMA engine specific behaviour in DMA engine
> users.
> 
> -- 
> FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
> in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
> Estimate before purchase was "up to 13.2Mbit".
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
