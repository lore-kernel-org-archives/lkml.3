Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3BEOlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:41:02 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58798 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab3BEOlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:41:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/2] tty: metag_da: fix flipping after tty changes
Date: Tue, 5 Feb 2013 14:40:48 +0000
Message-ID: <1360075250-21970-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_05_14_40_59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fixes up tty/metag_da after Jiri's changes, "TTY: switch
tty_flip_buffer_push" and "TTY: convert more flipping functions",
switched tty_flip_buffer_push() and tty_prepare_flip_string() to take
tty_port rather than a tty_struct.

The second just refactors slightly as a result of it.

How is this sort of thing usually handled? I suppose either I squash it
into the original driver and base it on tty-next, move it into tty-next,
or just fix it up afterwards?

James Hogan (2):
  tty: metag_da: update flip functions to use tty_port
  tty: metag_da: avoid getting tty kref in dashtty_timer()

 drivers/tty/metag_da.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

-- 
1.7.7.6


