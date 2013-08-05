Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab3HENqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:46:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3HENqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:46:42 -0400
Date: Mon, 5 Aug 2013 15:41:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Evgeniy Polyakov <zbr@ioremap.net>,
        Kees Cook <keescook@chromium.org>, Zach Levis <zml@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] exec: cleanup search_binary_handler()
Message-ID: <20130805134113.GA15603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To remind, by discussion with Zach

	fs-binfmts-add-a-name-field-to-the-binfmt-struct.patch
	fs-binfmts-better-handling-of-binfmt-loops.patch
	fs-binfmts-whitespace-fixes-with-scripts-cleanfile.patch

should be dropped. Zach is working on the new version on top of these
changes.

Changes:

	2/8: add the comment about recursion_depth

	4/8: nullify bprm->file to catch the potential use after free

	Add the acks from Kees (thanks!)

Oleg.

 fs/exec.c               |  120 +++++++++++++++++++++++------------------------
 include/linux/binfmts.h |    2 +-
 2 files changed, 60 insertions(+), 62 deletions(-)

