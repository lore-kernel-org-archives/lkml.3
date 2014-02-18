Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaBRPOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:14:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53611 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755354AbaBRPOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 10:14:37 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Brown, Len" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
Date: Tue, 18 Feb 2014 16:29:26 +0100
Message-ID: <4518865.xplOjLcUGM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01C241FF@SHSMSX101.ccr.corp.intel.com>
References: <1392617954-5292-6-git-send-email-chuansheng.liu@intel.com> <10253072.9TaPuJL1lG@vostro.rjw.lan> <27240C0AC20F114CBF8149A2696CBE4A01C241FF@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 18, 2014 12:33:11 AM Liu, Chuansheng wrote:
> Hello Rafael,
> 
> > -----Original Message-----
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Tuesday, February 18, 2014 1:28 AM
> > To: Liu, Chuansheng
> > Cc: gregkh@linuxfoundation.org; Brown, Len; pavel@ucw.cz;
> > linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Zhuangzhi
> > Subject: Re: [PATCH v3 5/5] PM / sleep: Asynchronous threads for suspend_late
> > 
> > On Monday, February 17, 2014 02:19:14 PM Chuansheng Liu wrote:
> > > In analogy with commits 5af84b82701a and 97df8c12995, using
> > > asynchronous threads can improve the overall suspend_late
> > > time significantly.
> > >
> > > This patch is for suspend_late phase.
> > >
> > > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > > ---
> > >  drivers/base/power/main.c | 66
> > ++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 54 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > > index 72b4c9c..c031050 100644
> > > --- a/drivers/base/power/main.c
> > > +++ b/drivers/base/power/main.c
> > > @@ -1127,16 +1127,26 @@ static int dpm_suspend_noirq(pm_message_t
> > state)
> > >   *
> > >   * Runtime PM is disabled for @dev while this function is being executed.
> > >   */
> > > -static int device_suspend_late(struct device *dev, pm_message_t state)
> > > +static int __device_suspend_late(struct device *dev, pm_message_t state,
> > bool async)
> > >  {
> > >  	pm_callback_t callback = NULL;
> > >  	char *info = NULL;
> > > -	int error;
> > > +	int error = 0;
> > > +
> > > +	dpm_wait_for_children(dev, async);
> > >
> > 
> > Like in patch [4/5], all of the "goto Complete" statements can go before
> > the waiting.
> > 
> You are right, will do that in patch V4, thanks your reviewing.

I've queued up your last series:

http://marc.info/?l=linux-pm&m=139269109711745&w=4

for 3.15, but I've rebased it on some patches already in my queue, so please
double check the result in linux-pm.git/bleeding-edge.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
