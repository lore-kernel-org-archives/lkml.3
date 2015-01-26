Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbbAZVxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:53:37 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:41221 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:53:34 -0500
From: Sergei Rogachev <rogachevsergei@gmail.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Sergei Rogachev <rogachevsergei@gmail.com>
Subject: [PATCH 0/1] mm/page_ext: remove unnecessary stack_trace field
Date: Tue, 27 Jan 2015 00:52:11 +0300
Message-Id: <1422309132-28030-1-git-send-email-rogachevsergei@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality named "page owner" has resurrected the structure page_ext
which is used for keeping additional page-related information. Every page in
the system has its own corresponding page_ext structure.

Page owner uses this structure to keep allocation order, gfp_mask and backtrace
entries; moreover page_ext includes a field of type "struct stack_trace". And
this field is used for collecting backtraces: a pointer to struct stack_trace is
passed to save_stack_trace in the function __set_page_owner. But it is really
not necessary to keep dedicated stack_trace structures for all physical pages in
the system, only an amount of saved backtrace entries is needed to be saved.

The stack_trace structure can be allocated on the stack (it is relatively small)
and used for save_stack_trace invocation. Such change can save 12 bytes of
memory per page if page owner functionality is enabled.

Sergei Rogachev (1):
  mm/page_ext: remove unnecessary stack_trace field

 include/linux/page_ext.h |  2 +-
 mm/page_owner.c          | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

-- 
1.9.1

