Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986Ab3JOOyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:54:23 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39834 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932311Ab3JOOyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:54:21 -0400
Message-ID: <525D5716.2000109@free-electrons.com>
Date: Tue, 15 Oct 2013 16:54:14 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: Anton Vorontsov <anton@enomsg.org>, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] bq2415x_charger: fix max battery regulation voltage
References: <1380709462-860-1-git-send-email-alexandre.belloni@free-electrons.com> <201310151556.23557@pali>
In-Reply-To: <201310151556.23557@pali>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 15/10/2013 15:56, Pali Rohár wrote:
> On Wednesday 02 October 2013 12:24:22 Alexandre Belloni wrote:
>> As per the datasheets, maximum battery regulation voltage is
>> 4440mV.
>>
>> The formula is (voltage - offset) / step, so the maximum value
>> is: (4440 - 3500) / 20 = 47
>>
>> Signed-off-by: Alexandre Belloni
>> <alexandre.belloni@free-electrons.com> ---
>>  drivers/power/bq2415x_charger.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/power/bq2415x_charger.c
>> b/drivers/power/bq2415x_charger.c index 0727f92..0aa643e
>> 100644
>> --- a/drivers/power/bq2415x_charger.c
>> +++ b/drivers/power/bq2415x_charger.c
>> @@ -607,7 +607,7 @@ static int
>> bq2415x_set_battery_regulation_voltage(struct bq2415x_device
>> *bq,
>>
>>      if (val < 0)
>>          val = 0;
>> -    else if (val > 94) /* FIXME: Max is 94 or 122 ? Set max
>> value ? */ +    else if (val > 47)
>>          return -EINVAL;
>>
>>      return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE, val,
>
> Right, max is 47 (101111) and not 94 (1011110). But if you set
> all six registers to 1 then you get 63 (111111) and not 122.
>
> I do not know from where I got above bad values, but you should
> add comment to code that according to datasheet max value is
> 4440mV (101111) and not 4760mV (111111).
>
You probably missed the division by 2. BTW, I much prefer int val = (mV
- 3500) / 20;
which is clearer: offset is 3500mV and step is 20mV. I find your
calculation quite weird ;)

I'll send V2 with a comment then. Thank you for your review.

- -- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJSXVcWAAoJEKbNnwlvZCyzfiUQAKkLAbJlnQpNx+CG+tIzb36Q
3/hRTHMb+/Mrr0Db90OPqmJoItVH5WRsf/sRo+6990C95/PNdraM2a/Tibkz+3iD
rww0I01a73w3LBW5tWyN8kj/0iAQFX6h1fzv6dmeAvwZqTk/w7mfm5jv1fjcPYXI
UkTlPSBbH91YnTG9fqVjgpAYxVC64/eGJPMR6sfMnQ/zOWrX7ihGSEbEt8t4s4cX
ouwT5hHu2MmP5WY5IQKJ92+jx4nJsmtuI6HXEQwYPTnCUE8UbQHyezORTQB3cA7H
k0n1ha2SdwMqRkJGxr2T+NFTv1NCD5p72k34kWJPIeF7aFs51i8OiGUskPSBDK89
G9+8zxiD+8dK4B6RqXkq297AgRaNJm9+Ju30r2lrI/NhHocEWsWai+K0L2TF2Oag
4iEdwoQ9BHapcM4jVp2Ik5Oxg7I3909xR0rfWzCGvASPEZseXtgZWYsxZdGy/mZT
+hYaQYmOwV16FWxP+vSMWQPqW477E0q773j8ArnDx4gSta6+FTxfFeMYOFwF3leQ
FltSuDsKxVtip3Rzg77nbMdx6yTkWPvVgWH72grxSYaNYjQY2+pWhTXYOo2hZYzv
Ljr24qvYfzPiMpzMBFZDrm8SZ9LTKHsuKaLgLPTiHrJi+jS9aRK8avgYYNyyiVRP
60UKJwXam6LOq9/qW0eb
=n54z
-----END PGP SIGNATURE-----

