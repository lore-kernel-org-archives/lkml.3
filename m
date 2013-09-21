Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188Ab3IUDVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 23:21:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3IUDVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 23:21:18 -0400
Message-ID: <1379733640.5488.3.camel@marge.simpson.net>
Subject: Re: Null pointer deference in drivers/power/pm2301_charger.c
From: Mike Galbraith <bitbucket@online.de>
To: Valentin Ilie <eminemix@gmail.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 21 Sep 2013 05:20:40 +0200
In-Reply-To: <CAHuBVBb7B9UPiqZH0Y2MpMkUri02ApRMZfAwCctKG-tYnkbkSQ@mail.gmail.com>
References: <CAHuBVBb7B9UPiqZH0Y2MpMkUri02ApRMZfAwCctKG-tYnkbkSQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:rwjHAnanXWGd4q7uU/u9Nd4twJBRxgxy7vILPuuTI3P
 p5mnDa7piqGnbpFOsSu6nx8xVRcY27GzRBGZDlWpTkAuDsgQfM
 aNvkTDOT8dP9vM3EhSFkfKRtcoSaY7DuJj/zcVXHD1gGVs15Dh
 ulahhiqOCs1D0JgP2uFfhh5NH4Spvmikei3SAoaF7tVmkw/0aK
 P5n+CvBVEW7VT2Vq0rAfYDG1EeldnfKkZk+pHN8CVcCt5fh05+
 +REyaSfetP8P4EDViezNchc/25N8Zgwto+lwSWB8HJ2lVZ77m9
 rc0CjeB1ws05gn5LsIiuBLYNsfOTHM2PVlMq+5grcNaIsfGSID
 yQ1ItSgA2jJPtkzHp7JhcHIaRRZfY/+lmNSyQ28diDFT7wMBaD
 XqVPjcsMbf38w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-21 at 04:25 +0300, Valentin Ilie wrote: 
> Hello,
> 
> I am trying to solve a NULL pointer deference in
> drivers/power/pm2301_charger.c (and to submit a trivial patch) but I
> am not sure how to do it.
> 
> Line 958 - 961
> pm2 = (struct pm2xxx_charger*)i2c_get_clientdata(pm2xxx_i2c_client);
>         if (!pm2) {
>                 dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");
> 
> Line 976 - 978
> pm2 = (struct pm2xxx_charger*)i2c_get_clientdata(pm2xxx_i2c_client);
>         if (!pm2) {
>                 dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");
> 
> As it can be clearly seen, pm2 is used with NULL value in dev_err. The
> question is, how to fix this? Should I delete the dev_err line or can
> I use printk (to avoid the need of a dev) ?

Looking below that, seems they perhaps meant &pm2xxx_i2c_client->dev.

-Mike

