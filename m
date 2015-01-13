Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbbAMH3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:29:24 -0500
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:56612
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751245AbbAMH3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:29:19 -0500
X-Greylist: delayed 3960 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 02:29:18 EST
X-WSS-ID: 0NI3T6T-08-1G1-02
X-M-MSG: 
Date: Tue, 13 Jan 2015 15:09:20 +0800
From: Huang Rui <ray.huang@amd.com>
To: Peter Chen <Peter.Chen@freescale.com>
CC: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: gadget: u_uac1: fix build issue
Message-ID: <20150113070920.GA3226@hr-slim.amd.com>
References: <1421130034-1891-1-git-send-email-ray.huang@amd.com>
 <BN3PR0301MB08491E88100625CCAE38DAE781400@BN3PR0301MB0849.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <BN3PR0301MB08491E88100625CCAE38DAE781400@BN3PR0301MB0849.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(164054003)(24454002)(199003)(51704005)(101416001)(50466002)(33656002)(62966003)(2950100001)(77156002)(46102003)(64706001)(47776003)(53416004)(106466001)(77096005)(23676002)(54356999)(19580395003)(68736005)(19580405001)(110136001)(105586002)(97736003)(76176999)(50986999)(86362001)(87936001)(83506001)(92566002)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 045584D28C
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 07:08:56.4121
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:51:40AM +0000, Peter Chen wrote:
>  
> > See below error message:
> >   CC [M]  drivers/gpu/drm/nouveau/core/subdev/vm/nv50.o
> >   CC [M]  drivers/staging/lustre/lnet/selftest/module.o
> > drivers/usb/gadget/function/f_uac1.c: In function ‘f_audio_free_inst’:
> > drivers/usb/gadget/function/f_uac1.c:904:21: error: ‘struct f_uac1_opts’ has
> > no member named ‘card’
> >   gaudio_cleanup(opts->card);
> >                      ^
> > make[4]: *** [drivers/usb/gadget/function/f_uac1.o] Error 1
> > make[3]: *** [drivers/usb/gadget/function] Error 2
> > make[2]: *** [drivers/usb/gadget] Error 2
> > make[2]: *** Waiting for unfinished jobs....
> >   CC [M]  drivers/staging/lustre/lnet/selftest/ping_test.o
> > 
> > Signed-off-by: Huang Rui <ray.huang@amd.com>
> > Cc: Peter Chen <peter.chen@freescale.com>
> > ---
> > 
> 
> Oh, my three patches have dependencies, it needs to rebase Felipe's fixes tree to fix this problem.
> 
> commit 4fde6204df052bb89ba3d915ed6ed9f306f3cfa1
> Author: Peter Chen <peter.chen@freescale.com>
> Date:   Mon Dec 1 16:09:27 2014 +0800
> 
>     usb: gadget: f_uac1: access freed memory at f_audio_free_inst
> 
> 
> 
> Peter
> 

I see, that's OK. :)

Thanks,
Rui
