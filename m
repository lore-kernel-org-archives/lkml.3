Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab3KYFLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 00:11:17 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55310 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3KYFLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 00:11:15 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5292DBF1.7040709@roeck-us.net>
Date: Sun, 24 Nov 2013 21:11:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Tim Kryger <tim.kryger@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Compile error in i2c-bcm-kona.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upstream HEAD, arm allmodconfig:

drivers/i2c/busses/i2c-bcm-kona.c:894:1: error: '__mod_of_device_table' aliased to undefined symbol 'kona_i2c_of_match'
make[3]: *** [drivers/i2c/busses/i2c-bcm-kona.o] Error 1
make[2]: *** [drivers/i2c/busses] Error 2
make[1]: *** [drivers/i2c] Error 2
make[1]: *** Waiting for unfinished jobs....

Source:

static const struct of_device_id bcm_kona_i2c_of_match[] = {
         {.compatible = "brcm,kona-i2c",},
         {},
};
MODULE_DEVICE_TABLE(of, kona_i2c_of_match);

Makes me wonder how this was tested :-(.

Guenter
