Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbaJXMmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:42:23 -0400
Received: from mail-by2on0054.outbound.protection.outlook.com ([207.46.100.54]:19904
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756308AbaJXMmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:42:18 -0400
X-Greylist: delayed 1075 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 08:42:17 EDT
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
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
Thread-Index: AQHP6G+qFNHlEI1cgUeqDvA2b+1TW5w444MAgAFq8cCAAABmoA==
Date: Fri, 24 Oct 2014 12:08:26 +0000
References: <1413374436-14410-1-git-send-email-sthokal@xilinx.com>
 <4301925.4pMHXMXqA4@wuerfel>
 <ff137744d6474640aab09e5d6f62921a@BN1AFFO11FD019.protection.gbl>
 <3236720.MHeqOodrCV@wuerfel>
In-Reply-To: <3236720.MHeqOodrCV@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.224]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21046.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <7dc11ef7ccec49bcb052c30b9aa916c3@BL2FFO11FD044.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(13464003)(24454002)(199003)(189002)(377454003)(21056001)(53416004)(107046002)(31966008)(95666004)(19580405001)(87936001)(20776003)(106466001)(77096002)(64706001)(2656002)(23726002)(97756001)(50986999)(76176999)(54356999)(85852003)(92566001)(86362001)(93886004)(85306004)(50466002)(104016003)(4396001)(6806004)(44976005)(19580395003)(106116001)(120916001)(80022003)(76482002)(108616004)(46102003)(46406003)(99396003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB063;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB063;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Tuesday, October 21, 2014 2:45 PM
To: linux-arm-kernel@lists.infradead.org
Cc: Appana Durga Kedareswara Rao; devicetree@vger.kernel.org; vinod.koul@intel.com; Srikanth Vemula; linux-kernel@vger.kernel.org; Srikanth Thokala; dmaengine@vger.kernel.org; robh+dt@kernel.org; Michal Simek; Anirudha Sarangi; grant.likely@linaro.org; dan.j.williams@intel.com
Subject: Re: [PATCH v4] dma: Add Xilinx AXI Direct Memory Access Engine driver support

On Tuesday 21 October 2014 09:06:13 Appana Durga Kedareswara Rao wrote:
> The above mentioned API's  and structures will be used by the dma test
> client driver's to set hardware configuration information. The dma
> client drivers are not mainlined  yet and it is Internally used by
> our git-tree  to test the DMA functionality in loopback .

I would suggest you add the test driver into the main dmaengine driver file directly then, so you don't need to export the symbols. If there are important reasons to keep that as separate files, just move the header to the drivers/dma/ directory and add the test driver there.

        Arnd

Sorry I forgot to mention the below things in the mail .The Config API's and structures not only used by the dmaengine driver's but also used by the  various IP's  (Ex: Ethernet driver and SRIO driver these drivers are under development).For example the Ethernet driver is resides under drivers/net/ethernet but it needs to set some specific configuration parameters of the dma that's why created a separate header file for the h/w configurable parameters.


Regards,
Kedar.


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

