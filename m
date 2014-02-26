Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaBZOGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:06:35 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750813AbaBZOGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:06:34 -0500
Message-ID: <530DF4E7.1060900@nod.at>
Date: Wed, 26 Feb 2014 15:06:31 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm,renesas-tpu: Add dependency on HAS_IOMEM
References: <1391172318-17853-1-git-send-email-richard@nod.at> <20140226120800.GA28939@ulmo.nvidia.com>
In-Reply-To: <20140226120800.GA28939@ulmo.nvidia.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 26.02.2014 13:08, schrieb Thierry Reding:
> On Fri, Jan 31, 2014 at 01:45:18PM +0100, Richard Weinberger wrote:
>> On archs like S390 or um this driver cannot build nor work. Make it depend on HAS_IOMEM to bypass build failures.
>> 
>> drivers/built-in.o: In function `tpu_probe': drivers/pwm/pwm-renesas-tpu.c:421: undefined reference to `devm_ioremap_resource'
>> 
>> Signed-off-by: Richard Weinberger <richard@nod.at> --- drivers/pwm/Kconfig | 1 + 1 file changed, 1 insertion(+)
> 
> In the long run I think it might be better to add a dummy implementation for devm_ioremap_resource() in order to make it build properly even for architectures where it isn't
> implemented.

And what should devm_ioremap_resource() or in general ioremap() do on archs without
iomem?
BUG()? Returning a random error and hoping that the driver handles it correctly? :)

IMHO such a dummy implementation does not make much sense.

> For now this looks like the best option. Applied, thanks.

Thanks!

//richard
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTDfTnAAoJEPmeIjfg4Uaa0hsP/1lgoKuMLbfXEw8Z064st3lk
pOQoQQYiyk9nW5Uj/yjFAq9hly+jtL6YdY9+i2q9aQAaIOqTj0I0VbmMy+1nFrdF
x7ahD1Z4BAI0PSTj3P8LaYs6Jn+zaok2Zo7B6BlJIvLlNZqqvgQHcCVWHK5srdHu
sjd6JwpvBykWSmNUMBG2oAkWCTKLjisXTIL1OsIbcyTgBSS7/17dHfaFqhgZJBTI
L3aHRQYOTEdXJyCRZq4SUwNSBXUdP2AmaDJZ4HQ17nuXUTOTnAMgpVUgidgLasmF
GAmSDunoi/i7Pu6Vu+562cZhmuzO+uYFo87hDivjn7tTPIJ0OMh4pHeWWaMWVye/
o9GYI1Ew86Lbekd5Xxhf32hNnhz5RxZlNrnjdO1y2GNW5bt7A5ukF4jY0QEuHC+q
tgLsS45NIECkqA2hk7nvgRdds1ZaqueuY1dw8mb2jIbuAuR3XXSfjVzdfQiXKxzA
tXugXynMSP93mHEeOwzc1pRnFl6j1KgbNOMX9MuYwc5corUShab/Z1d+RVWNat7c
iTn6b/GxWpPeMQv3qXvIe77R2UnFv50M2KW4RXs2MRZdXCbIR2FLojGl0fTp1lNo
7mTnB/8SnJBbHz5+1tQv2exFfmalNhM78RighfONJcTnmXfvmA20aNo9Kn3IEU0t
m2V40kQySnkcb7+gRXrR
=34dU
-----END PGP SIGNATURE-----
