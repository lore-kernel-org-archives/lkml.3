Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3LBTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:25:43 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44362 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3LBTZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 0/8] n_tty cleanup + trace additions
Date: Mon,  2 Dec 2013 14:24:40 -0500
Message-Id: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This patchset is a v2 respin which contains no bug fixes, only
misc cleanup for the N_TTY line discipline and significant
additions to debug tracing.

As I mentioned in a previous email, I can hold on to patches 7 and 8
and keep them out-of-tree if you'd rather not have instrumented code
in the tty layer.

v2:
- Patches 1-6 are unchanged from v1.
- Patch 7 changes: make n_tty_trace() configurable to output via
  pr_xxxx() or dev_dbg() rather than trace_printk() per Alan's comments
- Patch 8 adds echo buffer indices tracing (separately selectable)

v1:
Patches 1-4 cleans up code duplication remnants from 3.12's changes.
Patch 5 simplifies the snarled logic of how much data is considered
'input available'. I was getting tired of hand checking that logic
every time I touched minimum_to_wake.
Patch 6 reduces unnecessary wake ups.

Patch 7 extends the trace usage to aid in identifying and fixing
input flow-control bugs (this was used to fix the readline() bug).
I also expect to use it to reduce input processing restarts. It's
use is disabled by default and only enabled with the file-local
define N_TTY_TRACE (similar to TTY_DEBUG_HANGUP in tty_io.c).

Regards,

Peter Hurley (8):
  n_tty: Merge .receive_buf() flavors
  n_tty: Un-inline slow-path n_tty_receive_char()
  n_tty: Un-inline slow-path n_tty_receive_char_closing()
  n_tty: Refactor PARMRK doubling checks
  n_tty: Refactor input_available_p() by call site
  n_tty: Only perform wakeups for waiters
  n_tty: Extend debug tracing
  n_tty: Trace echo output with separate trace configuration

 drivers/tty/n_tty.c | 174 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 112 insertions(+), 62 deletions(-)

-- 
1.8.1.2

