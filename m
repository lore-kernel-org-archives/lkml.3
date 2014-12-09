Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaLISFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:05:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaLISFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:05:51 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Seth Jennings <sjenning@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Miroslav Benes <mbenes@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>, live-patching@vger.kernel.org,
        x86@kernel.org, kpatch@redhat.com, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 0/6] livepatch v5: more clean up for the v5 of the patchset
Date: Tue,  9 Dec 2014 19:05:01 +0100
Message-Id: <1418148307-21434-1-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is against v5 of the livepatch patch set, see
https://lkml.org/lkml/2014/12/4/488

It handles my comments against the 2nd patch from the patch set.
The only exception is the description of the relocation stuff.
It is better understood by Seth and Josh.

If you agree with the changes, please merge them into the original
patchset.

Petr Mladek (6):
  livepatch v5: avoid race when checking for state of the patch
  livepatch v5: do not quietly ignore wrong usage
  livepatch v5: find and verify the old address in klp_*_init()
  livepatch v5: clean up ordering of functions
  livepatch v5: split init and free code that is done only for loaded
    modules
  livepatch v5: clean up usage of the old and new addresses

 include/linux/livepatch.h |  24 +--
 kernel/livepatch/core.c   | 403 +++++++++++++++++++++++++++-------------------
 2 files changed, 253 insertions(+), 174 deletions(-)

-- 
1.8.5.2

