Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3GNQ7b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 12:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab3GNQ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 12:59:30 -0400
Date: Sun, 14 Jul 2013 18:54:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Colin Cross <ccross@android.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] simple mmap() cleanups
Message-ID: <20130714165432.GA20828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hopefully the simple cleanups, but need the authoritative acks.

I simply can't understand the VM_GROWS* check in mmap_region(),
did I miss something subtle? I will appreciate any review.

Can't resist. "(prot&PROT_WRITE) && !(file->f_mode&FMODE_WRITE)"
asks for the whitespace cleanup, but this will break the 80-col
rule. Perhaps we should relax it...

Oleg.

 mm/mmap.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

