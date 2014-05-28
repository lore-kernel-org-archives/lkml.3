Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbaE1Wh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:37:29 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43554 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaE1WhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <536BAD05.9070401@samsung.com>
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
	<536BA9E8.2030306@suse.de>
	<536BAD05.9070401@samsung.com>
Date: Wed, 28 May 2014 15:37:23 -0700
X-Google-Sender-Auth: w7H3BZjjeDMmgR-tUSV64hZcziI
Message-ID: <CAODwPW8FpsF6vo5Z8_+YXwchwab=7Ltv0nEvP_=907HK232xCg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
From: Julius Werner <jwerner@chromium.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, arunkk.samsung@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We originally tried using this driver on ChromiumOS and never got it
to work reliably. IIRC the issue was that if the hub had already been
initialized by firmware, the USB stack might enumerate it before the
usb3503 driver is probed and then the later reset will silently
disrupt that connection. (I think I tried to force the 3503 to probe
earlier as well, and there was some other issue with that although I
don't recall the details.)

This will not be an issue for the Snow and Peach_Pi(t) boards (since
neither of them shipped with firmware that supports this hub), but it
will be an issue for Spring and Skate. On ChromiumOS we decided to
carry a local (and admittedly ugly) patch to pull that reset line from
the USB PHY driver instead, since that's the only way I could get it
to work in all cases (see http://crosreview.com/58963).

This doesn't mean I'm against this patch per se, just wanted to point
out the trade-offs.
