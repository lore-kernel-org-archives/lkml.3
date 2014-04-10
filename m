Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935109AbaDJJn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:43:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934936AbaDJJny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:43:54 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/5] printk: Check for too long messages
Date: Thu, 10 Apr 2014 11:43:11 +0200
Message-Id: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for free space in the log buffer always passes when "first_seq"
and "next_seq" are equal. In theory, it might cause writing outside of
the log buffer.

Fortunately, the current usage looks safe because the used "text" and "dict"
buffers are quite limited. See the second patch for more details.

Anyway, it is better to be on the safe side and add a check. An easy
solution is done in the 2nd patch and it is improved in the 4th patch.

5th patch fixes the computation of the printed message length.

1st and 3rd patches just do some code refactoring to make the other patches
easier.

The patches can be applied against both linux.git and linux-next.git.

Just a heads up. These patches were created when working safe printk
in NMI context. I have resolved most problems, including my sickness,
and should be able to send the NMI stuff soon.

Petr Mladek (5):
  printk: Split code for making free space in the log buffer
  printk: Ignore too long messages
  printk: Split message size computation
  printk: Shrink too long messages
  printk: Return really stored message length

 kernel/printk/printk.c | 144 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 113 insertions(+), 31 deletions(-)

-- 
1.8.4

