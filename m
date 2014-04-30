Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaD3DE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:04:58 -0400
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:26316
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751713AbaD3DEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:04:55 -0400
X-Greylist: delayed 1126 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2014 23:04:55 EDT
Date: Tue, 29 Apr 2014 21:31:30 -0500
From: Brian Austin <brian.austin@cirrus.com>
X-X-Sender: heelrod@heelrod
To: Xia Kaixu <kaixu.xia@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <linaro-kernel@lists.linaro.org>, Lars-Peter Clausen <lars@metafoo.de>,
        <arnd@arndb.de>, Sangbeom Kim <sbkim73@samsung.com>,
        Timur Tabi <timur@tabi.org>, <linux-samsung-soc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        <linux-input@vger.kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [alsa-devel] [PATCH 01/15] ASoC: CS42L51 and WM8962 codecs depend
 on INPUT
In-Reply-To: <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
Message-ID: <alpine.DEB.2.02.1404292124270.31465@heelrod>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-2-git-send-email-kaixu.xia@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:141.131.128.20;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(164054003)(24454002)(189002)(51704005)(199002)(99396002)(19580405001)(92566001)(76482001)(54356999)(83322001)(87936001)(50986999)(44976005)(76176999)(83506001)(19580395003)(50466002)(77982001)(83072002)(86362001)(74662001)(81342001)(74502001)(6806004)(80976001)(92726001)(23726002)(47776003)(79102001)(33716001)(31966008)(85852003)(46102001)(80022001)(81542001)(20776003)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB050;H:mail2.cirrus.com;FPR:AEA2F234.8C13C2D2.39E113BF.84E2EE51.201FF;MLV:sfv;PTR:mail2.cirrus.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: cirrus4.onmicrosoft.com
X-Forefront-PRVS: 0197AFBD92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Apr 2014, Xia Kaixu wrote:

> From: Arnd Bergmann <arnd@arndb.de>
>
> Building ARM randconfig got into a situation where CONFIG_INPUT
> is turned off and SND_SOC_ALL_CODECS is turned on, which failed
> for two codecs trying to use the input subsystem. Some other
> drivers also select one of these codecs and consequently need an
> explicit dependency added.

I assume you mean the CS42L52 instead of the L51. INPUT is used for a BEEP 
Generator but when I disable CONFIG_INPUT I do not get an error. Is there 
any information available on what the error is?


>
> Appending to the dependency list seems the easiest way out,
> since this is not a practical limitation. If anyone really
> needs to build these codecs for a kernel with no input support,
> a more sophisticated solution can be implemented.
>
It shouldn't build the BEEP code without CONFIG_INPUT enabled as you can 
use the CODEC without the BEEP enabled.

I believe the WM8962 is done the same way.

Thanks,
Brian
