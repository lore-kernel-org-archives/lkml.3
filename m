Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab3KZWSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 17:18:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab3KZWSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 17:18:18 -0500
From: riel@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        peterz@infradead.org
Subject: [RFC PATCH 0/4] pseudo-interleaving NUMA placement
Date: Tue, 26 Nov 2013 17:03:24 -0500
Message-Id: <1385503408-30041-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set attempts to implement a pseudo-interleaving
policy for workloads that do not fit in one NUMA node.

For each NUMA group, we track the NUMA nodes on which the
workload is actively running, and try to concentrate the
memory on those NUMA nodes.

Unfortunately, the scheduler appears to move tasks around
quite a bit, leading to nodes being dropped from the
"active nodes" mask, and re-added a little later, causing
excessive memory migration.

I am not sure how to solve that. Hopefully somebody will
have an idea :)

