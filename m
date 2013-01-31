Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3AaAmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 19:42:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3AaAmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:42:22 -0500
Date: Wed, 30 Jan 2013 16:42:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: use long type for page counts in mm_populate()
 and get_user_pages()
Message-Id: <20130130164220.eaebcb6a.akpm@linux-foundation.org>
In-Reply-To: <1359591980-29542-2-git-send-email-walken@google.com>
References: <1359591980-29542-1-git-send-email-walken@google.com>
	<1359591980-29542-2-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 16:26:18 -0800
Michel Lespinasse <walken@google.com> wrote:

> Use long type for page counts in mm_populate() so as to avoid integer
> overflow

Would prefer to use unsigned long if we're churning this code.  A "page
count" can never be negative and we avoid the various possible
overflow/signedness issues.

However get_user_pages() and follow_hugetlb_page() return "page count
or -ve errno", so we're somewhat screwed there.  And that's the bulk of
the patch :(

btw, what twit merged a follow_hugetlb_page() which takes an
undocumented argument called "i".  Sigh.

