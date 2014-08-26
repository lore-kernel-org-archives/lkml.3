Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbaHZIkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:40:10 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:63014 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933892AbaHZIkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:40:06 -0400
MIME-Version: 1.0
Date: Tue, 26 Aug 2014 11:40:04 +0300
Message-ID: <CAGhpvopFxfu0hNjtAiUnQ0+trL45c5MexiWSx3v9GDNuQqzoxQ@mail.gmail.com>
Subject: [PATCH] i2c documentation: rename variable "register" to "reg"
From: =?UTF-8?B?Sm9zw6kgTWFudWVsIEFsYXJjw7NuIFJvbGTDoW4=?= 
	<jose.alarcon.roldan@gmail.com>
To: rdunlap@infradead.org, wsa@the-dreams.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The example code provided with the i2c device interface documentation
won't compile since it uses the reserved word "register" to name a
variable.

The compiler fails with this error message:

 error: expected identifier or '(' before '=' token
   __u8 register = 0x20; /* Device register to access */
                 ^

Rename the variable "register" to simply "reg"
in the example code.

Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>
---
 Documentation/i2c/dev-interface | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/i2c/dev-interface b/Documentation/i2c/dev-interface
index 3e742ba..f8b1e50 100644
--- a/Documentation/i2c/dev-interface
+++ b/Documentation/i2c/dev-interface
@@ -57,12 +57,12 @@ Well, you are all set up now. You can now use
SMBus commands or plain
 I2C to communicate with your device. SMBus commands are preferred if
 the device supports them. Both are illustrated below.

-  __u8 register = 0x10; /* Device register to access */
+  __u8 reg = 0x10; /* Device register to access */
   __s32 res;
   char buf[10];

   /* Using SMBus commands */
-  res = i2c_smbus_read_word_data(file, register);
+  res = i2c_smbus_read_word_data(file, reg);
   if (res < 0) {
     /* ERROR HANDLING: i2c transaction failed */
   } else {
@@ -70,8 +70,8 @@ the device supports them. Both are illustrated below.
   }

   /* Using I2C Write, equivalent of
-     i2c_smbus_write_word_data(file, register, 0x6543) */
-  buf[0] = register;
+     i2c_smbus_write_word_data(file, reg, 0x6543) */
+  buf[0] = reg;
   buf[1] = 0x43;
   buf[2] = 0x65;
   if (write(file, buf, 3) ! =3) {
-- 
1.9.1
