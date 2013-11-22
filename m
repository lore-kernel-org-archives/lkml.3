Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3KVTQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:16:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab3KVTQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:16:50 -0500
Date: Fri, 22 Nov 2013 20:18:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] more next_thread/while_each_thread changes
Message-ID: <20131122191803.GA16919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial, change the remaining next_thread (ab)users to use
while_each_thread().

The last user which should be changed is next_tid(), but we can't
do this now.

__exit_signal() and complete_signal() are fine, they actually need
next_thread() logic.

Oleg.

 fs/proc/array.c |    3 +--
 kernel/signal.c |    7 +++----
 kernel/sys.c    |    3 +--
 3 files changed, 5 insertions(+), 8 deletions(-)

