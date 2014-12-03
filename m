Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaLCF7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 00:59:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41885 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLCF7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 00:59:17 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: stefan@agner.ch, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [RESEND PATCHv2] Add SNVS clock support to rtc-snvs driver
Date: Wed,  3 Dec 2014 11:28:54 +0530
Message-Id: <cover.1417585458.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For v2:
As such this patch remains the same, but is being resend
and in isolation after the previous discussions here.
https://lkml.org/lkml/2014/11/7/295

Since the changes on rtc-snvs.c will need to go through
the rtc subsystem tree and the DT changes cannot be applied
by Shawn, till this driver patch gets mainlined, this driver
patch I am sending by itself without the DT changes send
earlier.

The first version of the patches were send quiet a 
while back. 
https://lkml.org/lkml/2014/9/26/492

The reason for sending this v2 of the patches late was to
prevent any changes midway to the VF dts patches being tried
with the below commit.
https://lkml.org/lkml/2014/10/22/605

Changes since v1:
The clock enable and disable functions for the SNVS are
now optional and only enable/disable it, if it has been
defined in the device tree node. Instead of failing and 
returning error as in the earlier set of patches, this
makes sure that the driver does not break for the other
i.MX devices for which the clock has not been defined and
enabled elsewhere.

Sanchayan Maity (1):
  drivers/rtc/rtc-snvs: Add clock support

 drivers/rtc/rtc-snvs.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

-- 
1.7.9.5

