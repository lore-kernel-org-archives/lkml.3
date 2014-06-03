Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaFCLCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:02:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaFCLCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:02:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Tue,  3 Jun 2014 12:02:27 +0100
Message-Id: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This must be about the smallest merge window patch set ever for GFS2.
It is probably also the first one without a single patch from me. That
is down to a combination of factors, and I have some things in the works
that are not quite ready yet, that I hope to put in next time around.

Returning to what is here this time... we have 3 patches which fix
various warnings. Two are bug fixes (for quotas and also a
rare recovery race condition). The final patch, from Ben Marzinski,
is an important change in the freeze code which has been in
progress for some time. This removes the need to take and drop the
transaction lock for every single transaction, when the only time it
was used, was at file system freeze time. Ben's patch integrates the
freeze operation into the journal flush code as an alternative with
lower overheads and also lands up resolving some difficult to fix races
at the same time,

Steve.


