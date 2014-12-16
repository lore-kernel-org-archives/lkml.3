Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaLPSA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:00:26 -0500
Received: from smtprelay0004.hostedemail.com ([216.40.44.4]:48569 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751494AbaLPSAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:00:23 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4362:4605:5007:6117:6261:7514:7903:9545:9592:10004:10400:10471:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12679:12740:13071:13095:13161:13229:13255:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: use45_7757805969a34
X-Filterd-Recvd-Size: 3289
Message-ID: <1418752818.14140.1.camel@perches.com>
Subject: Re: [PATCH 1/2] misc:ad525x_dpot: Fix missing blank after
 declaration coding style issue in ad525x_dpot.c
From: Joe Perches <joe@perches.com>
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, michael.hennerich@analog.com,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Dec 2014 10:00:18 -0800
In-Reply-To: <1418751336-7295-1-git-send-email-md.jamalmohiuddin@gmail.com>
References: <1418751336-7295-1-git-send-email-md.jamalmohiuddin@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-16 at 23:05 +0530, Mohammad Jamal wrote:
> This  is a patch to ad525x_dpot.c file that fixes up a missing blank line after declaration warning found by checkpatch.pl issue

Hello Mohammad.

Thanks for the patch.

Here are some small comments:

Please run your patches through scripts/checkpatch.pl
before sending them.

This submission has an overly long commit message line.
Please limit line lengths to ~70 characters.

The "This  is a patch to <foo> that fixes up " is not useful.
The "found by checkpatch.pl issue" is not particularly useful.

A simpler form might have used:

Subject: [PATCH] ad525x_dpot: Add a blank line after declaration

with a commit log of somthing like:

Use a more common kernel style.

Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>

> Signed-off-by: Mohammad Jamal<md.jamalmohiuddin@gmail.com>

Add a space between your name and the open angle bracket
in the email address too please.

Sometimes, it's good to do all the similar types of changes
at the same time instead of multiple patches for trivial
bits.

Using:

$ ./scripts/checkpatch.pl -f --strict --types=line_spacing,braces --fix-inplace drivers/misc/ad525x_dpot.c

produces this:

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index a43053d..ddfe38f 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -176,6 +176,7 @@ static s32 dpot_read_i2c(struct dpot_data *dpot, u8 reg)
 {
 	int value;
 	unsigned ctrl = 0;
+
 	switch (dpot->uid) {
 	case DPOT_UID(AD5246_ID):
 	case DPOT_UID(AD5247_ID):
@@ -427,7 +428,6 @@ static ssize_t sysfs_show_reg(struct device *dev,
 			test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask) ?
 			"enabled" : "disabled");
 
-
 	mutex_lock(&data->update_lock);
 	value = dpot_read(data, reg);
 	mutex_unlock(&data->update_lock);
@@ -763,7 +763,6 @@ int ad_dpot_remove(struct device *dev)
 }
 EXPORT_SYMBOL(ad_dpot_remove);
 
-
 MODULE_AUTHOR("Chris Verges <chrisv@cyberswitching.com>, "
 	      "Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("Digital potentiometer driver");

This could be submitted with some commit message like:

Subject: [PATCH] ad525x_dpot: Add & remove blank lines

Use a more common kernel style.

Signed-off-by: <you>

cheers, Joe


