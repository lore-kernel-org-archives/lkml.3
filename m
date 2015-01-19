Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbbASPrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:47:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:54703 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbbASPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:47:41 -0500
X-IronPort-AV: E=Sophos;i="5.09,427,1418083200"; 
   d="scan'208";a="219312185"
From: David Vrabel <david.vrabel@citrix.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-mm@kvack.org>
Subject: [PATCHv3 0/2] mm: infrastructure for correctly handling foreign pages on Xen
Date: Mon, 19 Jan 2015 15:47:21 +0000
Message-ID: <1421682443-20509-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are the common parts of a larger Xen series[1]
fixing several long-standing bugs the handling of foreign[2] pages in
Xen guests.

Andrew, these are best merged via the Xen tree.  Can I have an acked-by?

The first patch is required to fix get_user_pages[_fast]() with
userspace space mappings of such foreign pages.  Basically, pte_page()
doesn't work so an alternate mechanism is needed to get the page from
a VMA and address.  By requiring mappings needing this method are
'special' this should not have an impact on the common use cases.

The second patch isn't essential but helps with readability of the
resulting user of the page flag.

For further background reading see:

  http://xenbits.xen.org/people/dvrabel/grant-improvements-C.pdf

Changes in v3:

- find_page renamed to find_special_page.
- added documentation.

Changes in v2:

- Add a find_page VMA op instead of the pages field so: a) the size of
  struct vm_area_struct does not increase; and b) the common code need
  not handling splitting the pages area.

David

[1] http://lists.xen.org/archives/html/xen-devel/2015-01/msg00979.html

[2] Another guest's page temporarily granted to this guest.
