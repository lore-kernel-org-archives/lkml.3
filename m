Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbbA2LYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:24:53 -0500
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:18599
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752344AbbA2LYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:24:47 -0500
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "linux-arm-kernel@lists.infradead.org" 
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
Subject: RE: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Thread-Topic: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine
 driver support
Thread-Index: AQHP6G+qFNHlEI1cgUeqDvA2b+1TW5w444MAgAFq8cCABQYD64B8/m2AgBtIbEA=
Date: Thu, 29 Jan 2015 11:24:41 +0000
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
 <3236720.MHeqOodrCV@wuerfel>
 <7dc11ef7ccec49bcb052c30b9aa916c3@BL2FFO11FD044.protection.gbl>
 <1967130.oYyZRWCcEF@wuerfel> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.85]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21290.006
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <add9a23928b44aa48965e993bb17f53b@BL2FFO11FD027.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; intel.com; dkim=none (message not
 signed) header.d=none;intel.com; dmarc=permerror action=none
 header.from=xilinx.com;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(13464003)(377454003)(51704005)(106466001)(19300405004)(108616004)(92726002)(102836002)(46406003)(23726002)(53416004)(46102003)(19580405001)(47776003)(2501002)(15975445007)(2656002)(74316001)(50466002)(62966003)(77156002)(104016003)(106116001)(6806004)(97756001)(86362001)(93886004)(76176999)(92566002)(50986999)(87936001)(54356999)(2690400003)(107986001)(24736002)(562404015);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB049;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2FFO11HUB049;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB049;
X-Forefront-PRVS: 0471B73328
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB049;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2015 11:24:45.3571
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod,


> -----Original Message-----
> From: Appana Durga Kedareswara Rao
> Sent: Monday, January 19, 2015 7:39 PM
> To: 'Arnd Bergmann'; vinod.koul@intel.com
> Cc: linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org;
> vinod.koul@intel.com; Srikanth Vemula; linux-kernel@vger.kernel.org;
> Srikanth Thokala; dmaengine@vger.kernel.org; robh+dt@kernel.org; Michal
> Simek; Anirudha Sarangi; grant.likely@linaro.org; dan.j.williams@intel.com
> Subject: RE: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine
> driver support
>
> Hi Arnd,
>
> > -----Original Message-----
> > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > Sent: Friday, October 24, 2014 7:29 PM
> > To: Appana Durga Kedareswara Rao
> > Cc: linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org;
> > vinod.koul@intel.com; Srikanth Vemula; linux-kernel@vger.kernel.org;
> > Srikanth Thokala; dmaengine@vger.kernel.org; robh+dt@kernel.org;
> > Michal Simek; Anirudha Sarangi; grant.likely@linaro.org;
> > dan.j.williams@intel.com
> > Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access
> > Engine driver support
> >
> > On Friday 24 October 2014 12:08:26 Appana Durga Kedareswara Rao wrote:
> > > From: Arnd Bergmann [mailto:arnd@arndb.de]
> > > > On Tuesday 21 October 2014 09:06:13 Appana Durga Kedareswara Rao
> > wrote:
> > > > > The above mentioned API's  and structures will be used by the
> > > > > dma test client driver's to set hardware configuration information.
> > > > > The dma client drivers are not mainlined  yet and it is
> > > > > Internally used by our git-tree  to test the DMA functionality in
> loopback .
> > > >
> > > > I would suggest you add the test driver into the main dmaengine
> > > > driver file directly then, so you don't need to export the symbols.
> > > > If there are important reasons to keep that as separate files,
> > > > just move the header to the drivers/dma/ directory and add the
> > > > test driver
> > there.
> > >
> > > Sorry I forgot to mention the below things in the mail .The Config
> > > API's and structures not only used by the dmaengine driver's but
> > > also used by the  various IP's  (Ex: Ethernet driver and SRIO driver
> > > these drivers are under development).For example the Ethernet driver
> > > is resides under drivers/net/ethernet but it needs to set some
> > > specific configuration parameters of the dma that's why created a
> > > separate header file for the h/w configurable parameters.
> >
> > That is a bug in the ethernet driver, and we should not merge such code.
> >
> > Please fix those drivers before submitting them, so they don't rely on
> > additional interfaces beyond what the DMA engine API provides.
> >
> > If you need something that the common interface is missing, you can
> > send a patch to extend the dmaengine core driver, but more likely it
> > already does what you need and you are just not using it right.
> >
>
> Sorry for the delay in the reply.
> We need that header file in the include/linux/ directory for various
> reasons.
>
>  As you know the Xilinx DMA's have a set of configurable parameters which
> we expect the DMA users to take advantage of.
>
>  For example:
>  For Axi DMA we have the following parameters that we expect to be
> commonly used.
>  Coalesce count --> Used to configure the coalesce value.
>  Delay timer ---> Used to set the delay value.
>
>  We expect the Xilinx AXI Ethernet driver to use the Axi DMA driver in  near
> furture. If so, using ethtool, we expect the driver users to play with the
> above parameters to do performance tuning.
>
>  Hence AxiDMA driver must expose means to change coalese count or delay
> timer.
>
>  Similarly For Axi VDMA we have the following parameters that will be used
> by the users of this driver.
>  hsize  --> Used to configure number of bytes per line.
>  vsize  -->Number of lines per frame.
>  stride  --> Number of bytes per line.
>
>
>  Earlier in the driver we are embedding dma_slave_config into custom
> structs But Lars suggested to modify it. please refer to the below thread for
> more details.
>  http://www.spinics.net/lists/dmaengine/msg00010.html
>
>  And later we thought of creating a separate private member in
> dma_slave_config for sharing additional configuration between slave
> device and dma engine Or a new dma_ctrl_cmd like
>  FSLDMA_EXTERNAL_START(http://www.kernelhub.org/?msg=405535&p=2 )
>
>  Finally Vinod was ok with the existing suggestion so we dropped the above
> thought.
>
>  @Vinod : Could you please comment on this.

Ping ?

Regards,
Kedar.

>
> Regards,
> Kedar.
>
> >     Arnd



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

