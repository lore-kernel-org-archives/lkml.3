Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaCXM7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 08:59:31 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63596 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCXM73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:59:29 -0400
Message-Id: <20140324122838.490106581@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 24 Mar 2014 16:28:38 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: hughd@google.com, xemul@parallels.com, akpm@linux-foundation.org,
        gorcunov@openvz.org
Subject: [patch 0/4] mm: A few memory tracker fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! Here is a few fixes for memory softdirty tracker inspired by
LKML thread https://lkml.org/lkml/2014/3/18/709 . It turned out
that indeed I've missed to setup softdirty bit on file mappings
in a few places. But it seems the only intensive user of this
feature is the criu tool where we dump/restore shared memory
areas completely regardless the softdirty bit status and
shared file mapped areas are not dumped at all so I'm not
sure if the patches are stable material. Please take a look,
thanks.

	Cyrill
