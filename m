Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3LTIhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:37:15 -0500
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:56181 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751825Ab3LTIhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:37:13 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:967:968:973:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2196:2199:2393:2525:2538:2553:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3622:3653:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4605:4823:5007:6117:6119:6755:7652:7773:7809:7903:8599:8957:9025:9388:9855:10004:10848:10920:11026:11232:11473:11658:11914:12043:12219:12296:12517:12519:12555:12663:12740:13161:13229:13437,0,RBL:none,CacheIP:none,Bayesia
X-HE-Tag: women92_5bc6566dd112c
X-Filterd-Recvd-Size: 5405
Message-ID: <1387528630.2353.39.camel@joe-AO722>
Subject: Re: checkpatch.pl error might be false positive
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ravi Patel <rapatel@apm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Whitcroft <apw@canonical.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, Keyur Chudgar <kchudgar@apm.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 20 Dec 2013 00:37:10 -0800
In-Reply-To: <20131220075634.GA21784@leaf>
References: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
	 <1387491348.2353.20.camel@joe-AO722> <20131220075634.GA21784@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 23:56 -0800, Josh Triplett wrote:
> On Thu, Dec 19, 2013 at 02:15:48PM -0800, Joe Perches wrote:
> > On Thu, 2013-12-19 at 13:01 -0800, Ravi Patel wrote:
> > > My name is Ravi Patel and I am working for AppliedMicro.
> > > I am planning to submit APM X-Gene SoC QMTM drivers to open source after
> > > running checkpatch.pl
> > > I am seeing following error saying remove FSF address from my patch, which
> > > I don't have in my source/header files.
> > > 
> > > ERROR: Do not include the paragraph about writing to the Free Software
> > > Foundation's mailing address from the sample GPL notice. The FSF has
> > > changed addresses in the past, and may do so again. Linux already includes
> > > a copy of the GPL.
> > > #1580: FILE: include/misc/xgene/xgene_qmtm.h:19:
> > > + * You should have received a copy of the GNU General Public License$
> > > 
> > > Here is my License banner in xgene_qmtm.h
> > > There are no tabs in my banner
> > > 
> > > /*
> > >  * AppliedMicro X-Gene SOC Queue Manager/Traffic Manager driver
> > >  *
> > >  * Copyright (c) 2013 Applied Micro Circuits Corporation.
> > >  * Author: Ravi Patel <rapatel@apm.com>
> > >  *         Keyur Chudgar <kchudgar@apm.com>
> > >  *         Fushen Chen <fchen@apm.com>
> > >  *
> > >  * This program is free software; you can redistribute  it and/or modify it
> > >  * under  the terms of  the GNU General  Public License as published by the
> > >  * Free Software Foundation;  either version 2 of the  License, or (at your
> > >  * option) any later version.
> > >  *
> > >  * This program is distributed in the hope that it will be useful,
> > >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > >  * GNU General Public License for more details.
> > >  *
> > >  * You should have received a copy of the GNU General Public License
> > >  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > >  *
> > >  */
> > > 
> > > Can you please check if the error is false positive.
> > 
> > Josh?
> > 
> > Is the intent that the "copy of the GNU General Public License"
> > statement should also be removed?
> 
> While it does seem preferable to drop that paragraph, it isn't nearly as
> important as dropping the mailing address.  The match on "You should
> have received a copy" should probably be reduced to CHK level or
> dropped.

Maybe something like this, but maybe dropping the
"you should have received a copy" is ok too.

I did a few greps for various address patterns and
it seems using case insensitive matches and shorter
street types is better.

There are a few places where number and street name
are on different lines.  Oh well, nothing's perfect.
---
 scripts/checkpatch.pl | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 8f3aecd..b02d6ad 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1963,15 +1963,16 @@ sub process {
 		}
 
 # Check for FSF mailing addresses.
-		if ($rawline =~ /You should have received a copy/ ||
-		    $rawline =~ /write to the Free Software/ ||
-		    $rawline =~ /59 Temple Place/ ||
-		    $rawline =~ /51 Franklin Street/) {
+		if ($rawline =~ /\bYou should have received a copy/i ||
+		    $rawline =~ /\bwrite to the Free/i ||
+		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
+		    $rawline =~ /\b51\s+Franklin\s+St/i) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			my $msg_type = \&ERROR;
 			$msg_type = \&CHK if ($file);
+			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
 			&{$msg_type}("FSF_MAILING_ADDRESS",
-				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
+				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
 		}
 
 # check for Kconfig help text having a real description


