Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3KGIhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:37:17 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12599 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab3KGIhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:37:01 -0500
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Thu, 7 Nov 2013 09:36:57 +0100
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        "Svensson, Lars 1" <Lars1.Svensson@sonymobile.com>
Subject: Re: [PATCH 1/1] MMC: Detect execution mode errors after r/w command
Message-ID: <20131107083657.GA2558@caracas.corpusers.net>
References: <1381411688-7128-1-git-send-email-oskar.andero@sonymobile.com>
 <CAPDyKFpMVFWO5=dpeqDuj7wyxvvxRgHtnEtKAKEFVeZd-FipBQ@mail.gmail.com>
 <20131022112117.GA2286@caracas.corpusers.net>
 <CAPDyKFrYvw0RjscTZbq+4DFoV_xiYAH=KcseC=T4bT5+RPUrGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPDyKFrYvw0RjscTZbq+4DFoV_xiYAH=KcseC=T4bT5+RPUrGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On 18:50 Tue 22 Oct     , Ulf Hansson wrote:
> > And this is after the patch has been applied:
> >               KB  reclen   write rewrite    read    reread
> >            51200       4     251     990     3280     3244
> >            51200       8     460    1545     4460     4463
> >            51200      16     878    2633     7023     7028
> >            51200      32    1380    4394     9802     9832
> >            51200      64    2457    6216    12314    12314
> >            51200     128    3667    7894    14087    14088
> >            51200     256    6422    5916    15085    15086
> >            51200     512    5536   10994    12571    15659
> >            51200    1024    9112    9499    16203    16205
> >            51200    2048   10197   10502    16363    16368
> >            51200    4096   10524   10238     8850    16309
> >            51200    8192    9615   10456    16528    16529
> >            51200   16384   10553   10428    16803    16803
> 
> Hi Oskar,
> 
> The numbers were not that impressing from the beginning, so that could
> be why you don't see any impact.
> What kind of card are you using, eMMC/SD? In what speed mode are the
> card operating in?

The test was run on an Beagleboard with sdcard. I will try to find another board with
eMMC support and rerun the tests.

> >> > +       /*
> >> > +        * Try to get card status which indicates the card state after
> >> > +        * command execution. If the first attempt fails, we can't be
> >> > +        * sure the returned status is for the r/w command.
> >> > +        */
> >> > +       for (retries = 2; retries >= 0; retries--) {
> >> > +               err = get_card_status(card, &status, 0);
> >> > +               if (!err)
> >> > +                       break;
> >> > +
> >> > +               status_valid = false;
> >> > +               pr_err("%s: error %d sending status command, %sing\n",
> >> > +                      req->rq_disk->disk_name, err,
> >> > +                      retries ? "retry" : "abort");
> >> > +       }
> >>
> >> Do we have to issue a CMD13 (get_card_status), even if we are using
> >> the open-ended transmission sequence? In other words, could we make
> >> use of the response from CMD12 (stop transmission) instead?
> >
> > That's probably a good idea. Do you know of a way to check if CMD12 has been
> > sent or not?
> 
> Have a look for "mmc_host_cmd23", which gets translated into
> "MMC_BLK_CMD23" for the mmc block layer. This will give you some hints
> of were to look.

Thanks! We will revise the patch according to your comments.

-Oskar
