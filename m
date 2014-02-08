Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaBHTGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 14:06:23 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58291 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002AbaBHTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 14:06:22 -0500
Message-ID: <1391886379.2669.11.camel@x41>
Subject: agp/intel: can't ioremap flush page - no chipset flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Date: Sat, 08 Feb 2014 20:06:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2014 19:06:20.0964 (UTC) FILETIME=[DA4B7640:01CF2500]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) Booting v3.14-rc1 on an (outdated) ThinkPad X41 triggers a kernel
error:
    pci 0000:00:02.0: can't ioremap flush page - no chipset flushing

That is this pci device:
     lspci | grep 00:02.0
     00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML Express Graphics Controller (rev 03)

I can't remember seeing that error before. It is apparently printed by
drivers/char/agp/intel-gtt.c. (So I've sent this message to the people
touching that file between v3.13 and v3.14-rc1. No, I haven't yet
pinpointed a specific commit.)

1) What am I supposed to do to make this error go away?


Paul Bolle

