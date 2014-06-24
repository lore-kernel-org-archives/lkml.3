Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaFXPBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:01:19 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57728 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFXPBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:01:18 -0400
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] btrfs compression: reuse recently used workspace
Date: Wed, 25 Jun 2014 00:00:43 +0900
Message-Id: <1403622044-2964-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.0.0.548.ge727dec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Whenever possible, find_workspace() returns the first idle workspace;
and free_workspace() puts workspace to idle list tail. Put workspace to
head of idle list instead. Hopefully, this will let to reuse most recently
used workspace and avoid workspace->mem, ->buf, ->cbuf address translations.

p.s. This patch is theoretical, no testing has been performed in order to
support this patch.

Sergey Senozhatsky (1):
  btrfs compression: reuse recently used workspace

 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.0.0.548.ge727dec

