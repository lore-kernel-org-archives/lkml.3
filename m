Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaAMJsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:48:04 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:49707 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaAMJsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:48:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAOMwXhNyntnu7h_VOLWq3rh1EprNCnm8yByza6Bz-J9XQmA-sA@mail.gmail.com>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
	<1387814889-16670-4-git-send-email-lpapp@kde.org>
	<CACRpkdbAPYs=48RXr6r5kqkYj2V9GitRMT2BRKkn4_gT77wUEg@mail.gmail.com>
	<CAOMwXhNcmbk92TsNTGVQdfWrbVycVW++-+46+8onDZ5xPCD-Jw@mail.gmail.com>
	<CAOMwXhNyntnu7h_VOLWq3rh1EprNCnm8yByza6Bz-J9XQmA-sA@mail.gmail.com>
Date: Mon, 13 Jan 2014 10:48:01 +0100
Message-ID: <CACRpkdbpXCns4Z+AiFuijnvLJ91ZgMjiwmZZLJ0owKW1Sr-+xw@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: MAX6650/6651 support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:22 AM, Laszlo Papp <lpapp@kde.org> wrote:

> I was giving a second thought to this. Would it be acceptable to add
> the gpio driver now, and once the need arises, add the pinctrl thin
> layer on top of it?

I will not accept the platform data setting the pull-ups.

> My concern is that I would not use anything else
> than the gpio functionality of these pins. It would be a needless
> additional work (i.e. investment) for my project and employer.

But you are still expecting me as a subsystem maintainer to
take responsibility of this driver for as long as I have this role?

Rewriting code is a natural part of the community process,
noone claimed it would be easy ;-)

> Perhaps, the layer on top of that can be added later without any
> drawback if anyone ever finds the need to have more functionality
> supported by these pins?

Your driver already supports setting the pulls using a
*custom* platform data field. This is not OK, and shall be
implemented using the pin control subsystem. I will not
merge drivers using custom platform data fields like this.

The reason that the pin control subsystem even existed was
that at the time my drivers were NACKed because I tried to
shoehorn pin control into the GPIO subsystem, and as a
result now we have an apropriate subsystem for it, so please
use it.

Yours,
Linus Walleij
