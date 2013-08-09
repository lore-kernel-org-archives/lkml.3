Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030316Ab3HICBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:01:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030264Ab3HIB7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 096/102] net_sched: info leak in atm_tc_dump_class()
Date: Thu,  8 Aug 2013 18:58:12 -0700
Message-Id: <20130809015032.917025318@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8cb3b9c3642c0263d48f31d525bcee7170eedc20 ]

The "pvc" struct has a hole after pvc.sap_family which is not cleared.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_atm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -605,6 +605,7 @@ static int atm_tc_dump_class(struct Qdis
 		struct sockaddr_atmpvc pvc;
 		int state;
 
+		memset(&pvc, 0, sizeof(pvc));
 		pvc.sap_family = AF_ATMPVC;
 		pvc.sap_addr.itf = flow->vcc->dev ? flow->vcc->dev->number : -1;
 		pvc.sap_addr.vpi = flow->vcc->vpi;


