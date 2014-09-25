Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaIYNz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:55:27 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46004 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbaIYNz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:55:26 -0400
MIME-Version: 1.0
Date: Thu, 25 Sep 2014 22:55:24 +0900
Message-ID: <CALLJCT0YKkg=PZN1i4eOEWdJoLE8oAyTAk0OmRHLOGRstqk4MQ@mail.gmail.com>
Subject: [linux-next] mm/debug.c compile failure with CONFIG_MEMCG not set
From: Masanari Iida <standby24x7@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        sasha.levin@oracle.com, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of linux-next 20140925, if I don't set CONFIG_MEMCG,
the compile failed with following error.

mm/debug.c: In function ‘dump_mm’:
mm/debug.c:169:1183: error: ‘const struct mm_struct’ has no member named ‘owner’
  pr_emerg("mm %p mmap %p seqnum %d task_size %lu\n"

make[1]: *** [mm/debug.o] Error 1

If I set CONFIG_MEMCG, the compile succeed.

Reported-by: Masanari Iida <standby24x7@gmail.com>
