Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaISN30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 09:29:26 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42752 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831AbaISN3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:29:25 -0400
Date: Fri, 19 Sep 2014 09:29:19 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: linux-mm@kvack.org
Cc: Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Dave Hansen <dave@sr71.net>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: lockless page counters
Message-ID: <20140919132919.GA16184@cmpxchg.org>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

this patch removes the lock you saw with will-it-scale/page_fault2
entirely, is there a chance you could give it a spin?  It's based on
v3.17-rc4-mmots-2014-09-12-17-13-4 and that memcg THP fix.  That
kernel also includes the recent root-memcg revert, so you'd have to
run it in a memcg; which is as easy as:

mkdir /sys/fs/cgroup/memory/foo
echo $$ >/sys/fs/cgroup/memory/foo/tasks
perf record -g -a ./runtest.py page_fault2

Thanks!
