Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaJ3Dao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:30:44 -0400
Received: from mail-bn1bon0110.outbound.protection.outlook.com ([157.56.111.110]:36329
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751046AbaJ3Dan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:30:43 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Huan Wang <alison.wang@freescale.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] audio: sai: Add Power Management support
Thread-Topic: [PATCH] audio: sai: Add Power Management support
Thread-Index: AQHP8ygBbuZKeBfKBUWxqqFbaRT46JxG8t4AgAD7S5A=
Date: Thu, 30 Oct 2014 03:30:40 +0000
Message-ID: <718ee124537a4f4091bdf5242d256705@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1414552896-20797-1-git-send-email-b18965@freescale.com>
 <20141029113634.GF18557@sirena.org.uk>
In-Reply-To: <20141029113634.GF18557@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0693;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(43544003)(164054003)(24454002)(13464003)(51704005)(189002)(199003)(377454003)(97736003)(106116001)(4396001)(74316001)(77096002)(120916001)(92566001)(101416001)(99396003)(76576001)(107046002)(108616004)(21056001)(105586002)(64706001)(99286002)(106356001)(95666004)(20776003)(66066001)(19580395003)(33646002)(19580405001)(87936001)(76482002)(86362001)(46102003)(122556002)(2656002)(85852003)(31966008)(85306004)(50986999)(54356999)(40100003)(80022003)(76176999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0693;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org]
> On Behalf Of Mark Brown
> Sent: Wednesday, October 29, 2014 7:37 PM
> To: Wang Huan-B18965
> Cc: alsa-devel@alsa-project.org; tiwai@suse.de; linux-kernel@vger.kernel.org;
> lgirdwood@gmail.com; perex@perex.cz; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH] audio: sai: Add Power Management support
> 
> On Wed, Oct 29, 2014 at 11:21:36AM +0800, Alison Wang wrote:
> > This patch adds Power Management support for SAI.
> > Activate regmap cache with REGCACHE_RBTREE, and use
> 
> Are you sure that REGCACHE_RBTREE is the best option here?  For MMIO
> devices the cost tradeoff for the rbtree is usually higher than people
> like so flat caches are preferred.  But if it works for you that's fine,
> this shouldn't be *that* performance critical.
> 

Yes, the flat caches will have higher performance and can also fix the
Register defaults and spinlock issue here.

One more thing, if the device is not performance critical, then shouldn't we
Take care of the cache memory consumption to determine using flat or rbtree
Type ?

Thanks,

BRs
Xiubo


> I'm also a bit surprised that this works without register defaults being
> provided since we need to make sure we allocate the rbtree nodes outside
> of the spinlock we use to lock MMIO access - was this tested with
> mainline?
