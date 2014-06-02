Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaFBSUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:20:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:12879 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbaFBSUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,958,1392192000"; 
   d="scan'208";a="550368929"
Message-ID: <538CC026.4030008@intel.com>
Date: Mon, 02 Jun 2014 11:19:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] replace PAGECACHE_TAG_* definition with enumeration
References: <20140521193336.5df90456.akpm@linux-foundation.org> <1401686699-9723-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1401686699-9723-2-git-send-email-n-horiguchi@ah.jp.nec.com> <538CA269.6010300@intel.com> <1401727052-f7v7kykv@n-horiguchi@ah.jp.nec.com> <538CAA13.2080708@intel.com> <538cb12a.8518c20a.1a51.ffff9761SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <538cb12a.8518c20a.1a51.ffff9761SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 10:14 AM, Naoya Horiguchi wrote:
> Yes, that's necessary to consider (but I haven't done, sorry),
> so I'm thinking of moving this definition to the new file
> include/uapi/linux/pagecache.h and let it be imported from the
> userspace programs. Is it fine?

Yep, although I'd probably also explicitly separate the definitions of
the user-exposed ones from the kernel-internal ones.  We want to make
this hard to screw up.

I can see why we might want to expose dirty and writeback out to
userspace, especially since we already expose the aggregate, system-wide
view in /proc/meminfo.  But, what about PAGECACHE_TAG_TOWRITE?  I really
can't think of a good reason why userspace would ever care about it or
consider it different from PAGECACHE_TAG_DIRTY.
