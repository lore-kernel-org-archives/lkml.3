Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab3LLXrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:47:40 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:54060 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571Ab3LLXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:47:36 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:967:968:973:988:989:1260:1345:1359:1437:1534:1539:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3350:3865:3866:3867:3868:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4605:5007:6261:7875:7903:9025:10004:10026:10848:11026:11658:11854:11914:12043:12291:12296:12517:12519:12679:12683:12740:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake39_7e8728b30612
X-Filterd-Recvd-Size: 1487
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH -next 0/4] fs: Use seq_is_buf_full
Date: Thu, 12 Dec 2013 15:47:27 -0800
Message-Id: <cover.1386891757.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386819513.git.joe@perches.com>
References: <cover.1386819513.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the fs uses and misuses of seq_printf to void

These patches depend on https://lkml.org/lkml/2013/12/11/714

Joe Perches (4):
  dlm: Use seq_is_buf_full - remove seq_printf returns
  dlm: Use seq_puts, remove unnecessary trailing spaces
  fs: Convert show_fdinfo functions to void
  debugfs: Fix misuse of seq_printf return value

 fs/debugfs/file.c  |  14 +--
 fs/dlm/debug_fs.c  | 274 +++++++++++++++++++++++++----------------------------
 fs/eventfd.c       |  15 +--
 fs/eventpoll.c     |  19 ++--
 fs/notify/fdinfo.c |  68 ++++++-------
 fs/notify/fdinfo.h |   4 +-
 fs/proc/fd.c       |   2 +-
 fs/signalfd.c      |  10 +-
 include/linux/fs.h |   2 +-
 9 files changed, 184 insertions(+), 224 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

