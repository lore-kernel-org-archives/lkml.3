Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaHFSRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:17:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:37492 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbaHFSRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:17:01 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="160023680"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net-next 0/2 v2] xen-netback: Changes around carrier handling
Date: Wed, 6 Aug 2014 19:16:09 +0100
Message-ID: <1407348973-2433-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series starts using carrier off as a way to purge packets when the guest is
not able (or willing) to receive them. It is a much faster way to get rid of
packets waiting for an overwhelmed guest.
The first patch changes current netback code where it relies currently on
netif_carrier_ok.
The second turns off the carrier if the guest times out on a queue, and only
turn it on again if that queue (or queues) resurrects.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org 
