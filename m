Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbaJ3Ozw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:55:52 -0400
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:51456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756002AbaJ3Ozv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:55:51 -0400
X-Greylist: delayed 127997 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2014 10:55:50 EDT
From: Huan Wang <alison.wang@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] audio: sai: Add Power Management support
Thread-Topic: [PATCH] audio: sai: Add Power Management support
Thread-Index: AQHP82yXa8Mh/U0xYkW2IwDuBTMksJxIswrW
Date: Thu, 30 Oct 2014 14:55:47 +0000
Message-ID: <1414680936299.29360@freescale.com>
References: <1414552896-20797-1-git-send-email-b18965@freescale.com>,<20141029113634.GF18557@sirena.org.uk>
In-Reply-To: <20141029113634.GF18557@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [221.223.183.133]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0692;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(92726001)(92566001)(86362001)(31966008)(101416001)(36756003)(50986999)(76176999)(54356999)(97736003)(117636001)(21056001)(4396001)(64706001)(66066001)(20776003)(95666004)(99286002)(107046002)(106116001)(106356001)(105586002)(85306004)(80022003)(46102003)(110136001)(76482002)(87936001)(77096002)(2656002)(120916001)(85852003)(40100003)(122556002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0692;H:BN1PR0301MB0689.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9UEui8s013129

Hi,

On Wed, Oct 29, 2014 at 11:21:36AM +0800, Alison Wang wrote:
> This patch adds Power Management support for SAI.
> Activate regmap cache with REGCACHE_RBTREE, and use

Are you sure that REGCACHE_RBTREE is the best option here?  For MMIO
devices the cost tradeoff for the rbtree is usually higher than people
like so flat caches are preferred.  But if it works for you that's fine,
this shouldn't be *that* performance critical.

I'm also a bit surprised that this works without register defaults being
provided since we need to make sure we allocate the rbtree nodes outside
of the spinlock we use to lock MMIO access - was this tested with
mainline?

[Alison Wang] I tested rbtree and flat caches, they both work. But I didn't pay attention to the cost tradeoff and register defaults before, so I think flat caches are preferred now. 

Thanks.

Best Regards,
Alison Wang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
