Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3CKQR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:17:29 -0400
Received: from f314.mail.ru ([128.140.169.178]:56816 "EHLO f314.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374Ab3CKQR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:17:28 -0400
X-Greylist: delayed 21639 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 12:17:28 EDT
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?QXJuZCBCZXJnbWFubg==?= <arnd@arndb.de>
Cc: =?UTF-8?B?RG9uZyBBaXNoZW5n?= <b29396@freescale.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?RG9uZyBBaXNoZW5n?= <dong.aisheng@linaro.org>,
        =?UTF-8?B?U2FtdWVsIE9ydGl6?= <sameo@linux.intel.com>,
        =?UTF-8?B?TWFyayBCcm93bg==?= <broonie@opensource.wolfsonmicro.com>,
        =?UTF-8?B?VGhpZXJyeSBSZWRpbmc=?= <thierry.reding@avionic-design.de>,
        =?UTF-8?B?R3JlZyBLcm9haC1IYXJ0bWFu?= <gregkh@linuxfoundation.org>,
        =?UTF-8?B?RG1pdHJ5IFRvcm9raG92?= <dmitry.torokhov@gmail.com>,
        =?UTF-8?B?U3RlcGhlbiBXYXJyZW4=?= <swarren@wwwdotorg.org>
Subject: =?UTF-8?B?UmVbMl06IFtQQVRDSCB2NiAyLzJdIG1mZDogc3lzY29uOiBBZGQgbm9uLURU?=
 =?UTF-8?B?IHN1cHBvcnQ=?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Mon, 11 Mar 2013 20:17:23 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1363018643.895028941@f314.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Spam: Not detected
X-Mras: Ok
In-Reply-To: <201303111338.56679.arnd@arndb.de>
References: <1362063434-8318-1-git-send-email-shc_work@mail.ru> <20130311103541.GC6280@b29396-Latitude-E6410> <201303111338.56679.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2BGHSZf008002

> On Monday 11 March 2013, Dong Aisheng wrote:
> > > > > + dev = driver_find_device(&syscon_driver.driver, NULL, (void *)s,
> > > > > +                          syscon_match_pdevname);
> > > > > + if (!dev)
> > > > > +         return ERR_PTR(-ENODEV);
> > > > 
> > > > Should it be ERR_PTR(-EPROBE_DEFER)?
> > > 
> > > I have no idea what better using here. Think that is not so important
> > > since we may have only one possible error code here.
> > 
> > I'm not quite understand your meaning.
> > Since the syscon device may be still not registered,
> > so it may be better to return a EPROBE_DERFER which is the same
> > as dt version.
> 
> I'm guessing that Alexander has not encountered deferred probing yet.
> Alexander, the point here is that returning -EPROBE_DEFER has the
> advantage that a probe() callback calling this function can
> simply return that error code to the driver core. If the driver
> core sees -EPROBE_DEFER, it will retry the same probe function
> later, after all other device probe functions have been called
> and at least one of them was successful. This way you can load the
> syscon driver after loading a driver depending on it and everything
> will still work.

You are right Arnd. I usually try to control the correct order of loading
drivers. Using EPROBE_DEFER in this procedure is more correct.
Probably time for v7... I hope it will finally be the last.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
