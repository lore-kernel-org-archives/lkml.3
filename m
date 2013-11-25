Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3KYRG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 12:06:27 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65123 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab3KYRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 12:06:25 -0500
MIME-Version: 1.0
In-Reply-To: <5292DBF1.7040709@roeck-us.net>
References: <5292DBF1.7040709@roeck-us.net>
Date: Mon, 25 Nov 2013 09:06:22 -0800
Message-ID: <CAAYSxhqA5ngXN7qRWuY5OyNcSO8MzX3UobPwN1nT0k-48ti3yg@mail.gmail.com>
Subject: Re: Compile error in i2c-bcm-kona.c
From: Tim Kryger <tim.kryger@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 9:11 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> Upstream HEAD, arm allmodconfig:
>
> drivers/i2c/busses/i2c-bcm-kona.c:894:1: error: '__mod_of_device_table'
> aliased to undefined symbol 'kona_i2c_of_match'
> make[3]: *** [drivers/i2c/busses/i2c-bcm-kona.o] Error 1
> make[2]: *** [drivers/i2c/busses] Error 2
> make[1]: *** [drivers/i2c] Error 2
> make[1]: *** Waiting for unfinished jobs....
>
> Source:
>
> static const struct of_device_id bcm_kona_i2c_of_match[] = {
>         {.compatible = "brcm,kona-i2c",},
>         {},
> };
> MODULE_DEVICE_TABLE(of, kona_i2c_of_match);
>
> Makes me wonder how this was tested :-(.
>
> Guenter

The statically linked driver was tested extensively but I forgot to
test it as a module.

Please accept my sincerest apologies for this oversight.

I will prepare, test, and post a fix shortly.

-Tim
