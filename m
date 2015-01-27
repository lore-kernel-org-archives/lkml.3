Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbbA0CBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:01:38 -0500
Received: from ozlabs.org ([103.22.144.67]:58573 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224AbbA0CBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:01:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PULL] One more module fixe
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 27 Jan 2015 11:36:03 +1030
Message-ID: <87a915rq10.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d5db139ab3764640e0882a1746e7b9fdee33fd87:

  module: make module_refcount() a signed integer. (2015-01-22 11:15:54 +1030)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/fixes-for-linus

for you to fetch changes up to dc4515ea26d6c7fed3d978cd2bd36adc0d057bc5:

  scsi: always increment reference count (2015-01-23 14:42:16 +1030)

----------------------------------------------------------------
SCSI was using module_refcount() to figure out when the module was
unloading: this broke with new atomic refcounting.  The code is still
suspicious, but this solves the WARN_ON().

Thanks,
Rusty.

----------------------------------------------------------------
Rusty Russell (1):
      scsi: always increment reference count

 drivers/scsi/scsi.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

