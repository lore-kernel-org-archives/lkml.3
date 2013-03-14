Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3CNUJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:09:04 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51271
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab3CNUJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:09:03 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 0/6] Drivers: hv 
Date: Thu, 14 Mar 2013 13:38:57 -0700
Message-Id: <1363293537-13389-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enhances the balloon driver functionality to add support
for memory "hot-add". Windows hosts use a combination of ballooning and
hot-add to dynamically balance the available memory across competing virtual
machines. With this, Linux guests can fully participate in the Windows
Dynamic Memory protocol.

Additionally, I have also fixed an issue in the Vmbus driver in the way
the offer rescind message is handled.

Only one of the patches being resent has been modified from the previous version
sent out a few days ago. This is the patch that adds hot-add functionality:
[PATCH RESEND 5/6] Drivers: hv: balloon: Implement hot-add functionality

In this version of this patch, the balloon driver can be deployed on Linux
instances that don't support MEMORY_HOTPLUG.

K. Y. Srinivasan (6):
  Drivers: hv: balloon: Do not request completion notification
  Drivers: hv: balloon: Execute balloon inflation in a separate context
  Drivers: hv: balloon: Execute hot-add code in a separate context
  Drivers: hv: balloon: Make the balloon driver not unloadable
  Drivers: hv: balloon: Implement hot-add functionality
  Drivers: hv: vmbus: Handle channel rescind message correctly

 drivers/hv/channel_mgmt.c |   11 +
 drivers/hv/hv_balloon.c   |  482 ++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 440 insertions(+), 53 deletions(-)

-- 
1.7.4.1

