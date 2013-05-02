Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3EBXwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:52:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56848 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3EBXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:52:14 -0400
X-AuditID: 9c930179-b7c28ae0000018a0-71-5182fc2b3f67
Subject: Re : [PATCH, RFC 09/22] crypto: lz4: don't build on ARM
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5M2TImUS4ktGM2EKbnWxsD422uJz6Tv3MkR0dN0Fbmb
 Bfe0GAX1aqnOcsJbhjHzoPdJhfywQ4yBXR5/ieSYqD6mpDtHxm
 X0yb8H2pZS10hEwKQEYbLvcWA1K9MrYN6vNuixAsdQoxHM1noB
 LWoLTraUL/yoEnECPiBExqOYVde6z6bdLN5QGZdWX1M2lOUN3L
 +HPOmKKcdB6CcQcE45ouF7jYRpM+/KsZK9S8dSpF4o/yub2jl3
 WYdRKqSy/zTyiTggGi6uiIbh9NblX28CeBOlCouSt2k8M9YsQV
 Xd+zlf9ilWJezB5UNhPY+4yzrs1IIeg60Mm9SC1zwtIWb/oxCG
 mvC7cwaz06zvrcI1WOzPOnttXxtF/f8fMeVdSGqAU
X-Brightmail-Tracker: AAAAAA==
Reply-To: "Chanho Min" <chanho.min@lge.com>
X-Priority: 3 (Normal)
From: "Chanho Min" <chanho.min@lge.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Message-ID: <OF54831661.2286D403-ON49257B5F.00831E7A-49257B5F.00831E7D@lge.com>
Date: Fri, 3 May 2013 08:52:10 +0900
X-MIMETrack: Serialize by Router on LGEKRHQMS17/LGE/LG Group(Release 6.5.5FP3HF116 | July
 11, 2008) at 2013/05/03 08:52:11
MIME-Version: 1.0
Content-type: multipart/mixed; 
	Boundary="0__=C6BBF1CCDF1098EA8f9e8a93df938690918cC6BBF1CCDF1098EA"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0__=C6BBF1CCDF1098EA8f9e8a93df938690918cC6BBF1CCDF1098EA
Content-type: text/plain; charset=US-ASCII


>It is not currently possible to build the LZ4 code on ARM, so let's
>remove that option in Kconfig for now.
>
>lib/built-in.o: In function `lz4_compress64kctx':
> lib/lz4/lz4_compress.c:339: undefined reference to `__ctzsi2'
>lib/built-in.o: In function `lz4_compressctx':
> lib/lz4/lz4_compress.c:157: undefined reference to `__ctzsi2'
>lib/built-in.o: In function `lz4hc_commonlength':
> lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
> lib/lz4/lz4hc_compress.c:102: undefined reference to `__ctzsi2'
>lib/built-in.o: In function `lz4hc_insertandgetwidermatch':
> lib/lz4/lz4hc_compress.c:230: undefined reference to `__ctzsi2'

Please, let me know the gcc version and tested defconfig.
I didn't have any problem to build with gcc 4.6.4 on armv7.
Some architecture need libgcc functions for __builtin_clz/ctz.
Porting them to lib is in progress:
http://marc.info/?l=linux-kernel&m=136748861811956&w=2
But, It doesn't happen on ARM, PowerPC and x86.

Thanks
Chanho Min
--0__=C6BBF1CCDF1098EA8f9e8a93df938690918cC6BBF1CCDF1098EA
Content-type: application/octet-stream; 
	name="mime.txt"
Content-Disposition: attachment; filename="mime.txt"
Content-transfer-encoding: base64

SXQgaXMgbm90IGN1cnJlbnRseSBwb3NzaWJsZSB0byBidWlsZCB0aGUgTFo0IGNvZGUgb24gQVJN
LCBzbyBsZXQncw0KcmVtb3ZlIHRoYXQgb3B0aW9uIGluIEtjb25maWcgZm9yIG5vdy4NCg0KbGli
L2J1aWx0LWluLm86IEluIGZ1bmN0aW9uIGBsejRfY29tcHJlc3M2NGtjdHgnOg0KIGxpYi9sejQv
bHo0X2NvbXByZXNzLmM6MzM5OiB1bmRlZmluZWQgcmVmZXJlbmNlIHRvIGBfX2N0enNpMicNCmxp
Yi9idWlsdC1pbi5vOiBJbiBmdW5jdGlvbiBgbHo0X2NvbXByZXNzY3R4JzoNCiBsaWIvbHo0L2x6
NF9jb21wcmVzcy5jOjE1NzogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgX19jdHpzaTInDQpsaWIv
YnVpbHQtaW4ubzogSW4gZnVuY3Rpb24gYGx6NGhjX2NvbW1vbmxlbmd0aCc6DQogbGliL2x6NC9s
ejRoY19jb21wcmVzcy5jOjEwMjogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgX19jdHpzaTInDQog
bGliL2x6NC9sejRoY19jb21wcmVzcy5jOjEwMjogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgX19j
dHpzaTInDQpsaWIvYnVpbHQtaW4ubzogSW4gZnVuY3Rpb24gYGx6NGhjX2luc2VydGFuZGdldHdp
ZGVybWF0Y2gnOg0KIGxpYi9sejQvbHo0aGNfY29tcHJlc3MuYzoyMzA6IHVuZGVmaW5lZCByZWZl
cmVuY2UgdG8gYF9fY3R6c2kyJw0KDQpDYzogQ2hhbmhvIE1pbiA8Y2hhbmhvLm1pbkBsZ2UuY29t
Pg0KQ2M6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmhlbmdsaS5jb20uYXU+DQpTaWduZWQt
b2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KLS0tDQogY3J5cHRvL0tjb25m
aWcgfCAyICsrDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZmIC0tZ2l0
IGEvY3J5cHRvL0tjb25maWcgYi9jcnlwdG8vS2NvbmZpZw0KaW5kZXggYWEzYTM0OS4uMWNkMTM0
YiAxMDA2NDQNCi0tLSBhL2NyeXB0by9LY29uZmlnDQorKysgYi9jcnlwdG8vS2NvbmZpZw0KQEAg
LTEzNjEsNiArMTM2MSw3IEBAIGNvbmZpZyBDUllQVE9fODQyDQogDQogY29uZmlnIENSWVBUT19M
WjQNCiAJdHJpc3RhdGUgIkxaNCBjb21wcmVzc2lvbiBhbGdvcml0aG0iDQorCWRlcGVuZHMgb24g
IUFSTQ0KIAlzZWxlY3QgQ1JZUFRPX0FMR0FQSQ0KIAlzZWxlY3QgTFo0X0NPTVBSRVNTDQogCXNl
bGVjdCBMWjRfREVDT01QUkVTUw0KQEAgLTEzNjksNiArMTM3MCw3IEBAIGNvbmZpZyBDUllQVE9f
TFo0DQogDQogY29uZmlnIENSWVBUT19MWjRIQw0KIAl0cmlzdGF0ZSAiTFo0SEMgY29tcHJlc3Np
b24gYWxnb3JpdGhtIg0KKwlkZXBlbmRzIG9uICFBUk0NCiAJc2VsZWN0IENSWVBUT19BTEdBUEkN
CiAJc2VsZWN0IExaNEhDX0NPTVBSRVNTDQogCXNlbGVjdCBMWjRfREVDT01QUkVTUw0KLS0gDQox
LjguMS4yDQoNCg==

--0__=C6BBF1CCDF1098EA8f9e8a93df938690918cC6BBF1CCDF1098EA--

