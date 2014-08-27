Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317AbaH0SMW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:12:22 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39638 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbaH0SMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:12:20 -0400
MIME-Version: 1.0
Date: Wed, 27 Aug 2014 21:12:19 +0300
Message-ID: <CAGhpvooRXZTsWL58hFReD0b+2Wf-iRmW_b-uV+aihpRNVWj1WA@mail.gmail.com>
Subject: [PATCH v2] i2c documentation: rename variable "register" to "reg"
From: =?UTF-8?B?Sm9zw6kgTWFudWVsIEFsYXJjw7NuIFJvbGTDoW4=?= 
	<jose.alarcon.roldan@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: wsa@the-dreams.de, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
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

Another couple of typos has been fixed as well.


Signed-off-by: Jose Alarcon Roldan <jose.alarcon.roldan@gmail.com>
---
 Documentation/i2c/dev-interface | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/i2c/dev-interface b/Documentation/i2c/dev-interface
index 3e742ba..744ce70 100644
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
@@ -70,11 +70,11 @@ the device supports them. Both are illustrated below.
   }

   /* Using I2C Write, equivalent of
-     i2c_smbus_write_word_data(file, register, 0x6543) */
-  buf[0] = register;
+  i2c_smbus_write_word_data(file, reg, 0x6543) */
+  buf[0] = reg;
   buf[1] = 0x43;
   buf[2] = 0x65;
-  if (write(file, buf, 3) ! =3) {
+  if (write(file, buf, 3) != 3) {
     /* ERROR HANDLING: i2c transaction failed */
   }

-- 
1.9.1
