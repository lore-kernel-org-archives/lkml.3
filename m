Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284AbaGGTNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 15:13:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaGGTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 15:13:47 -0400
Date: Mon, 7 Jul 2014 12:13:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v3 0/3] free reclaimed pages by paging out instantly
Message-Id: <20140707121346.1487c20e2a9365325e3a81a6@linux-foundation.org>
In-Reply-To: <20140703005949.GC21751@bbox>
References: <1404260029-11525-1-git-send-email-minchan@kernel.org>
	<20140702134215.2bf830dcb904c34bd2e2b9e8@linux-foundation.org>
	<20140703005949.GC21751@bbox>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2014 09:59:49 +0900 Minchan Kim <minchan@kernel.org> wrote:

> > > Most of field in vmstat are not changed too much but things I can notice
> > > is allocstall and pgrotated. We could save allocstall(ie, direct relcaim)
> > > and pgrotated very much.
> > > 
> > > Welcome testing, review and any feedback!
> > 
> > Well, it will worsen IRQ latencies and it's all more code for us to
> > maintain.  I think I'd like to see a better story about the end-user
> > benefits before proceeding.
> 
> The motivation was from per-process reclaim(which was internal feature
> yet and and I will repost it soon).
> It's a feature for us to manage memory from platform so that we could
> avoid reclaim.
> 
> Anyway, userspace expect they could see increased free pages in vmstat
> after they have done per-process reclaim so the logic of userspace
> will control their next action depending on the number of current
> free page but it doesn't work with existing rotation logic, expecially
> anon swap write pages.
> 
> When I posted this patchset firstly, Rik was positive and I thought
> this feature is useful for everyone as well as per-process reclaim
> and don't want to make noise this patchset with perpcoess reclaim.
> 
> https://lkml.org/lkml/2013/5/12/174
> https://lkml.org/lkml/2013/5/14/484
> 
> Could you tell me what should I do to proceed?

Quantify the gains, quantify the losses then demonstrate that the
benefits of the gains exceeds the cost of the losses plus the cost of
ongoing maintenance!
