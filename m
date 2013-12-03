Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3LCRmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 12:42:37 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60622 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3LCRmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 12:42:35 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 12:42:34 -0500
Message-ID: <CA+X2d=Ar93dXujLt8xNeh9tNmEX9HU+VgVSqWsdGtKLvk=Rdyg@mail.gmail.com>
Subject: [PATCH] drivers/input/mouse: add support for newer elantech touchpads
 (released ca. August 2013);
From: Matt Walker <matt.g.d.walker@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: backports@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=089e0102fb5c5378c104eca4d2b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e0102fb5c5378c104eca4d2b8
Content-Type: text/plain; charset=ISO-8859-1

From: Matt Walker <matt.g.d.walker@gmail.com>

Added detection for newer Elantech touchpads, so that kernel doesn't
fall-back to default PS/2 driver. Supports touchpads released after
~August 2013.  Fixes bug:
https://lists.launchpad.net/kernel-packages/msg18481.html

Tested-by: Matt Walker <matt.g.d.walker@gmail.com> on an Acer Aspire S7-392-6302

----

Thanks to Hauke for the reference on how to submit a patch properly.
Please let me know if additional modifications are required.

Diff Output:

--- linux-3.13-rc1/drivers/input/mouse/elantech.c.orig    2013-12-03
12:14:52.829173656 -0500
+++ linux-3.13-rc1/drivers/input/mouse/elantech.c    2013-12-03
12:15:11.833173880 -0500
@@ -1313,6 +1313,7 @@ static int elantech_set_properties(struc
             break;
         case 6:
         case 7:
+        case 8:
             etd->hw_version = 4;
             break;
         default:


On Fri, Nov 29, 2013 at 4:26 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 11/29/2013 01:00 AM, Matt Walker wrote:
>> Hello,
>>
>> Attached is a patch for drivers/input/mouse/elantech.c.  It allows
>> recent Elantech touchpads to be detected.  I have tested it on the
>> touchpad that comes with the Acer Aspire S7-392 (released ~August
>> 2013)
>>
>> I figure it could be backported with little effort and no danger,
>> since all it does it add one to the number of values that were
>> previously recognized as valid "firmware version numbers".
>>
>> Begin Patch:
>> 1315a1316
>>>         case 8:
>> End Patch
>>
>> Best,
>> Matt
>>
> This is not a patch, I do not know what you want to do.
>
> This is the documentation for hacking on backprts:
> https://backports.wiki.kernel.org/index.php/Documentation/backports/hacking
>
> This is the guideline for patch submission to the linux kernel which
> mostly also applies for backports:
> https://www.kernel.org/doc/Documentation/SubmittingPatches
>
> Hauke

--089e0102fb5c5378c104eca4d2b8
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_horexehc0

LS0tIGxpbnV4LTMuMTMtcmMxL2RyaXZlcnMvaW5wdXQvbW91c2UvZWxhbnRlY2guYy5vcmlnCTIw
MTMtMTItMDMgMTI6MTQ6NTIuODI5MTczNjU2IC0wNTAwCisrKyBsaW51eC0zLjEzLXJjMS9kcml2
ZXJzL2lucHV0L21vdXNlL2VsYW50ZWNoLmMJMjAxMy0xMi0wMyAxMjoxNToxMS44MzMxNzM4ODAg
LTA1MDAKQEAgLTEzMTMsNiArMTMxMyw3IEBAIHN0YXRpYyBpbnQgZWxhbnRlY2hfc2V0X3Byb3Bl
cnRpZXMoc3RydWMKIAkJCWJyZWFrOwogCQljYXNlIDY6CiAJCWNhc2UgNzoKKwkJY2FzZSA4Ogog
CQkJZXRkLT5od192ZXJzaW9uID0gNDsKIAkJCWJyZWFrOwogCQlkZWZhdWx0Ogo=
--089e0102fb5c5378c104eca4d2b8--
