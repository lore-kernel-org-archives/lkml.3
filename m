Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaCCLMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:12:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334AbaCCLMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:12:35 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5 v2] Fanotify cleanups
Date: Mon,  3 Mar 2014 12:12:18 +0100
Message-Id: <1393845143-28007-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  when fixing use-after-free bug with fanotify introduced by my previous
cleanup patches (the fix is already merged by Linus), I have better understood
handling of permission events and found a couple of things that can be further
cleaned up.  This patch series uses the notify structure itself for processing
response to permission event (patch 2/5) thus saving some space and allocation,
converts access_mutex to spinlock (patch 3/5) which should be faster, and moves
code around copy_event_to_user() to make code more readable (patch 4/5, 5/5).

The patches pass LTP fanotify tests. Andrew, can you please take the patches?

Changes since v1:
- rebased on top of latest fanotify fixes which went to Linus (3.13-rc5)

								Honza
