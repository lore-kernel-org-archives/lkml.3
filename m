Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaHMGc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:32:56 -0400
Received: from mail2.br-automation.com ([213.33.116.61]:48101 "EHLO
	mail2.br-automation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaHMGcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:32:54 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2014 02:32:53 EDT
X-AuditID: c0a80110-f79fa6d000000f93-1c-53eb030e149a
In-Reply-To: <20140812144625.GB9799@localhost>
References: <20140809052828.GA28307@udknight> <20140812144625.GB9799@localhost>
X-Disclaimed: 5742
To: Johan Hovold <johan@kernel.org>
Cc: andi@lisas.de, dforsi@gmail.com, gnomes@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, jhovold@gmail.com,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-kernel-owner@vger.kernel.org, linux-usb@vger.kernel.org,
        Wang YanQing <udknight@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7] usb:serial:pl2303: add GPIOs interface on PL2303
X-KeepSent: 3463CFCF:9AED608B-C1257D33:002239D7;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 July 11, 2011
Message-ID: <OF3463CFCF.9AED608B-ONC1257D33.002239D7-C1257D33.002297E8@br-automation.com>
From: Hannes Petermaier <Hannes.Petermaier@br-automation.com>
Date: Wed, 13 Aug 2014 08:17:50 +0200
X-MIMETrack: Serialize by Router on BRSMTP01/Eggelsberg/AT/B&R(Release 9.0.1|October 14, 2013) at
 13.08.2014 08:17:50,
	Serialize complete at 13.08.2014 08:17:50
Content-Type: text/plain; charset="US-ASCII"
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVyYAWjjS4/8+tggzU/2Swu/3vDYnF+4m4m
	i0lT/rJZNC9ez2axd5W0RdONHlaLKX+WM1ksaxCzuLxrDpvFomWtzBbbp/xncuD22DnrLrvH
	plWdbB53ru1h89g/dw27x5Kbah6tJzexenzeJBfAHsVlk5Kak1mWWqRvl8CVsfN6TsFt9oql
	3+4xNzC2sHUxcnJICJhITN1yhwnCFpO4cG89UJyLQ0hgM6PE4hkt7CAJTgE9iQ+TO1hAbCEB
	f4m3LV/YIRqEJF58mQoU5+AQEVCWmPJGEKSXWWAVk8T0y0vB6nkFBCVOznwCViMs4CHxoisd
	otVTYuWFnewwN7y7uJsJojxS4kTDVLA4m4CtxN8J68BsFgFViSMXDjODzJcQWMIoseXlEbAG
	ZgEdiROrjjFPYBSchWTdLCSpBYxMqxjFcxMzc4z0kop0E0tL8nMTSzLz8/SS83M3MUKiQ2AH
	4+432ocYBTgYlXh4l397FSzEmlhWXJl7iFGCg1lJhNdhC1CINyWxsiq1KD++qDQntfgQozQH
	i5I47/SghcFCAumJJanZqakFqUUwWSYOTqkGRkfZjI3/+pdqLnhRJH7Y7O1046B/Ve5n/UX/
	PCh4wRUe8/jdw/gd7Qt+9n2W2/2CudMxg/3E7B55JuZFLkt/2HpaS3ApPnn/oOe0Lb+h3hSG
	PS9266iUa65TMdt8yZVJ4oLvjZdnu9ZsU1zLvWEv8xvLWmertQnKEcclDhy5bFGSVHkk68O+
	ICWW4oxEQy3mouJEAJp5oIiKAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Known issue:
> > If gpios are in use(export to userspace through sysfs interface, etc),
> > then call pl2303_release(unplug usb-serial convertor, modprobe -r, 
etc),
> > will cause trouble, so we need to make sure there is no gpio user 
before
> > call pl2303_release.
> 
> This is a real problem that we need to address. gpiolib isn't really
> able to handle devices that just disappear. In fact, it's API claims 
that
> we must not call gpiochip_remove with requested gpios and this is
> exactly what you might do in pl2303hx_gpio_release below.
> 
> As I mentioned earlier, this crashes the kernel when a new gpiochip is
> later added (the gpiochip data structures are likely corrupted and we
> get a NULL pointer deref in gpiochip_find_base).
> 
> Linus, any thoughts on this?

Hi,
there are several USB to I2C bus adapters and I2C IO-Expanders,
how is this handled there ?

Maybe we you can take some idea from there.

best regards,
Hannes


