Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbbAOPAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:00:09 -0500
Received: from frv189.fwdcdn.com ([212.42.77.189]:32270 "EHLO
	frv189.fwdcdn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbbAOPAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:00:05 -0500
Date: Thu, 15 Jan 2015 16:34:38 +0200
From: Sergey Popov <popov_sergey@ukr.net>
Subject: [patch 1/1] init/main.c: prevent increase of console_loglevel by
 'quiet' kernel parameter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Mailer: mail.ukr.net 5.0
Message-Id: <1421328867.519739764.uwqo04hs@frv35.fwdcdn.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-3Ufh09jy+LlY6yOzgYwH"
Content-Transfer-Encoding: binary
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-3Ufh09jy+LlY6yOzgYwH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: binary
Content-Disposition: inline
Content-Length: 1228

From: Sergey Popov <popov_sergey@ukr.net>

Prevent increase of console_loglevel by 'quiet'

'quiet' kernel option that follows the 'loglevel=N' should
not blindly overwrite console_loglevel, instead it should
respect and keep lower 'loglevel'.

Signed-off-by: Sergey Popov <popov_sergey@ukr.net>
---
 init/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Some drivers tend to print error messages (ex: 'drm/i810 does not support SMP') to the console 
that we at our company don't want to show to people. We use 'quiet' kernel option to hide kernel decompressing progress and other messages not related to printk. But to hide error messages from drivers we use 'loglevel=3' parameter as well. But when it's _before_ the quiet, then quiet overrides loglevel=3 and set it to be 4.
I think that's a bug, and here's simple solution for it. The only way to live without this patch is to pass 'loglevel=3' after the 'quiet'. This issue is known to the community, but everyone is using workaround (ex: https://wiki.archlinux.org/index.php/Silent_boot).
I had enough inspiration to dive into the linux code and fix it.

--
with best regards,
Sergey Popov

phone: +380687507707
skype: uazure
vk.com/uazure
fb.com/uazure
--=-3Ufh09jy+LlY6yOzgYwH
Content-Type: application/x-patch; name="sergey-popov-quiet-respects-loglevel.patch"
Content-Transfer-Encoding: base64
Content-Id: <6kjjmvu3eybly7kthmbn>
Content-Disposition: attachment

ZGlmZiAtLWdpdCBhL2luaXQvbWFpbi5jIGIvaW5pdC9tYWluLmMKaW5kZXggNjFiOTkzNzYuLjkx
ZmM3OGIgMTAwNjQ0Ci0tLSBhL2luaXQvbWFpbi5jCisrKyBiL2luaXQvbWFpbi5jCkBAIC0yMTEs
NyArMjExLDEyIEBAIHN0YXRpYyBpbnQgX19pbml0IGRlYnVnX2tlcm5lbChjaGFyICpzdHIpCiAK
IHN0YXRpYyBpbnQgX19pbml0IHF1aWV0X2tlcm5lbChjaGFyICpzdHIpCiB7Ci0JY29uc29sZV9s
b2dsZXZlbCA9IENPTlNPTEVfTE9HTEVWRUxfUVVJRVQ7CisJLyoKKwkgKiAncXVpZXQnIG9wdGlv
biBzaG91bGQgbm90IHJhaXNlIGNvbnNvbGVfbG9nbGV2ZWwsIGl0J3Mgb25seQorCSAqIGFsbG93
ZWQgdG8gbG93ZXIgaXQKKwkgKi8KKwlpZiAoY29uc29sZV9sb2dsZXZlbCA+IENPTlNPTEVfTE9H
TEVWRUxfUVVJRVQpCisJCWNvbnNvbGVfbG9nbGV2ZWwgPSBDT05TT0xFX0xPR0xFVkVMX1FVSUVU
OwogCXJldHVybiAwOwogfQogCg==

--=-3Ufh09jy+LlY6yOzgYwH--
