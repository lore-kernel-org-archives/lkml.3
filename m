Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaIDExY (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 4 Sep 2014 00:53:24 -0400
Received: from fallback7.mail.ru ([94.100.181.128]:51931 "EHLO
	fallback7.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaIDExW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:53:22 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?UGFua2FqIER1YmV5?= <pankaj.dubey@samsung.com>
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, naushad@samsung.com,
        =?UTF-8?B?J1RvbWFzeiBGaWdhJw==?= <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        tomasz.figa@gmail.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        lee.jones@linaro.org,
        =?UTF-8?B?J01pY2hhbCBTaW1layc=?= <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?J0FybmQgQmVyZ21hbm4n?= <arnd@arndb.de>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2Ml0gbWZkOiBzeXNjb246IERlY291cGxlIHN5c2NvbiBp?=
 =?UTF-8?B?bnRlcmZhY2UgZnJvbSBwbGF0Zm9ybSBkZXZpY2Vz?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [5.18.98.7]
Date: Thu, 04 Sep 2014 08:52:47 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1409806367.933281809@f338.i.mail.ru>
X-Cloud-Ids: 
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
X-Spam: undefined
In-Reply-To: <002601cfc7fa$39413580$abc3a080$@samsung.com>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
 <6034841.GFrG3XCMdb@wuerfel>
 <002601cfc7fa$39413580$abc3a080$@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by spinics.net id s844rYAI024655

Thu, 04 Sep 2014 10:09:19 +0530 Ğ¾Ñ‚ Pankaj Dubey <pankaj.dubey@samsung.com>:
> Hi Arnd,
> 
> On Tuesday, September 02, 2014 Arnd Bergmann wrote,
> > To: Pankaj Dubey
> > Cc: linux-arm-kernel@lists.infradead.org;
> linux-samsung-soc@vger.kernel.org; linux-
> > kernel@vger.kernel.org; lee.jones@linaro.org; kgene.kim@samsung.com;
> > linux@arm.linux.org.uk; vikas.sajjan@samsung.com; joshi@samsung.com;
> > naushad@samsung.com; thomas.ab@samsung.com; chow.kim@samsung.com;
> > tomasz.figa@gmail.com; Tomasz Figa; Alexander Shiyan; Michal Simek
> > Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from
> platform
> > devices
...
> > > -struct regmap *syscon_regmap_lookup_by_pdevname(const char *s) -{
> > > -	struct device *dev;
> > > -	struct syscon *syscon;
> > > -
> > > -	dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > > -				 syscon_match_pdevname);
> > > -	if (!dev)
> > > -		return ERR_PTR(-EPROBE_DEFER);
> > > -
> > > -	syscon = dev_get_drvdata(dev);
> > > -
> > > -	return syscon->regmap;
> > > -}
> > > -EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
> > 
> > I think this can actually be left intact if that helps with clps71xx.
> > It could be done in a hacky way using bus_find_device_by_name() to keep it
> simple,
> > or in a somewhat nicer way by keeping the syscon platform_driver around
> for the
> > non-DT case.
> > 
> 
> Ok as per our last discussion you mentioned that clps71xx will be soon
> migrating to DT.
> So if that is not going to happen sooner, I would also prefer better keep
> syscon_regmap_lookup_by_pdevname and syscon platform_driver for non-DT case,
> so that this issue should not block this patch.
> 
> So please let's make final call to keep syscon platform_driver for non-DT
> case which eventually
> can be dropped once clps71xx driver migrates to DT based. So that I can
> prepare next patchset
> keeping syscon platform_driver support  and syscon_regmap_lookup_by_pdevname
> API support
> for non-DT case and send across for review. 

Arnd, can you force the applying of the latest clps711x patches to accelerate the process?
I mean latest 3 arm-soc patches from Aug, 19.
After that I will need to make a patch for the SPI and TTY subsystems, then initial DT
support will be introduced.

---

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
