Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933884Ab3CHIkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:40:20 -0500
Received: from shutemov.name ([204.155.152.216]:37820 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab3CHIkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:40:19 -0500
Date: Fri, 8 Mar 2013 10:42:46 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Howard Chu <hyc@symas.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: mmap vs fs cache
Message-ID: <20130308084246.GA4411@shutemov.name>
References: <5136320E.8030109@symas.com>
 <20130307154312.GG6723@quack.suse.cz>
 <20130308020854.GC23767@cmpxchg.org>
 <5139975F.9070509@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5139975F.9070509@symas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:46:39PM -0800, Howard Chu wrote:
> You're misreading the information then. slapd is doing no caching of
> its own, its RSS and SHR memory size are both the same. All it is
> using is the mmap, nothing else. The RSS == SHR == FS cache, up to
> 16GB. RSS is always == SHR, but above 16GB they grow more slowly
> than the FS cache.

It only means, that some pages got unmapped from your process. It can
happned, for instance, due page migration. There's nothing worry about: it
will be mapped back on next page fault to the page and it's only minor
page fault since the page is in pagecache anyway.

-- 
 Kirill A. Shutemov
