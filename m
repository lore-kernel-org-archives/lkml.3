Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab3GHNFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:05:12 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:44823 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3GHNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:05:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,1020,1363132800"; 
   d="scan'208";a="6453380"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC 0/4] xen-block: prevent blkfront for hoarding grants
Date: Mon, 8 Jul 2013 15:03:23 +0200
Message-ID: <1373288607-1876-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches prevent blkfront from hoarding all grants in the 
system by allowing blkfront to request blkback to unmap certain grants 
so they can be freed by blkfront. This is done periodically by 
blkfront, unmapping a certain amount of unused persistent grants.

This series also includes a bug fix for the grant table free callback 
implementation.

According to my tests, this series don't introduce any performance 
regressions, results can be seen at:

http://xenbits.xen.org/people/royger/persistent_unmap/
