Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaCKTNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:13:45 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:53480 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbaCKTMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:12:52 -0400
From: Simon Guinot <simon.guinot@sequanux.org>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?R=C3=A9mi=20R=C3=A9rolle?= <remi.rerolle@seagate.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: [PATCH 0/2] md: fix fix deadlock while suspending RAID array
Date: Tue, 11 Mar 2014 20:12:08 +0100
Message-Id: <1394565130-24233-1-git-send-email-simon.guinot@sequanux.org>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes a deadlock which have been observed while
updating a RAID array level, using the mdadm --grow command. A full
description of the issue (hopefully understandable enough) is provided
by the commit message in the second patch.

Please, let me know if this patches are correct and/or if there is an
another way (maybe more handy) to solve this deadlock issue.

Thanks,

Simon

Simon Guinot (2):
  md: move up mddev locking functions
  md: fix deadlock while suspending RAID array

 drivers/md/md.c | 154 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 83 insertions(+), 71 deletions(-)

-- 
1.8.5.3

