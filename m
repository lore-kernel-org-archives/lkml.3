Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaL3DBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:01:40 -0500
Received: from mail-bn1bon0116.outbound.protection.outlook.com ([157.56.111.116]:64768
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751659AbaL3DBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:01:39 -0500
Date: Tue, 30 Dec 2014 10:29:18 +0800
From: Zidan Wang <b50113@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "ckeepax@opensource.wolfsonmicro.com" 
	<ckeepax@opensource.wolfsonmicro.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH v4] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Message-ID: <20141230022917.GA17807@b50113>
References: <1418103916-31295-1-git-send-email-b50113@freescale.com>
 <20141222181045.GH17800@sirena.org.uk>
 <BN3PR0301MB125132692CD535B9AC1795A98D510@BN3PR0301MB1251.namprd03.prod.outlook.com>
 <20141229160514.GQ17800@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141229160514.GQ17800@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(24454002)(189002)(199003)(4396001)(68736005)(86362001)(6806004)(33716001)(50466002)(104016003)(106466001)(47776003)(20776003)(92566001)(50986999)(87936001)(2950100001)(84676001)(46102003)(77096005)(107046002)(83506001)(64706001)(21056001)(85426001)(97736003)(110136001)(77156002)(105606002)(99396003)(23726002)(33656002)(76176999)(54356999)(62966003)(93886004)(46406003)(31966008)(97756001)(120916001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0613;
X-Forefront-PRVS: 04410E544A
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 02:28:22.8424
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0613
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 04:05:14PM +0000, Mark Brown wrote:
> On Mon, Dec 29, 2014 at 10:59:08AM +0000, Zidan Wang wrote:
> > Hi Mark,
> 
> Don't top post and please fix your mailer to word wrap within paragraphs
> and avoid corrupting the mail it's quoting.
> 
> > You are right. When PM is disabled, the codec will not work. But there are also some codecs enable mclk in PM, such as wm8962, cs42xx8.
> > And some codecs enable codec mclk in i2c probe(), startup() and set_bias_level(). It makes me confused.	
> > Can you tell me what's the general idiom to enable mclk. Thanks.
> 
> Like I said in the mail to which you replied:
> 
> > > This isn't going to work if PM is disabled (which is still a valid configuration).  The general idiom for this is that the driver should start up with everything powered up then let runtime idle turn things off if they're not required.  That way if runtime PM is disabled then the system will still work as everything will just stay powered on all the time.

I want put mclk enable to set_bias_level. Do you thinks it make sense?
