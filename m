Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab3KCLgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 06:36:48 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:40314 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KCLgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 06:36:46 -0500
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv2 0/2] IPC DoS fix
Date: Sun,  3 Nov 2013 12:36:26 +0100
Message-Id: <1383478588-7011-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
References: <CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

version 2 of this series uses your approach to fix the issues by changing
load_msg() and friends to use a size_t for the message length. It differs
slightly from your patch to cover a few more places where the message
length is evaluated in sign extension problematic expressions. Also the
sysctl change is still a separate patch to allow reverting it in case it
breaks existing userland. It now handles all three sysctls: msgmax, msgmnb
and msgmni. All still capped at INT_MAX, though. They're privileged
sysctls after all. And setting them to INT_MAX does not end up in a system
crash, as it is now for negative values, but in an OOM killer invocation
instead which can be handled gracefully.

Regards,
Mathias


Mathias Krause (2):
  ipc, msg: fix message length check for negative values
  ipc, msg: forbid negative values for "msg{max,mnb,mni}"

 include/linux/ipc_namespace.h |    6 +++---
 include/linux/msg.h           |    6 +++---
 ipc/ipc_sysctl.c              |   20 ++++++++++++--------
 ipc/msgutil.c                 |   20 ++++++++++----------
 ipc/util.h                    |    4 ++--
 5 files changed, 30 insertions(+), 26 deletions(-)

-- 
1.7.10.4

