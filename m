Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbbAURGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:06:20 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:52629 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932085AbbAURGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:06:03 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:69:355:379:541:800:901:960:967:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2565:2682:2685:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3770:3865:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4605:5007:6119:6120:6261:6671:6672:7266:7901:7903:8599:8987:9025:9121:9388:9391:10004:10400:10848:10913:11026:11233:11256:11658:11914:12043:12262:12266:12438:12517:12519:12555:12679:12740:12783:13007:13008:13025:13255:13870:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: head00_8b95d04625a41
X-Filterd-Recvd-Size: 3681
Date: Wed, 21 Jan 2015 12:05:58 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Matt Fleming <matt@console-pimps.org>, stable@vger.kernel.org
Subject: [GIT PULL] scripts/recordmcount.pl: There is no -m32 gcc option on
 Super-H anymore
Message-ID: <20150121120558.2b4c6608@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

It's been reported that function tracing does not work on the sh architecture
because gcc 4.8 for superH does not support -m32, and the recordmcount.pl
script adds "-m32" when re-compiling the object files with the mcount
locations.

I was not able to reproduce this problem, as it seems that -m32 works fine
for my cross compiler gcc 4.6.3, but I have to assume that -m32 was
deprecated somewhere between 4.6 and 4.8. As it still seems to compile
fine without -m32, I have no reason not to add this patch, as having
-m32 seems to cause trouble for others.

Please pull the latest trace-sh-3.19 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-sh-3.19

Tag SHA1: 625455641691af5faff3cef679b840d5824eb96c
Head SHA1: 1caf6aaaa47471831d77c75f094d4e00ad1ec808


Michael Karcher (1):
      scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore

----
 scripts/recordmcount.pl | 1 -
 1 file changed, 1 deletion(-)
---------------------------
commit 1caf6aaaa47471831d77c75f094d4e00ad1ec808
Author: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Date:   Sun Jan 18 00:36:15 2015 +0100

    scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore
    
    Compiling SH with gcc-4.8 fails due to the -m32 option not being
    supported.
    
    From http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.16.7-ckt4-1&stamp=1421425783
    
          CC      init/main.o
        gcc-4.8: error: unrecognized command line option '-m32'
        ld: cannot find init/.tmp_mc_main.o: No such file or directory
        objcopy: 'init/.tmp_mx_main.o': No such file
        rm: cannot remove 'init/.tmp_mx_main.o': No such file or directory
        rm: cannot remove 'init/.tmp_mc_main.o': No such file or directory
    
    Link: http://lkml.kernel.org/r/1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de
    Link: http://lkml.kernel.org/r/54BCBDD4.10102@physik.fu-berlin.de
    
    Cc: stable@vger.kernel.org
    Cc: Matt Fleming <matt@console-pimps.org>
    Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 56ea99a12ab7..537c38ca2e1c 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -255,7 +255,6 @@ if ($arch eq "x86_64") {
     # force flags for this arch
     $ld .= " -m shlelf_linux";
     $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
     $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
