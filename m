Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKLN2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:28:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:63161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbaKLN2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:28:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="415387022"
Date: Wed, 12 Nov 2014 21:28:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: usb: gadget: midi: f_midi_alloc() can be static
Message-ID: <20141112132824.GA27653@wfg-t540p.sh.intel.com>
References: <201411121904.vA8htDl2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201411121904.vA8htDl2%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/usb/gadget/function/f_midi.c:1072:21: sparse: symbol 'f_midi_alloc' was not declared. Should it be static?
drivers/usb/gadget/legacy/gmidi.c:118:30: sparse: symbol 'fi_midi' was not declared. Should it be static?
drivers/usb/gadget/legacy/gmidi.c:119:21: sparse: symbol 'f_midi' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 function/f_midi.c |    2 +-
 legacy/gmidi.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/usb/gadget/function/f_midi.c
===================================================================
--- linux.orig/drivers/usb/gadget/function/f_midi.c
+++ linux/drivers/usb/gadget/function/f_midi.c
@@ -1069,7 +1069,7 @@ static void f_midi_unbind(struct usb_con
 	usb_free_all_descriptors(f);
 }
 
-struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
+static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 {
 	struct f_midi *midi;
 	struct f_midi_opts *opts;
Index: linux/drivers/usb/gadget/legacy/gmidi.c
===================================================================
--- linux.orig/drivers/usb/gadget/legacy/gmidi.c
+++ linux/drivers/usb/gadget/legacy/gmidi.c
@@ -115,8 +115,8 @@ static struct usb_gadget_strings *dev_st
 	NULL,
 };
 
-struct usb_function_instance *fi_midi;
-struct usb_function *f_midi;
+static struct usb_function_instance *fi_midi;
+static struct usb_function *f_midi;
 
 static int __exit midi_unbind(struct usb_composite_dev *dev)
 {
