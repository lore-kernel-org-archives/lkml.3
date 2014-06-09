Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892AbaFIWVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:21:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56281 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaFIWVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:21:47 -0400
Message-ID: <53963364.4010104@ahsoftware.de>
Date: Tue, 10 Jun 2014 00:21:24 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: HID: hid-sensor-hub: fix sleeping function called from invalid context
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

while rebasing the dozens (currently around 60) of refused, ignored or 
similiar bugfixes and patches I need to use a Linux kernel, I've noticed 
that Jiri Kosinas patch here

https://lkml.org/lkml/2013/8/9/214

doesn't apply anymore.

Looking why, I've seen that a similiar patch from Srinivas Pandruvada 
named like the topic ended up in the kernel.

Looking at the differences, I wonder if not all spin_lock() calls in 
hid-sensor-hub.c should be changed into spin_lock_irqsave() like the 
patch from Jiri Kosina did.

Regards,

Alexander Holler

(sorry for the duplicate message, I've forgotten to add the 
wanna-be-reviewer-school named lkml to the recipients)
