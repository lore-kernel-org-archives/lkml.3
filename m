Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3KVP7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:59:47 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54725 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3KVP7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:59:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 0/7] n_tty cleanup + trace additions
Date: Fri, 22 Nov 2013 10:59:18 -0500
Message-Id: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

This patchset contains no bug fixes only misc cleanup for the
N_TTY line discipline.

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

Peter Hurley (7):
  n_tty: Merge .receive_buf() flavors
  n_tty: Un-inline slow-path n_tty_receive_char()
  n_tty: Un-inline slow-path n_tty_receive_char_closing()
  n_tty: Refactor PARMRK doubling checks
  n_tty: Refactor input_available_p() by call site
  n_tty: Only perform wakeups for waiters
  n_tty: trace input/read flow control

 drivers/tty/n_tty.c | 159 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 97 insertions(+), 62 deletions(-)

-- 
1.8.1.2

