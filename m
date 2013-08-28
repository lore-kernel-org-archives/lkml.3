Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3H1SYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:24:49 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:35586 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab3H1SYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAHbNUh06Rxd9JRieeXCydB_JwiUOrUXADL6nUGZxONQJmz2-CQ@mail.gmail.com>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
	<20130710052534.GB15674@arwen.pp.htv.fi>
	<CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
	<20130712065734.GE31802@arwen.pp.htv.fi>
	<CAHbNUh0Sa-atYMHbhEUX2vnVAcsdBJxw9RRzAp+6vqE8hi=p1w@mail.gmail.com>
	<20130827184447.GR3005@radagast>
	<CAHbNUh06Rxd9JRieeXCydB_JwiUOrUXADL6nUGZxONQJmz2-CQ@mail.gmail.com>
Date: Wed, 28 Aug 2013 11:24:46 -0700
X-Google-Sender-Auth: XrC1rFZPo9hl5X8un_AoJJvP0B4
Message-ID: <CAODwPW-NSrpeptTxts+9wkVwPeUgtHTBEKV0505cfz6f68EnRg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
From: Julius Werner <jwerner@chromium.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>, Julius Werner <jwerner@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tried to get the 3503 driver to work in my case for quite some
time, but ultimately gave up. For me, playing around with the load
order was not enough to solve all issues. When you try to build a
permanent, clean solution for this, you should definitely also test
the case where the hub has already been initialized and configured by
firmware before the kernel booted, because that brought on another
bunch of issues for me.

I think it ultimately only works reliably when you first reset the
hub, then reset the HSIC port on the PHY side before the USB core gets
a chance to talk to it again (thus one of the drivers needs to be
directly connected to and call the other).
