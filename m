Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3IUBZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 21:25:53 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:50310 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3IUBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 21:25:52 -0400
MIME-Version: 1.0
Date: Sat, 21 Sep 2013 04:25:51 +0300
Message-ID: <CAHuBVBb7B9UPiqZH0Y2MpMkUri02ApRMZfAwCctKG-tYnkbkSQ@mail.gmail.com>
Subject: Null pointer deference in drivers/power/pm2301_charger.c
From: Valentin Ilie <eminemix@gmail.com>
To: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am trying to solve a NULL pointer deference in
drivers/power/pm2301_charger.c (and to submit a trivial patch) but I
am not sure how to do it.

Line 958 - 961
pm2 = (struct pm2xxx_charger*)i2c_get_clientdata(pm2xxx_i2c_client);
        if (!pm2) {
                dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");

Line 976 - 978
pm2 = (struct pm2xxx_charger*)i2c_get_clientdata(pm2xxx_i2c_client);
        if (!pm2) {
                dev_err(pm2->dev, "no pm2xxx_charger data supplied\n");

As it can be clearly seen, pm2 is used with NULL value in dev_err. The
question is, how to fix this? Should I delete the dev_err line or can
I use printk (to avoid the need of a dev) ?

Thank you,
Valentin
