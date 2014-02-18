Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbaBROeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:34:14 -0500
Received: from forward3m.mail.yandex.net ([37.140.138.3]:35110 "EHLO
	forward3m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534AbaBROeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:34:11 -0500
From: Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140218082436.GC32652@pengutronix.de>
References: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <380901392686780@web3m.yandex.ru> <20140218082436.GC32652@pengutronix.de>
Subject: Re: [PATCH] w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER better
MIME-Version: 1.0
Message-Id: <136801392734047@web14m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Feb 2014 18:34:07 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

18.02.2014, 12:24, "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>:

> The thing is that the w1-gpio device might be probed before the gpio's
> controller is available. In this case of_get_gpio returns -EPROBE_DEFER
> and this makes the device core retry probing the w1-gpio device later
> again. So this is not a dt-parsing problem but just dependency stuff.
>
> The 2nd issue addressed didn't happen to me, but it might occur that the
> first of_get_gpio for the data pin succeeds, but the getting the pullup
> gpio fails with -EPROBE_DEFER (e.g. because it sits on a different
> controller). In this case you still want to retry probing later instead
> of ignoring the problem.
>
> Does that make it clearer?

Well, yes, thank you :)

Greg, please pull this patch into your tree.

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
