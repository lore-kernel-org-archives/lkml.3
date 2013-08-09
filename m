Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3HIM0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 08:26:06 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.175]:53690 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab3HIM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 08:26:04 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-13.tower-39.messagelabs.com!1376051160!5691500!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 09 Aug 2013 14:26:01 +0200
Date: Fri, 9 Aug 2013 14:27:02 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Tim Bird <tim.bird@am.sony.com>
CC: Sam Ravnborg <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>,
        <johannes.thumshirn@men.de>
Subject: [PATCH] kconfig: Make diffconfig work with Python 3
Message-ID: <20130809122655.GA7108@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 09 Aug 2013 12:26:00.0699 (UTC) FILETIME=[9B81A4B0:01CE94FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust diffconfig to run cleanly on Python 3 (Tested with 3.3.2) and
Python 2 (2.7.5)

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 scripts/diffconfig |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/scripts/diffconfig b/scripts/diffconfig
index b91f3e3..dd0e75b 100755
--- a/scripts/diffconfig
+++ b/scripts/diffconfig
@@ -10,7 +10,7 @@
 import sys, os

 def usage():
-    print """Usage: diffconfig [-h] [-m] [<config1> <config2>]
+    print ("""Usage: diffconfig [-h] [-m] [<config1> <config2>]

 Diffconfig is a simple utility for comparing two .config files.
 Using standard diff to compare .config files often includes extraneous and
@@ -33,7 +33,7 @@ Example usage:
  EXT2_FS  y -> n
  LOG_BUF_SHIFT  14 -> 16
  PRINTK_TIME  n -> y
-"""
+""")
     sys.exit(0)

 # returns a dictionary of name/value pairs for config items in the file
@@ -54,23 +54,23 @@ def print_config(op, config, value, new_value):
     if merge_style:
         if new_value:
             if new_value=="n":
-                print "# CONFIG_%s is not set" % config
+                print("# CONFIG_%s is not set" % config)
             else:
-                print "CONFIG_%s=%s" % (config, new_value)
+                print("CONFIG_%s=%s" % (config, new_value))
     else:
         if op=="-":
-            print "-%s %s" % (config, value)
+            print("-%s %s" % (config, value))
         elif op=="+":
-            print "+%s %s" % (config, new_value)
+            print("+%s %s" % (config, new_value))
         else:
-            print " %s %s -> %s" % (config, value, new_value)
+            print(" %s %s -> %s" % (config, value, new_value))

 def main():
     global merge_style

     # parse command line args
     if ("-h" in sys.argv or "--help" in sys.argv):
-	usage()
+        usage()

     merge_style = 0
     if "-m" in sys.argv:
@@ -79,13 +79,13 @@ def main():

     argc = len(sys.argv)
     if not (argc==1 or argc == 3):
-        print "Error: incorrect number of arguments or unrecognized option"
+        print("Error: incorrect number of arguments or unrecognized option")
         usage()

     if argc == 1:
         # if no filenames given, assume .config and .config.old
         build_dir=""
-        if os.environ.has_key("KBUILD_OUTPUT"):
+        if 'KBUILD_OUTPUT' in os.environ:
             build_dir = os.environ["KBUILD_OUTPUT"]+"/"

         configa_filename = build_dir + ".config.old"
@@ -94,8 +94,8 @@ def main():
         configa_filename = sys.argv[1]
         configb_filename = sys.argv[2]

-    a = readconfig(file(configa_filename))
-    b = readconfig(file(configb_filename))
+    a = readconfig(open(configa_filename))
+    b = readconfig(open(configb_filename))

     # print items in a but not b (accumulate, sort and print)
     old = []
@@ -121,7 +121,7 @@ def main():

     # now print items in b but not in a
     # (items from b that were in a were removed above)
-    new = b.keys()
+    new = list(b.keys())
     new.sort()
     for config in new:
         print_config("+", config, None, b[config])
--
1.7.9.5

