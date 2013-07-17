Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3GQWoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:44:04 -0400
Received: from www.sr71.net ([198.145.64.142]:53892 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab3GQWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:44:03 -0400
Message-ID: <51E71E29.6030703@sr71.net>
Date: Wed, 17 Jul 2013 15:43:53 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thp, mm: locking tail page is a bug
References: <1373885274-25249-1-git-send-email-kirill.shutemov@linux.intel.com> <1373885274-25249-6-git-send-email-kirill.shutemov@linux.intel.com> <20130717140953.7560e88e607f8f5df1b1fdd8@linux-foundation.org>
In-Reply-To: <20130717140953.7560e88e607f8f5df1b1fdd8@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 02:09 PM, Andrew Morton wrote:
> lock_page() is a pretty commonly called function, and I assume quite a
> lot of people run with CONFIG_DEBUG_VM=y.
> 
> Is the overhead added by this patch really worthwhile?

I always thought of it as a developer-only thing.  I don't think any of
the big distros turn it on by default.
