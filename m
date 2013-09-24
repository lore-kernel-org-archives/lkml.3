Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750793Ab3IXGRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:17:43 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57246 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3IXGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:17:41 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] Bcache fixes - please apply
Date: Mon, 23 Sep 2013 23:17:25 -0700
Message-Id: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply the following patch series. There's fixes for
_three_ different data corruption bugs, all of which were found by users
hitting them in the wild.

The first one isn't bcache specific - in 3.11 bcache was switched to the
bio_copy_data in fs/bio.c, and that's when the bug in that code was
discovered, but it's also used by raid1 and pktcdvd. (That was my code
too, so the bug's doubly embarassing given that it was or should've been
just a cut and paste from bcache code. Dunno what happened there).

Most of these (all the non data corruption bugs, actually) were ready
before the merge window and have been sitting in Jens' tree, but I don't
know what's been up with him lately...


