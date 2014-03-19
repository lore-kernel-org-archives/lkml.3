Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965391AbaCSOwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:52:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964970AbaCSOwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:52:17 -0400
Date: Wed, 19 Mar 2014 10:52:00 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140319145200.GA4608@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Bob Liu <bob.liu@oracle.com>,
	Konstantin Khlebnikov <koct9i@gmail.com>
References: <20140311142817.GA26517@redhat.com>
 <20140311143750.GE32390@moon>
 <20140311171045.GA4693@redhat.com>
 <20140311173603.GG32390@moon>
 <20140311173917.GB4693@redhat.com>
 <alpine.LSU.2.11.1403181703470.7055@eggly.anvils>
 <5328F3B4.1080208@oracle.com>
 <20140319020602.GA29787@redhat.com>
 <20140319021131.GA30018@redhat.com>
 <alpine.LSU.2.11.1403181918130.3423@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1403181918130.3423@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 07:19:09PM -0700, Hugh Dickins wrote:

 > Another positive on the rss counters, great, thanks Dave.
 > That encourages me to think again on the swapops BUG, but no promises.

So while I slept I ran a test kernel with that swapops BUG replaced with a printk.
I'm not sure of the validity of this, given the state of the kernel afterwards
is somewhat suspect, but I did see in the logs this morning..

[18728.075153] migration_entry_to_page BUG hit
[18728.200705] BUG: Bad rss-counter state mm:ffff880241b3f500 idx:0 val:1 (Not tainted)
[18728.200706] BUG: Bad rss-counter state mm:ffff880241b3f500 idx:1 val:-1 (Not tainted)

This might be collateral damage from the swapops thing, I guess we won't know until
that gets fixed, but I thought I'd mention that we might still have a problem here.

	Dave

