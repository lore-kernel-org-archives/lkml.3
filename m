Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934481AbaJ3O4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:56:45 -0400
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:20143
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932860AbaJ3O4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:56:44 -0400
From: Huan Wang <alison.wang@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "perex@perex.cz" <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "Liam Girdwood" <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: Re: [PATCH] audio: sai: Add Power Management support
Thread-Topic: [PATCH] audio: sai: Add Power Management support
Thread-Index: AQHP83SZa8Mh/U0xYkW2IwDuBTMksJxItVl+
Date: Thu, 30 Oct 2014 14:56:42 +0000
Message-ID: <1414680990680.12980@freescale.com>
References: <1414552896-20797-1-git-send-email-b18965@freescale.com>,<CAOMZO5Ah4H1WDvFOBMhw7RS7XwSNSEet3u_emELFZTGD7rUzyw@mail.gmail.com>
In-Reply-To: <CAOMZO5Ah4H1WDvFOBMhw7RS7XwSNSEet3u_emELFZTGD7rUzyw@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [221.223.183.133]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377454003)(199003)(189002)(122556002)(76176999)(86362001)(97736003)(76482002)(46102003)(36756003)(54356999)(80022003)(117636001)(77096002)(50986999)(40100003)(21056001)(110136001)(92566001)(92726001)(120916001)(85852003)(99286002)(95666004)(66066001)(107046002)(2656002)(19580405001)(19580395003)(106116001)(106356001)(101416001)(87936001)(31966008)(20776003)(64706001)(85306004)(4396001)(105586002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:BN1PR0301MB0689.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9UEuoNR013134

Hi, Fabio,

Please always add the driver maintainers (Xiubo Li and Nicolin Chen).
[Alison Wang] ok, thanks for your reminder.

On Wed, Oct 29, 2014 at 1:21 AM, Alison Wang <b18965@freescale.com> wrote:

> +#ifdef CONFIG_PM_SLEEP
> +static int fsl_sai_suspend(struct device *dev)
> +{
> +       struct fsl_sai *sai = dev_get_drvdata(dev);
> +
> +       regcache_cache_only(sai->regmap, true);
> +       regcache_mark_dirty(sai->regmap);
> +
> +       return 0;
> +}
> +
> +static int fsl_sai_resume(struct device *dev)
> +{
> +       struct fsl_sai *sai = dev_get_drvdata(dev);
> +
> +       /* Restore all registers */
> +       regcache_cache_only(sai->regmap, false);
> +       regcache_sync(sai->regmap);
> +
> +       return 0;
> +};
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static const struct dev_pm_ops fsl_sai_pm = {
> +       SET_SYSTEM_SLEEP_PM_OPS(fsl_sai_suspend, fsl_sai_resume)

This could be simplified to:
static SIMPLE_DEV_PM_OPS(fsl_sai_pm, fsl_sai_suspend, fsl_sai_resume);
[Alison Wang] ok.

I am also curious as to how you tested it, as I noticed that
suspend/resume is broken on 3.18-rc for mx6sx.

Are you able to do suspend/resume on 3.18-rc on a mx6sx sdb board?
[Alison Wang] No, I don't have that board. I tested on LS1021A QDS board which supports deep sleep.

Best Regards,
Alison Wangÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
