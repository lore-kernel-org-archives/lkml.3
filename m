Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947351Ab3BHX3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:29:02 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51129
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760373Ab3BHX3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:29:01 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: balloon 
Date: Fri,  8 Feb 2013 15:56:45 -0800
Message-Id: <1360367805-3451-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make furher adjustments to memory pressure reporting and computation.
In the current code, we begin to report pressure soon after the balloon driver
loads and typically report a very low pressure until the system is fully
operational. To avoid having the host take memory balancing decisions on
data that does not fully reflect the memory pressure, delay reporting the
pressure. Additionally, implement a floor for ballooning based on the amount
of memory being managed.

K. Y. Srinivasan (2):
  Drivers: hv: balloon: Add a parameter to delay pressure reporting
  Drivers: hv: balloon: Prevent the host from ballooning the guest too
    low

 drivers/hv/hv_balloon.c |   48 ++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 45 insertions(+), 3 deletions(-)

-- 
1.7.4.1

