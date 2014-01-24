Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaAXFcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:08 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaAXFbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:41 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/5] Lustre fixes from my testing
Date: Thu, 23 Jan 2014 23:45:03 -0500
Message-Id: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just deployed a mainline lustre client in my test system.
These patches below are for stuff that causes crashes or other issues
in my (so far) very basic sanity testing (more to come).

The patches mostly originate from our main tree, but I decided to
prioritize these as they disrupt my testing, obviously.

Also adding myself as one of the people who others would hopefully
CC all lustre patches to.

Please consider.

Oleg Drokin (5):
  staging/lustre: fix compile warning with is_vmalloc_addr
  staging/lustre/lnet: Fix use after free in ksocknal_send
  lustre: Account for changelog_ext_rec in CR_MAXSIZE
  lustre: Correct KUC code max changelog msg size
  lustre: add myself to list of people to CC on lustre patches

 drivers/staging/lustre/TODO                                     | 5 +++--
 drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h | 2 ++
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c          | 2 +-
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c          | 5 +++--
 drivers/staging/lustre/lustre/include/lustre/lustre_user.h      | 3 ++-
 drivers/staging/lustre/lustre/mdc/mdc_request.c                 | 6 +++---
 6 files changed, 14 insertions(+), 9 deletions(-)

-- 
1.8.5.3

