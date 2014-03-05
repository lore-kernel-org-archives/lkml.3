Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaCER5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:57:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbaCER5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:57:36 -0500
Date: Wed, 5 Mar 2014 12:57:25 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bad rss-counter message in 3.14rc5
Message-ID: <20140305175725.GB16335@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20140305174503.GA16335@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305174503.GA16335@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 12:45:03PM -0500, Dave Jones wrote:
 > I just saw this on my box that's been running trinity..
 > 
 > [48825.517189] BUG: Bad rss-counter state mm:ffff880177921d40 idx:0 val:1 (Not tainted)
 > 
 > There's nothing else, no trace, nothing.  Any ideas where to begin with this?

ah, on the serial console there was also this truncated warning..

[48825.517189] BUG: Bad rss-counter state mm:ffff880177921d40 idx:0 val:1 (Not tainted)
[48924.133273] ------------[ cut here ]------------
[48924.133391] kernel BUG at include/linux/swapops.h:131!

	Dave

124 static inline struct page *migration_entry_to_page(swp_entry_t entry)
125 {
126         struct page *p = pfn_to_page(swp_offset(entry));
127         /*
128          * Any use of migration entries may only occur while the
129          * corresponding page is locked
130          */
131         BUG_ON(!PageLocked(p));
132         return p;
133 }

