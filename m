Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaAFKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:09:29 -0500
Received: from multi.imgtec.com ([194.200.65.239]:17454 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaAFKJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:09:27 -0500
Message-ID: <52CA807E.8020100@imgtec.com>
Date: Mon, 6 Jan 2014 10:07:58 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Rajendra Nayak <rnayak@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] clk: clk-divider: fix divisor > 255 bug
References: <1387190498-15392-1-git-send-email-james.hogan@imgtec.com> <20140103041556.12054.53966@quantum>
In-Reply-To: <20140103041556.12054.53966@quantum>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="IWaxH7LjxeLGFjsobjI8aXe64b0Twrke8"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_06_10_09_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IWaxH7LjxeLGFjsobjI8aXe64b0Twrke8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/01/14 04:15, Mike Turquette wrote:
> Quoting James Hogan (2013-12-16 02:41:38)
>> Commit 6d9252bd9a4bb (clk: Add support for power of two type dividers)=

>> merged in v3.6 added the _get_val function to convert a divisor value =
to
>> a register field value depending on the flags. However it used the typ=
e
>> u8 for the div field, causing divisors larger than 255 to be masked
>> and the resultant clock rate to be too high.
>>
>> E.g. in my case an 11bit divider was supposed to divide 24.576 MHz dow=
n
>> to 32.768KHz. The divisor was correctly calculated as 750 (0x2ee). Thi=
s
>> was masked to 238 (0xee) resulting in a frequency of 103.26KHz.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>=20
> Taken into clk-next. Thanks for the fix!

Thanks Mike, is there any chance of getting this into v3.13, or is it
too late?

Cheers
James

>> Cc: Rajendra Nayak <rnayak@ti.com>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: stable@vger.kernel.org
>> ---
>> Since this bug was introduced in 3.6, it probably should by applied to=

>> stable 3.10 and 3.12.
>> ---
>>  drivers/clk/clk-divider.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> index 8d3009e44fba..5543b7df8e16 100644
>> --- a/drivers/clk/clk-divider.c
>> +++ b/drivers/clk/clk-divider.c
>> @@ -87,7 +87,7 @@ static unsigned int _get_table_val(const struct clk_=
div_table *table,
>>         return 0;
>>  }
>> =20
>> -static unsigned int _get_val(struct clk_divider *divider, u8 div)
>> +static unsigned int _get_val(struct clk_divider *divider, unsigned in=
t div)
>>  {
>>         if (divider->flags & CLK_DIVIDER_ONE_BASED)
>>                 return div;
>> --=20
>> 1.8.1.2
>>
>>


--IWaxH7LjxeLGFjsobjI8aXe64b0Twrke8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSyoCFAAoJEKHZs+irPybfQNcP/jaS7YaAEP8DlVSPkC6Hpfiz
LYuqK0BkLD8EP+zvuZj2/QZGxT1ZNn5Zoye63O22HpoFzd766IJ16wa3S+TEKxDd
Oc09m55Les/YgMVnEscGmsV/o1o9SqGKOt/WxIfT8DnINidfHG/bIfByNJUvgGbN
bg8qGhKHtIbB4QdmU9SoFxQjWwPg1fmTOvFe4zzoVEX1gQbUPm5f1smj4xBtEajn
H2AtGMWbBOfDtMrqtvnDL0dZaVqZoQWCnGwDdmptLK85cPY08Cdqzfd4qaJO/nLl
cFVbepQY+mbOzGW9AouBVuyv/q343REhIqdgRBProbm1IYOvduVOYqB5nq0u7vul
5rydJoOeywp5+CXc/rcO7uudV9d95yXnRpTfFskNVrzhoyn1ytwqyKkr50CwBhxY
n9GEEU2sK83v1Efn/Lln4KuXyQEF62B9gSs4l+przmmfyaMPidMH/lezXmuts05K
U2LseNK+hG+RWtoSye3Xjj0hJXr7g7OjFjNJP9ZJ4NSgRqjkaLRrm1pCyCsnvGm/
HK3vpU7yhWDVFnTVKJgismkVoz2SqXJIFe5o5Edm8JJPb70Fh9nN3Bc1FDhPf88e
/TsidS6h31nvVcRXhI9K1lE+4dusxjK33igv/JOu49HjpfUjbs6WcvKdv1o59VVd
TPDWHtcS0N96+ESzUmYg
=d4sj
-----END PGP SIGNATURE-----

--IWaxH7LjxeLGFjsobjI8aXe64b0Twrke8--

