Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaJ0Rzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:55:55 -0400
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:9652
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750740AbaJ0Rzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:55:54 -0400
Date: Mon, 27 Oct 2014 10:55:50 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH v2] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1413244255-3880-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdYh3bZLodeNYubu_WQ-O=5My0Jt=b3g2GT3Mvy2XZMrLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYh3bZLodeNYubu_WQ-O=5My0Jt=b3g2GT3Mvy2XZMrLg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21056.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <7f23a896baa04960a1702335b3df0432@BL2FFO11FD060.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(24454002)(164054003)(189002)(51704005)(377424004)(199003)(85182001)(20776003)(46102003)(6806004)(44976005)(19580405001)(53416004)(77096002)(83506001)(85852003)(80022003)(21056001)(87936001)(86362001)(76482002)(64706001)(99396003)(31966008)(47776003)(23676002)(19580395003)(92566001)(106466001)(74316001)(95666004)(85202003)(54356999)(50986999)(76176999)(110136001)(102836001)(120916001)(85306004)(108616004)(4396001)(50466002)(107046002)(104016003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB005;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB005;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-27 at 05:52PM +0100, Linus Walleij wrote:
> On Tue, Oct 14, 2014 at 1:50 AM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> > marking/unmarking a GPIO as wake IRQ.
> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> > is associated with that GPIO and the irqchip implements set_wake().
> > Writing 'enabled' to that file will enable wake for that GPIO, while
> > writing 'disabled' will disable wake.
> > Reading that file will return either 'disabled' or 'enabled' depening on
> > the currently set flag for the GPIO's IRQ.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > v2:
> >  - fix error path to unlock mutex before return
> 
> As you're adding an ABI, you should be patching
> Documentation/ABI/testing/sysfs-gpio and
> Documentation/gpio/sysfs.txt in this patch.
> 
> While I *HATE* the idea of adding IRQ support to userspace
> for GPIOs, this "just" adds the wakeup capacity, so I guess I'm
> OK with it.
> 
> Provided you add it to the ABI doc...

Thanks. I will add some documentation and sent a new patch.

	Thanks,
	Sören
