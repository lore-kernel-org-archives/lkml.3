Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3G2IAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:00:23 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:41146 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3G2IAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:00:21 -0400
MIME-Version: 1.0
In-Reply-To: <51F2A556.8020109@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
 <51F28370.6050304@gmail.com> <51F2996B.6000406@overkiz.com> <51F2A556.8020109@overkiz.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Mon, 29 Jul 2013 10:00:01 +0200
Message-ID: <CACQ1gAgw-v3z_sWcsk7SqFFW-ERLjS0RS5GTgAdd5Y1tj3Z1FA@mail.gmail.com>
Subject: Re: [PATCH v2 00/42] ARM: at91: move to common clk framework
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: multipart/mixed; boundary=bcaec5196b455027f504e2a1e295
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec5196b455027f504e2a1e295
Content-Type: text/plain; charset=UTF-8

2013/7/26 boris brezillon <b.brezillon@overkiz.com>:
> On 26/07/2013 17:44, boris brezillon wrote:
> I found 2 bugs:
> 1) the main frequency ready test in recalc_rate function is wrong
> 2) the common clk framework uses the first match for dt clk registration
>    and main clk has this compatible property:
>    compatible = "atmel,at91rm9200-clk-main", "fixed-clock";
>    As a result the main clk is always bound to the fixed-clock driver
>    which set the clock frequency to 0 if 'clock-frequency' property is
>    missing.
>
> These bugs will be fixed in next version.
> Tell me if you want need thesse patches for testing purpose.

Hi Boris,

I tested your patch, the clock is not at 0 anymore:
AT91: PIT: mck rate = 8333333

And it's booting correctly.
There's a small bug I found in the at91sam9x5 dtsi file (ssc id is 28,
not 27). (patch attached)

And yes, I could use your patches for some more tests !

Thanks,

Richard.

--bcaec5196b455027f504e2a1e295
Content-Type: application/octet-stream; 
	name="0001-ARM-at91-dt-at91sam9x5-fix-wrong-SSC-clock-ID.patch"
Content-Disposition: attachment; 
	filename="0001-ARM-at91-dt-at91sam9x5-fix-wrong-SSC-clock-ID.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hjpdx4t80

RnJvbSA3ZTc2OTNmMjg0YTYwNzU1MmM3MWY5NzZjMjhkNDA5OTI2ZDBiNzNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSaWNoYXJkIEdlbm91ZCA8cmljaGFyZC5nZW5vdWRAZ21haWwu
Y29tPgpEYXRlOiBNb24sIDI5IEp1bCAyMDEzIDA5OjQ3OjAyICswMjAwClN1YmplY3Q6IFtQQVRD
SF0gQVJNOiBhdDkxL2R0OiBhdDkxc2FtOXg1OiBmaXggd3JvbmcgU1NDIGNsb2NrIElECgpTU0Mg
cGVyaXBoZXJhbCBpZCBpcyAyOCwgbm90IDI3CgpTaWduZWQtb2ZmLWJ5OiBSaWNoYXJkIEdlbm91
ZCA8cmljaGFyZC5nZW5vdWRAZ21haWwuY29tPgotLS0KIGFyY2gvYXJtL2Jvb3QvZHRzL2F0OTFz
YW05eDUuZHRzaSB8ICAgIDQgKystLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybS9ib290L2R0cy9hdDkxc2FtOXg1
LmR0c2kgYi9hcmNoL2FybS9ib290L2R0cy9hdDkxc2FtOXg1LmR0c2kKaW5kZXggOGU3MDk4MC4u
ZDk3NjI2ZiAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vYm9vdC9kdHMvYXQ5MXNhbTl4NS5kdHNpCisr
KyBiL2FyY2gvYXJtL2Jvb3QvZHRzL2F0OTFzYW05eDUuZHRzaQpAQCAtMjg2LDggKzI4Niw4IEBA
CiAJCQkJCQlpZCA9IDwyNj47CiAJCQkJCX07CiAKLQkJCQkJc3NjX2Nsa0AyNyB7Ci0JCQkJCQlp
ZCA9IDwyNz47CisJCQkJCXNzY19jbGtAMjggeworCQkJCQkJaWQgPSA8Mjg+OwogCQkJCQl9Owog
CQkJCX07CiAJCQl9OwotLSAKMS43LjEwLjQKCg==
--bcaec5196b455027f504e2a1e295--
