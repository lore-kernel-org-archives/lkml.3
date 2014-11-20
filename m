Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbaKTSMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:12:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59307 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195AbaKTSL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:11:59 -0500
Date: Thu, 20 Nov 2014 18:11:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>,
        "ktsan@googlegroups.com" <ktsan@googlegroups.com>
Subject: Re: Potential data race in dput and __d_lookup
Message-ID: <20141120181145.GO7996@ZenIV.linux.org.uk>
References: <CAAeHK+zQZ=sJYQA=BKLS2i7hu8NyXn6GXngvDqG9WD96yd9acg@mail.gmail.com>
 <20141120174101.GT19126@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120174101.GT19126@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:41:01PM +0000, Will Deacon wrote:

> I think it should be fine. d_lock is #defined as d_lockref.lock, and the
> whole way the lockref works is that you can either cmpxchg the lock and the
> counter

... both by a single operation, that is.
