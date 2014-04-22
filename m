Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaDVFq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:46:26 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53922 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaDVFqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:46:24 -0400
MIME-Version: 1.0
Date: Tue, 22 Apr 2014 13:46:23 +0800
Message-ID: <CAFiDJ58CYnW4fK2iQvXK_8TBgAvTFdfwXx671AHOFT4JK1_COQ@mail.gmail.com>
Subject: min() and max() have warning: comparison of distinct pointer types
 lacks a cast
From: "LF.Tan" <lftan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

Have these warning messages when compiling kernel.
Anyone know what's wrong?

Regards.
----------------------------
In file included from mm/readahead.c:10:0:
mm/readahead.c: In function 'max_sane_readahead':
include/linux/kernel.h:713:17: warning: comparison of distinct pointer
types lacks a cast [enabled by default]
  (void) (&_min1 == &_min2);  \
                 ^
mm/readahead.c:242:9: note: in expansion of macro 'min'
  return min(nr, MAX_READAHEAD);
         ^

-------------------------------------------------------------------------------
mm/rmap.c:1279:22: note: in expansion of macro 'min'
 #define CLUSTER_SIZE min(32*PAGE_SIZE, PMD_SIZE)
                      ^
mm/rmap.c:1280:25: note: in expansion of macro 'CLUSTER_SIZE'
 #define CLUSTER_MASK (~(CLUSTER_SIZE - 1))
                         ^
mm/rmap.c:1298:39: note: in expansion of macro 'CLUSTER_MASK'
  address = (vma->vm_start + cursor) & CLUSTER_MASK;
                                       ^
