Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaDVTwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:52:19 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:50548 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755726AbaDVTwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:52:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArAWAOrHVlNXQyNO/2dsb2JhbABZgwaCXoEGp3qZYgICgRUXdIJmHCMYahgkE4gtAxUBxyANhgGMPoE0ZIQ/AQOOa4gXgW0BimuCFYVSgzM7gSw
Date: Tue, 22 Apr 2014 21:54:13 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/9p/v9fs.c: add __init to v9fs_sysfs_init
Message-Id: <20140422215413.2d093a1eccaeae3e44738ff9@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v9fs_sysfs_init is only called by __init init_v9fs

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/9p/v9fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 14da825..6894b08 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -537,7 +537,7 @@ static struct attribute_group v9fs_attr_group = {
  *
  */
 
-static int v9fs_sysfs_init(void)
+static int __init v9fs_sysfs_init(void)
 {
 	v9fs_kobj = kobject_create_and_add("9p", fs_kobj);
 	if (!v9fs_kobj)
-- 
1.8.4.5

