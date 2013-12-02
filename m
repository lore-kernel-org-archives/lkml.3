Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab3LBBtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:49:32 -0500
Received: from nm18-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.138]:33562 "HELO
	nm18-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752449Ab3LBBta convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:49:30 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Dec 2013 20:49:30 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 992885.11252.bm@omp1057.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=tJiB43OVm3dqxiY8ghpG/piycJBahqE+37hLKEOALSAS9J3LKPydOFCuYVcYOT4PwI/PasC062gxsJRkG3H0zrmLPcudVfRkv2nwGX/LhEftDri67D1zavHnriXwLQ7poSaXlfJoVWhlQdDF/GBMmQ3evqB3c6391li2dCoUbOk=;
X-YMail-OSG: Pu3_AeMVM1lZhF5fYVbetYsRZT0OJG3b.WVK0Jlox6_BwSh
 IGu084HCFFZWzcKGuY8FkhRd4CtDQ5EljN4pmvwfolfshRCDfQrShrEKJ_n5
 fdSTf9Pe1jtu57fMUDnOPvxYf_952fiM7QEae9NLZGVzf8fEpQaC4LrF.czp
 MzByzA1Ry9hV0Zg6aiI0uBV0pN0sg6Fv2zdSkSR6iM5H9kptubhOjb67ouIA
 XZ_rWxxEDaYPErfh42HsxizubbvV5uea2jSAls8o03D7s0pA.sRHSMuSWO4l
 Dc2j6wLcp5mai0UV0b_9an0BHCarhTB1QfevY2yRb2GIe0n0KcHVOzBPJveP
 UH9HyBrx8goaupk7M69nI06NEP86bh4jL32xby9RSNNUSjB.iD_fedLg076a
 kHTVS8S_AOdddjAkoZiBBUgrgvQY9pwLkka7e2HF9fHTiBcjT4pMVnP2uumu
 wmY0xkqNLGP7QnLJADZ48fkmoavFT1HTgjaJkFlxALiZPjrsfbybD88x6BdL
 jIXL7jPw25f2VQ9rv4YBDfuoZQGzaD_o2j.sqpvL5K48Gt80JeyXVhnd4HuU
 LynmiluiuuZ9b
X-Rocket-MIMEInfo: 002.001,SSBoYXZlIGEgRGVsbCBJbnNwaXJvbiBONzAxMCBMYXB0b3Agd2l0aCBJbnRlbCBncmFwaGljcy4gV2hlbiB0aGUgZGVsbC1sYXB0b3AgbW9kdWxlIGlzIGxvYWRlZCwKdHdvIGJhY2tsaWdodCBkZXZpY2UgZGV2aWNlcyBhcmUgY3JlYXRlZDsgZGVsbF9iYWNrbGlnaHQsIGFuZCBpbnRlbF9iYWNrbGlnaHQgZnJvbSB0aGUgSW50ZWwKZ3JhcGhpY3MgZHJpdmVyLiBUaGUgZGVsbF9iYWNrbGlnaHQgZGV2aWNlIGlzIG5vbi1mdW5jdGlvbmFsLCBidXQgdGhlIGdyYXBoaWNzIHN1YnN5c3RlbSB1c2VzCml0IGluc3QBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.167.602
Message-ID: <1385948627.51494.YahooMailNeo@web160404.mail.bf1.yahoo.com>
Date: Sun, 1 Dec 2013 17:43:47 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: [PATCH 1/1] dell_laptop: add disable_backlight module parameter
To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Dell Inspiron N7010 Laptop with Intel graphics. When the dell-laptop module is loaded,
two backlight device devices are created; dell_backlight, and intel_backlight from the Intel
graphics driver. The dell_backlight device is non-functional, but the graphics subsystem uses
it instead of the functioning intel_backlight device. The result is that, when running KDE,
screen dimming does not work. I've added a module parameter, disable_backlight, which when 
true will disable the dell_backlight device, and leave only the intel_backlight: with this,
screen dimming works.

Signed-off-by: Alex Davis <alex14641@yahoo.com>
--- dell-laptop.c.orig    2013-12-01 19:05:39.693149050 -0500
+++ dell-laptop.c    2013-12-01 17:29:27.613372482 -0500
@@ -35,6 +35,9 @@
 /* This structure will be modified by the firmware when we enter
  * system management mode, hence the volatiles */
 
+static bool disable_backlight;
+module_param(disable_backlight, bool, 0644);
+
 struct calling_interface_buffer {
     u16 class;
     u16 select;
@@ -561,6 +564,9 @@ static int __init dell_init(void)
 
     dell_laptop_dir = debugfs_create_dir("dell_laptop", NULL);
 
+    if (disable_backlight)
+        return 0;
+
 #ifdef CONFIG_ACPI
     /* In the event of an ACPI backlight being available, don't
      * register the platform controller.




I code, therefore I am 
