Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaEEIjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:39:03 -0400
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57675 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755120AbaEEIjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:39:01 -0400
Date: Mon, 5 May 2014 11:38:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: m.chehab@samsung.com, linux-dev@sensoray.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [media] s2255drv: fix memory leak s2255_probe()
Message-ID: <20140505083856.GZ8753@valkosipuli.retiisi.org.uk>
References: <1408657.25U3i1DfG3@daeseok-laptop.cloud.net>
 <20140415093305.GE8753@valkosipuli.retiisi.org.uk>
 <CAHb8M2CECG7ydo9L2u5BOcQeq8V3=ydy149kCLkoueo+HbD6fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2CECG7ydo9L2u5BOcQeq8V3=ydy149kCLkoueo+HbD6fg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 07:54:43PM +0900, DaeSeok Youn wrote:
> Hi, Sakari
> 
> 2014-04-15 18:33 GMT+09:00 Sakari Ailus <sakari.ailus@iki.fi>:
> > Hi Daeseok,
> >
> > On Tue, Apr 15, 2014 at 01:49:34PM +0900, Daeseok Youn wrote:
> >>
> >> smatch says:
> >>  drivers/media/usb/s2255/s2255drv.c:2246 s2255_probe() warn:
> >> possible memory leak of 'dev'
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >>  drivers/media/usb/s2255/s2255drv.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> >> index 1d4ba2b..8aca3ef 100644
> >> --- a/drivers/media/usb/s2255/s2255drv.c
> >> +++ b/drivers/media/usb/s2255/s2255drv.c
> >> @@ -2243,6 +2243,7 @@ static int s2255_probe(struct usb_interface *interface,
> >>       dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
> >>       if (dev->cmdbuf == NULL) {
> >>               s2255_dev_err(&interface->dev, "out of memory\n");
> >> +             kfree(dev);
> >>               return -ENOMEM;
> >>       }
> >>
> >
> > The rest of the function already uses goto and labels for error handling. I
> > think it'd take adding one more. dev is correctly released in other error
> > cases.
> I am not sure that adding a new label for error handling when
> allocation for dev->cmdbuf is failed.
> I think it is ok to me. :-) Because I think it is not good adding a
> new label and use goto statement for this.

I can ack this if you use the same pattern for error handling that's already
there.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
