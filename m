Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3CHMxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:53:51 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16330 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757097Ab3CHMxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:53:49 -0500
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [RFC PATCH 0/1] usb: f_rndis: Avoid to use ERROR macro if cdev can be null
Date: Fri, 8 Mar 2013 13:53:39 +0100
Message-ID: <1362747220-2204-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When going through our patches to be mainlined I stumbled on this one which
we have fixed in many different ways internally.

The problem is a NULL pointer dereference that can be triggered by disconnecting
the USB cable at a specific time.

Before submitting the final patch I would like to hear which solution you'd
prefer. As I see it there are four different ways to fix the problem:

1) Remove the ERROR() call completely.
2) Add an if-statement on cdev in rndis_response_complete() and use pr_err() or
   ERROR().
3) Globally update the ERROR() macro to handle the case where cdev is null.
4) Use the attached patch (RFC PATCH 1/1) where ERROR() is simply replaced with pr_err().

Thanks!

-Oskar

Truls Bengtsson (1):
  usb: f_rndis: Avoid to use ERROR macro if cdev can be null

 drivers/usb/gadget/f_rndis.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.8.6

