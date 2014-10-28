Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaJ1QHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:07:48 -0400
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:61339
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753664AbaJ1QHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:07:46 -0400
Date: Tue, 28 Oct 2014 09:07:30 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC v2 3/8] pinctrl: pinconf-generic: Add parameter 'IO
 standard'
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-4-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdZtqNUroNfd_0Kftq+-056YFzjvR+ROrZZ0htZX2v2qzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZtqNUroNfd_0Kftq+-056YFzjvR+ROrZZ0htZX2v2qzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21058.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <62aa98fc84d14f919e35dd068d24e5a7@BN1BFFO11FD060.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(377454003)(377424004)(164054003)(51704005)(199003)(189002)(4396001)(76482002)(85852003)(85202003)(86362001)(102836001)(85306004)(50466002)(106466001)(47776003)(92566001)(64706001)(80022003)(83506001)(23676002)(46102003)(21056001)(19580395003)(31966008)(20776003)(104016003)(108616004)(33646002)(6806004)(120916001)(44976005)(95666004)(53416004)(85182001)(87936001)(76176999)(50986999)(74316001)(110136001)(19580405001)(107046002)(77096002)(54356999)(41533002)(107986001)(24736002)(23106004)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB060;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 03:59PM +0100, Linus Walleij wrote:
> On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > For HW that can select the IO standard for pins, add the infrastructure
> > in pinconf generic to parse this parameter.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> Nothing in this patch actually explain what an "IO standard" is,
> which is paramount if it should be a generic property.
> 
> And if it should be generic, I really want to know why this is a
> thing not overlapping with existing generic configs, and exactly
> what it is and that it is probable other silicon will have it too.
> And we need to discuss if it's the right name.
> 
> Looking at what you actually set up, it looks very much like this
> is actually PIN_CONFIG_DRIVE_STRENGTH.

I was thinking about that, but:
drive strength is well defined saying you choose the drive strength in
mA (or some other variation of Amperes). That is not (directly) what you
can set in Zynq. In Zynq the config allows selecting IO-standards like
LVCMOS(1.8|2.5|3.3) or HSTL.
So, this might also map to a certain drive-strength, but is not really
mapping well to Zynq pin configuration options.
Hence, I thought introducing this new property which allows a more
flexible interpretation of the argument would be a better way and might
also help other pinctrl cases (though this is speculative).

	Thanks,
	Sören
