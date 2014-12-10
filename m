Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaLJGXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 01:23:30 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:43675 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaLJGX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 01:23:29 -0500
Message-ID: <1418192604.5312.28.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/fair: change where we report sched stats
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Josef Bacik <jbacik@fb.com>
Cc: bmaurer@fb.com, rkroll@fb.com, kernel-team@fb.com, mingo@redhat.com,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 10 Dec 2014 07:23:24 +0100
In-Reply-To: <1418149315-30173-1-git-send-email-jbacik@fb.com>
References: <1418149315-30173-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-09 at 13:21 -0500, Josef Bacik wrote:

> This patch moves stat stuff to after the schedule, right as we are waking up,

But sleep/block ends when the task is awakened/enqueued, not when it
gets the CPU.  You're adding scheduling latency, breaking accounting.

-Mike


