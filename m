Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab3BVUxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:53:13 -0500
Received: from [89.21.227.133] ([89.21.227.133]:56037 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758622Ab3BVUxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:53:11 -0500
Message-ID: <5127DAB3.5040708@itdev.co.uk>
Date: Fri, 22 Feb 2013 20:53:07 +0000
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Meerwald <pmeerw@pmeerw.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        bleung@chromium.org, olofj@chromium.org
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk> <alpine.DEB.2.01.1302222111420.1668@pmeerw.net>
In-Reply-To: <alpine.DEB.2.01.1302222111420.1668@pmeerw.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Meerwald wrote:
> the series gets rid of the fragile binary config data and handle_pdata()
> - I like it, but haven't tested yet
> 
> is there a reference to the specification of the new config format? the
> format of the old pdata->config was immediately obvious from reading the
> source, the new way not so much...

It's basically:

OBP_RAW V1
family_id variant_id version build x_size y_size num_objects
info_block_crc
config_crc
<type> <instance> <num_bytes> <object_bytes...>
(repeat last line for each object/instance)

Everything is ASCII hex. It's designed to be simple to parse/generate. We
also have an INI like format called xcfg which is much friendlier to
humans, but parsing that in a kernel driver would be a bit horrid.

I can point you to a bit of code that writes it:

https://github.com/atmel-maxtouch/obp-utils/blob/master/src/libmaxtouch/config.c#L39

It will not read the config CRC, but you can get that from dmesg output
(it's in T6 messages).

You can try the mxt-app tool without the driver changes via i2c-dev, just
run it like "mxt-app -d2 -a4b" (for /dev/i2c-2, addr 4b).

cheers

-- 
Nick Dyer
Senior Software Engineer, ITDev
Hardware and Software Development Consultancy
