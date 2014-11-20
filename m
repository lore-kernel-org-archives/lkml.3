Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbaKTSFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 13:05:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59295 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841AbaKTSFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 13:05:17 -0500
Date: Thu, 20 Nov 2014 18:05:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>, ktsan@googlegroups.com
Subject: Re: Potential data race in dput and __d_lookup
Message-ID: <20141120180503.GN7996@ZenIV.linux.org.uk>
References: <CAAeHK+zQZ=sJYQA=BKLS2i7hu8NyXn6GXngvDqG9WD96yd9acg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+zQZ=sJYQA=BKLS2i7hu8NyXn6GXngvDqG9WD96yd9acg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 09:20:14PM +0400, Andrey Konovalov wrote:

> It seems that one thread increments 'dentry->d_lockref.count', while
> other does 'lockref_put_or_lock(&dentry->d_lockref)'  without any
> synchronization.
> 
> Could you confirm if this is a real race?

I can not.  Increment in __d_lookup() is under ->d_lockref.lock (aka
->d_lock) and lockref_put_or_lock() is atomic wrt that.
