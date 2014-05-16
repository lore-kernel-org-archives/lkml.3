Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaEPPW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:22:58 -0400
Received: from lnfm1.sai.msu.ru ([93.180.26.255]:47640 "EHLO lnfm1.sai.msu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932612AbaEPPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:22:56 -0400
X-Greylist: delayed 3818 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 11:22:55 EDT
Date: Fri, 16 May 2014 18:19:05 +0400 (MSK)
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
To: balbi@ti.com
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix dependency loop in tusb6010
Message-ID: <alpine.LRH.2.00.1405161812090.23182@lnfm1.sai.msu.ru>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Subject: [PATCH 0/2] Fix dependency loop in tusb6010

With the following configure options, musb_hdrc and tusb6010 make dependency loop:

CONFIG_USB_MUSB_HDRC=m
CONFIG_USB_MUSB_TUSB6010=m
CONFIG_USB_TUSB_OMAP_DMA=y

tusb6010.ko provides function `tusb_get_revision` which is used by tusb6010_omap.o which is a part of musb_hdrc.ko

In its turn, tusb6010.ko uses much of functions provided by musb_hdrc.ko

The following patches are to solve the issue.

Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
