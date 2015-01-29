Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761916AbbA2KDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:03:46 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49980 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbbA2KDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:03:40 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/3] Two printf fixes
Date: Thu, 29 Jan 2015 11:03:17 +0100
Message-Id: <1422525801-26560-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1422451543-12401-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both %pE and %ph are unusable in kasprintf(), since the occurrence of
either will trigger an oops during the first vsnprintf call where
kasprintf tries to find the correct size to allocate. These oopses
could be papered over with somewhat smaller patches than these, but
then the return value from vsnprintf would still not reflect the
actual size needed. For %pE, this requires a change of semantics of
string_escape_mem and hence an annoyingly large diffstat.

Whether this is 3.20, 3.21 and/or -stable material (or /dev/null
material, for that matter ;-)) I'll leave to others to decide.

v2: Suggestions from Andy Shevchenko:

* Simpler fix of hex_string().

* The string_escape_mem change is split in two, 2/3 updating the
  internal helpers and 3/3 then changing the external interface.

Rasmus Villemoes (3):
  lib/vsprintf.c: Fix potential NULL deref in hex_string
  lib/string_helpers.c: Refactor string_escape_mem
  lib/string_helpers.c: Change semantics of string_escape_mem

 include/linux/string_helpers.h |  10 +--
 lib/string_helpers.c           | 191 ++++++++++++++++-------------------------
 lib/test-string_helpers.c      |  37 ++++----
 lib/vsprintf.c                 |  18 ++--
 net/sunrpc/cache.c             |   8 +-
 5 files changed, 111 insertions(+), 153 deletions(-)

-- 
2.1.3

