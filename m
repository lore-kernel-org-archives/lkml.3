Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbbAMIla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:41:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:50358 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbAMIl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:41:28 -0500
Date: Tue, 13 Jan 2015 08:41:26 +0000
From: Thomas Graf <tgraf@suug.ch>
To: Ying Xue <ying.xue@windriver.com>
Cc: linux-kernel@vger.kernel.org, lkp@01.org, Netdev <netdev@vger.kernel.org>
Subject: Re: Fwd: [rhashtable] WARNING: CPU: 0 PID: 10 at
 kernel/locking/mutex.c:570 mutex_lock_nested()
Message-ID: <20150113084126.GE20387@casper.infradead.org>
References: <20150110194803.GA9033@wfg-t540p.sh.intel.com>
 <54B3259B.7080601@windriver.com>
 <20150112124216.GA26570@casper.infradead.org>
 <54B4CE3E.8020009@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B4CE3E.8020009@windriver.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/15 at 03:50pm, Ying Xue wrote:
> On 01/12/2015 08:42 PM, Thomas Graf wrote:
> > On 01/12/15 at 09:38am, Ying Xue wrote:
> >> Hi Thomas,
> >>
> >> I am really unable to see where is wrong leading to below warning
> >> complaints. Can you please help me check it?
> > 
> > Not sure yet. It's not your patch that introduced the issue though.
> > It merely exposed the affected code path.
> >
> > Just wondering, did you test with CONFIG_DEBUG_MUTEXES enabled?
> > 
> > 
> 
> After I enable above option, I don't find similar complaints during my
> testing.

I can't reproduce it in my KVM box either so far. It looks like a
mutex_lock() on an uninitialized mutex or use after free but I can't
find such a code path so far.
