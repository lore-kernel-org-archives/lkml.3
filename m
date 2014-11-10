Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaKJS7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:59:12 -0500
Received: from smtprelay0027.hostedemail.com ([216.40.44.27]:59535 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751018AbaKJS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:59:10 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:69:355:379:541:973:988:989:1260:1345:1437:1534:1540:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3350:3867:3868:4605:5007:6261:9038:10004:10848:11026:11658:11914:12043:12048:12438:12517:12519:13161:13229:13311:13357:14096:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dogs55_898af7151ae0f
X-Filterd-Recvd-Size: 1774
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        openipmi-developer@lists.sourceforge.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Cc: Petr Mladek <pmladek@suse.cz>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH -next 0/2] seq: Convert seq_puts and seq_putc to return void
Date: Mon, 10 Nov 2014 10:58:55 -0800
Message-Id: <cover.1415645476.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are error prone, so return void adn use seq_has_overflowed instead

Joe Perches (2):
  seq_puts: Convert to return void and convert uses too.
  seq_putc: Convert to return void and convert uses too.

 drivers/char/ipmi/ipmi_msghandler.c                |  4 +-
 drivers/parisc/ccio-dma.c                          |  7 +-
 drivers/regulator/dbx500-prcmu.c                   | 21 ++----
 drivers/usb/gadget/udc/goku_udc.c                  | 81 +++++++++++-----------
 drivers/watchdog/bcm_kona_wdt.c                    | 43 +++++++-----
 fs/seq_file.c                                      | 26 +++----
 include/linux/seq_file.h                           |  4 +-
 ipc/util.c                                         |  6 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  4 +-
 net/netfilter/nf_conntrack_expect.c                |  4 +-
 10 files changed, 105 insertions(+), 95 deletions(-)

-- 
2.1.2

