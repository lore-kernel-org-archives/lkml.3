Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbaLEW4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:56:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaLEWz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:55:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.17 077/122] ARM: mvebu: add missing of_node_put() call in coherency.c
Date: Fri,  5 Dec 2014 14:44:11 -0800
Message-Id: <20141205223317.394832466@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit 2eb04ae010a8fb165ba7aa56e9aa8e7980887dee upstream.

There is a missing of_node_put() to decrement the device_node
reference counter after a of_find_matching_node() in coherency_init().

Fixes: 501f928e0097 ("ARM: mvebu: add a coherency_available() call")
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Link: https://lkml.kernel.org/r/1414423955-5933-4-git-send-email-thomas.petazzoni@free-electrons.com
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mvebu/coherency.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/mach-mvebu/coherency.c
+++ b/arch/arm/mach-mvebu/coherency.c
@@ -400,6 +400,8 @@ int __init coherency_init(void)
 		 type == COHERENCY_FABRIC_TYPE_ARMADA_380)
 		armada_375_380_coherency_init(np);
 
+	of_node_put(np);
+
 	return 0;
 }
 


