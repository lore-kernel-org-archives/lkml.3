Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaBRAdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:33:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:65087 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaBRAdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:33:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,864,1384329600"; 
   d="scan'208";a="483136051"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
Thread-Topic: [PATCH v3 5/5] PM / sleep: Asynchronous threads for
 suspend_late
Thread-Index: AQHPLAOWo9WcNZRu2UKuVKJ8t51U05q6KbcQ
Date: Tue, 18 Feb 2014 00:33:11 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01C241FF@SHSMSX101.ccr.corp.intel.com>
References: <1392617954-5292-6-git-send-email-chuansheng.liu@intel.com>
 <10253072.9TaPuJL1lG@vostro.rjw.lan>
In-Reply-To: <10253072.9TaPuJL1lG@vostro.rjw.lan>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1I0XVF4021470

Hello Rafael,

> -----Original Message-----
> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> Sent: Tuesday, February 18, 2014 1:28 AM
> To: Liu, Chuansheng
> Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
> 
> On Monday, February 17, 2014 02:19:14 PM Chuansheng Liu wrote:
> > In analogy with commits 5af84b82701a and 97df8c12995, using
> > asynchronous threads can improve the overall suspend_late
> > time significantly.
> >
> > This patch is for suspend_late phase.
> >
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > ---
> >  drivers/base/power/main.c | 66
> ++++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 54 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > index 72b4c9c..c031050 100644
> > --- a/drivers/base/power/main.c
> > +++ b/drivers/base/power/main.c
> > @@ -1127,16 +1127,26 @@ static int dpm_suspend_noirq(pm_message_t
> state)
> >   *
> >   * Runtime PM is disabled for @dev while this function is being executed.
> >   */
> > -static int device_suspend_late(struct device *dev, pm_message_t state)
> > +static int __device_suspend_late(struct device *dev, pm_message_t state,
> bool async)
> >  {
> >  	pm_callback_t callback = NULL;
> >  	char *info = NULL;
> > -	int error;
> > +	int error = 0;
> > +
> > +	dpm_wait_for_children(dev, async);
> >
> 
> Like in patch [4/5], all of the "goto Complete" statements can go before
> the waiting.
> 
You are right, will do that in patch V4, thanks your reviewing.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
