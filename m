Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaJUKjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:39:55 -0400
Received: from mail-bn1bon0068.outbound.protection.outlook.com ([157.56.111.68]:28532
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751283AbaJUKjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:39:52 -0400
X-Greylist: delayed 5610 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 06:39:51 EDT
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Srikanth Vemula <svemula@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Anirudha Sarangi" <anirudh@xilinx.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
Subject: RE: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Thread-Topic: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Thread-Index: AQHP6G+qFNHlEI1cgUeqDvA2b+1TW5w444MAgAERAcA=
Date: Tue, 21 Oct 2014 09:06:13 +0000
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
 <4301925.4pMHXMXqA4@wuerfel>
In-Reply-To: <4301925.4pMHXMXqA4@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.224]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21040.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ff137744d6474640aab09e5d6f62921a@BN1AFFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(13464003)(24454002)(199003)(189002)(51704005)(377454003)(2656002)(21056001)(107046002)(77096002)(106466001)(19580405001)(31966008)(19580395003)(95666004)(4396001)(6806004)(64706001)(20776003)(106116001)(47776003)(44976005)(87936001)(97756001)(23726002)(50986999)(54356999)(76176999)(86362001)(92566001)(85852003)(46406003)(74316001)(46102003)(53416004)(80022003)(50466002)(104016003)(108616004)(120916001)(85306004)(99396003)(33646002)(76482002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB028;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-Forefront-PRVS: 0371762FE7
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Tuesday, October 21, 2014 1:07 AM
To: linux-arm-kernel@lists.infradead.org
Cc: Srikanth Thokala; vinod.koul@intel.com; dan.j.williams@intel.com; Michal Simek; grant.likely@linaro.org; robh+dt@kernel.org; devicetree@vger.kernel.org; Srikanth Vemula; linux-kernel@vger.kernel.org; Anirudha Sarangi; dmaengine@vger.kernel.org; Appana Durga Kedareswara Rao
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support

On Wednesday 15 October 2014 17:30:36 Srikanth Thokala wrote:
> @@ -15,6 +15,9 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
>
> +/* Number of AXI DMA APP Words */
> +#define XILINX_DMA_NUM_APP_WORDS       5
> +
>  /**
>   * struct xilinx_vdma_config - VDMA Configuration structure
>   * @frm_dly: Frame delay
> @@ -41,7 +44,21 @@ struct xilinx_vdma_config {
>         int ext_fsync;
>  };
>
> +/**
> + * struct xilinx_dma_config - DMA Configuration structure
> + * @coalesc: Interrupt coalescing threshold
> + * @delay: Delay counter
> + * @reset: Reset Channel
> + */
> +struct xilinx_dma_config {
> +       int coalesc;
> +       int delay;
> +       int reset;
> +};
> +
>  int xilinx_vdma_channel_set_config(struct dma_chan *dchan,
>                                         struct xilinx_vdma_config
> *cfg);
> +int xilinx_dma_channel_set_config(struct dma_chan *dchan,
> +                                       struct xilinx_dma_config
> +*cfg);
>

You add this to a global header file, but I don't see any uses outside of the driver itself. Please move all of this into the driver itself and remove the header file.

        Arnd

The above mentioned API's  and structures will be used by the dma test client driver's to set hardware configuration information. The dma client drivers are not mainlined  yet and it is
Internally used by  our git-tree  to test the DMA functionality in loopback .

Regards,
Kedar.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

