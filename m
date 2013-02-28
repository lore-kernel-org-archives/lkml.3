Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3B1K3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:29:36 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:31720 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab3B1K3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:29:35 -0500
X-IronPort-AV: E=Sophos;i="4.84,754,1355097600"; 
   d="scan'208";a="2012274"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xen.org>
Subject: [PATCH RFC 00/12] xen-block: indirect descriptors
Date: Thu, 28 Feb 2013 11:28:43 +0100
Message-ID: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains the initial implementation of indirect 
descriptors for Linux blkback/blkfront.

Patches 1, 2, 3, 4 and 5 are bug fixes and minor optimizations.

Patch 6 contains a LRU implementation for blkback that will be needed 
when using indirect descriptors (since we are no longer able to map 
all possible grants blkfront might use).

Patch 7 is an addition to the print stats function in blkback in order 
to print information regarding persistent grant usage.

Patches 8, 9, 10 and 11 are preparatory work for indirect descriptors 
implementation, mainly make blkback use dynamic memory and remove the 
shared blkbk structure, so each blkback instance has it's own list of 
free requests, pages, handles and so on.

Finally patch 12 contains the indirect descriptors implementation.

I've also pushed this series to the following git repository:

git://xenbits.xen.org/people/royger/linux.git xen-block-indirect

Performance benefit of this series can be seen in the following graph:

http://xenbits.xen.org/people/royger/plot_indirect.png

Thanks for the review, Roger.

