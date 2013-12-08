Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3LHNrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 08:47:35 -0500
Received: from nm36-vm0.bullet.mail.bf1.yahoo.com ([72.30.238.136]:20050 "HELO
	nm36-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753522Ab3LHNrd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 08:47:33 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 08:47:33 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 463723.79272.bm@omp1022.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=G1+POU66UK0CGcR0RSyXoeXO8eYW9wS1GaEEnQdkzLOMIpFOveQeJi5ZrCGZLsm7iBIX8lWEBL7s0Mf2VxRY9tGtq8OB8RrncSCTuQnVq8p+roVb00qu/yn7c3/TFAvaHpI2rpDrretWbwxJA/nRw0IPoZwl+QOqnM2ablSoGpw=;
X-YMail-OSG: nyL1I.AVM1l.11JA19tcHCO8phseoqMHxP2ffmytK0R6YiV
 jXr_aKSb8tkrBcM47EaTQgAW6CGOUpU6xl_RdwggnZmZjLUzdhPgH7Zk3iXb
 iCNdoAlC2DeDVOanznbhxpBBJd2vw7j8_g0gu8vv852h_VrZXi7mzSJXxC7g
 0ZsnOwgfcT4rCel6AKUybJl4oQhm9O4MAjBgn0EGQuuVYoEey9O0rsUWrvpR
 Tp_C1Tl9JvQA8OIBhW8iajorTbopp7P4Xca6YmJ2itg9aODkegxjPZw2vdX8
 kaqJWkI7TCjQXFEsI9C6sn3YyOYWRkAS8ciuQDKGSjkcZeOSxtT0TFvnHE4W
 qUtmPCWcJMGRNNULC9_4Gqb0726Uvyb2Z5Wkcho356o2wBNAr0In9oUqc0BH
 SDG3ct.8vDU0p1JP5WSTLHSIYpIytVSuNRj8t1nHocc6EAWtYJfOwqxP9eey
 anAlV9hm5ZbfZnb1QrsMiavdVFbo3rNclMfYd87TkocofsRx_bzMUkeX7xky
 ITwyfHIlPa6yc.DYliqJXX9Rzfjg_qxXNppC7k0yzNdts8d3i3L7lncjkgn2
 mMOypetAoOIkt
X-Rocket-MIMEInfo: 002.001,SSBoYXZlIGEgRGVsbCBJbnNwaXJvbiBONzAxMCBMYXB0b3Agd2l0aCBJbnRlbCBncmFwaGljcy4gV2hlbiB0aGUgZGVsbC1sYXB0b3AgbW9kdWxlIGlzIGxvYWRlZCwKdHdvIGJhY2tsaWdodCBkZXZpY2UgZGV2aWNlcyBhcmUgY3JlYXRlZDsgZGVsbF9iYWNrbGlnaHQsIGFuZCBpbnRlbF9iYWNrbGlnaHQgZnJvbSB0aGUgSW50ZWwKZ3JhcGhpY3MgZHJpdmVyLiBUaGUgZGVsbF9iYWNrbGlnaHQgZGV2aWNlIGlzIG5vbi1mdW5jdGlvbmFsLCBidXQgdGhlIGdyYXBoaWNzIHN1YnN5c3RlbSB1c2VzCml0IGluc3QBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.169.609
Message-ID: <1386510031.81267.YahooMailNeo@web160401.mail.bf1.yahoo.com>
Date: Sun, 8 Dec 2013 05:40:31 -0800 (PST)
From: Alex Davis <alex14641@yahoo.com>
Reply-To: Alex Davis <alex14641@yahoo.com>
Subject: [PATCH] dell-laptop: add parameter to disable the backlight device.
To: "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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
screen brightness cannot be controlled. I've added a module parameter, disable_backlight
which, when true, will disable the dell_backlight device, and leave only the intel_backlight:
with this, screen brightness can be controlled.

This patch is against 3.10.

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
