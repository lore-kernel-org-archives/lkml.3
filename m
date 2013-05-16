Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3EPRzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:55:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:64622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab3EPRzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:55:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,685,1363158000"; 
   d="scan'208";a="338441944"
From: Andi Kleen <andi@firstfloor.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, riel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/11] ipc: move locking out of ipcctl_pre_down_nolock
References: <1368666490-29055-1-git-send-email-davidlohr.bueso@hp.com>
	<1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
Date: Thu, 16 May 2013 10:55:28 -0700
In-Reply-To: <1368666490-29055-5-git-send-email-davidlohr.bueso@hp.com>
	(Davidlohr Bueso's message of "Wed, 15 May 2013 18:08:03 -0700")
Message-ID: <m2vc6i3j3j.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <davidlohr.bueso@hp.com> writes:

> This function currently acquires both the rw_mutex and the rcu lock on
> successful lookups, leaving the callers to explicitly unlock them, creating
> another two level locking situation.

Note that the rcu read lock is not a real lock, so it doesn't have the
usual ordering problems.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
