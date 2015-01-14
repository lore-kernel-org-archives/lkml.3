Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbbANRDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:03:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbANRDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:03:50 -0500
Date: Wed, 14 Jan 2015 18:03:45 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Xunlei Pang <pang.xunlei@linaro.org>
Cc: Xunlei Pang <xlpang@126.com>, lkml <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [RFC PATCH v2 5/9] rtc/mc13xxx: Update driver to address
 y2038/y2106 issues
Message-ID: <20150114170345.GM22880@pengutronix.de>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
 <1421163897-8020-6-git-send-email-xlpang@126.com>
 <CADcy93Xkyn-vg6zJw7S=1aO-i4ack66TLn8JHLuZShnB4nWKYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADcy93Xkyn-vg6zJw7S=1aO-i4ack66TLn8JHLuZShnB4nWKYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 14, 2015 at 11:07:31PM +0800, Xunlei Pang wrote:
> Cc Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Thanks, that was useful.

> 
> On 13 January 2015 at 23:44, Xunlei Pang <xlpang@126.com> wrote:
> > From: Xunlei Pang <pang.xunlei@linaro.org>
> >
> > This driver has a number of y2038/y2106 issues.
> >
> > This patch resolves them by:
> > - Replace rtc_time_to_tm() with rtc_time64_to_tm()
> > - Change mc13xxx_rtc_set_mmss() to use rtc_class_ops's set_mmss64()
> >
> > After this patch, the driver should not have any remaining
> > y2038/y2106 issues.
> >
> > Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
> > ---
> >  drivers/rtc/rtc-mc13xxx.c | 32 ++++++++++++++------------------
> >  1 file changed, 14 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
> > index 5bce904b..32df1d8 100644
> > --- a/drivers/rtc/rtc-mc13xxx.c
> > +++ b/drivers/rtc/rtc-mc13xxx.c
> > @@ -83,20 +83,19 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
> >                         return ret;
> >         } while (days1 != days2);
> >
> > -       rtc_time_to_tm(days1 * SEC_PER_DAY + seconds, tm);
> > +       rtc_time64_to_tm((time64_t)days1 * SEC_PER_DAY + seconds, tm);
> >
> >         return rtc_valid_tm(tm);
> >  }
> >
> > -static int mc13xxx_rtc_set_mmss(struct device *dev, unsigned long secs)
> > +static int mc13xxx_rtc_set_mmss(struct device *dev, time64_t secs)
I don't know if there is a usual conversion rule, but I'd expect that
the function is also renamed to get a suffix 64.

Other than that the patch looks good.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
