Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaBRRqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:46:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaBRRqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:46:02 -0500
Date: Tue, 18 Feb 2014 09:47:27 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER
 better
Message-ID: <20140218174727.GA14340@kroah.com>
References: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <380901392686780@web3m.yandex.ru>
 <20140218082436.GC32652@pengutronix.de>
 <136801392734047@web14m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <136801392734047@web14m.yandex.ru>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 06:34:07PM +0400, Evgeniy Polyakov wrote:
> Hi
> 
> 18.02.2014, 12:24, "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>:
> 
> > The thing is that the w1-gpio device might be probed before the gpio's
> > controller is available. In this case of_get_gpio returns -EPROBE_DEFER
> > and this makes the device core retry probing the w1-gpio device later
> > again. So this is not a dt-parsing problem but just dependency stuff.
> >
> > The 2nd issue addressed didn't happen to me, but it might occur that the
> > first of_get_gpio for the data pin succeeds, but the getting the pullup
> > gpio fails with -EPROBE_DEFER (e.g. because it sits on a different
> > controller). In this case you still want to retry probing later instead
> > of ignoring the problem.
> >
> > Does that make it clearer?
> 
> Well, yes, thank you :)
> 
> Greg, please pull this patch into your tree.

Already merged :)
