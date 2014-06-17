Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933702AbaFQQBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:01:12 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35293 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933337AbaFQQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:01:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpqb=pSR0ZKXdgqJOAWioC+x2OqA7nVR4Q74iVQPfqXMg@mail.gmail.com>
References: <1402189798-7665-1-git-send-email-houcheng@gmail.com>
	<CAPDyKFpqb=pSR0ZKXdgqJOAWioC+x2OqA7nVR4Q74iVQPfqXMg@mail.gmail.com>
Date: Wed, 18 Jun 2014 00:01:08 +0800
Message-ID: <CAL8JtxB3DoWRwox4zn5mkP6UjejPWUYxzmuxZMLPxyMmPW8MNg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpio: Add a defer reset object to send board specific reset
From: Houcheng Lin <houcheng@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-06-16 21:18 GMT+08:00 Ulf Hansson <ulf.hansson@linaro.org>:
>
> If I understand correct, you need a per device reset functionality?
> And obviously the reset implementation is board/SoC specific.
>
> We have the "Reset Controller framework", drivers/reset. Could this help you?
>
> Kind regards
> Ulf Hansson
>

Thanks for your information. The defer reset object is to send
board specific reset signal and this signal has to be sent after
some device is intialized. For example, a USB device may need extra
reset signal after root hub is initialized.

As machine init code is run before driver init-call, can not add reset
sending here if it depends on a specific device's initialization.

Also it provides a DT node that helps both HW/SW developer to use this
feature.

Best regards,
Houcheng Lin
