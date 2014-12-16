Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaLPQSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:18:39 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:54893 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaLPQSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:18:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Jan Kara <jack@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3 resend] mm: close race between dirtying and truncation
Date: Tue, 16 Dec 2014 11:18:08 -0500
Message-Id: <1418746691-326-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

it looks like these 3 patches fell on the floor.  The first one is a
bug fix that closes a race condition between truncation and dirtying
from do_wp_page(), which can result in a dirty-accounting error.  #2
and #3 simplify the code in the area.  Please consider them for 3.19.

Thanks!

 include/linux/writeback.h |  1 -
 mm/memory.c               | 54 ++++++++++++++++++---------------------------
 mm/page-writeback.c       | 43 ++++++++++--------------------------
 3 files changed, 34 insertions(+), 64 deletions(-)

