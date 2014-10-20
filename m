Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaJTXlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:41:46 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:43479 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaJTXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:41:45 -0400
MIME-Version: 1.0
In-Reply-To: <20141020222841.419869904@infradead.org>
References: <20141020215633.717315139@infradead.org>
	<20141020222841.419869904@infradead.org>
Date: Mon, 20 Oct 2014 16:41:45 -0700
X-Google-Sender-Auth: TzNBWL-Yfb8nBI9TNHum136YmFk
Message-ID: <CA+55aFwd04q+O5ejbmDL-H7_GB6DEBMiiHkn+2R1u4uWxfDO9w@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 2:56 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Manage the VMAs with SRCU such that we can do a lockless VMA lookup.

Can you explain why srcu, and not plain regular rcu?

Especially as you then *note* some of the problems srcu can have.
Making it regular rcu would also seem to make it possible to make the
seqlock be just a seqcount, no?

                  Linus
