Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab3EGMkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:40:42 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:34114 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab3EGMkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:40:41 -0400
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
To: zbr@ioremap.net
Cc: linux-kernel@vger.kernel.org
Subject: Fix ds2408 P0 output not working after power-on
Date: Tue,  7 May 2013 08:40:21 -0400
Message-Id: <1367930422-25972-1-git-send-email-jeff.dagenais@gmail.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue is described in the v2 datasheet of ds2408 (see commit message). On
our board (9 ds2408 and 2 ds2433 on a ds1wm mastered bus), the problem affects
only 2 out of 9 chips 2408 and only after a long power off.

Adding the magic sequence described in the datasheet fixes the issue as
promised.

I had to do a little trick with the w1 master mutex since "add_slave" may be
called during w1 search of the master, at which time, the search op locks the
mutex the whole time. Checking if the mutex owner is the current thread to
determine whether locking is required or not sounds safe to me, any thoughts on
that? The bus search on my heavy setup works perfectly and is very stable.

Another point I'd like others to (perhaps) comment on is about doing this
"non-search" interaction with a particular slave between two search branches. I
did my homework and I can't find anything wrong with that.

/jfd

