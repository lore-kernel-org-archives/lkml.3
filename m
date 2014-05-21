Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaEUTet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:34:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEUTes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:34:48 -0400
Date: Wed, 21 May 2014 12:34:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Message-Id: <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
In-Reply-To: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 22:04:22 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> Currently we split all THP pages on any clear_refs request. It's not
> necessary. We can handle this on PMD level.
> 
> One side effect is that soft dirty will potentially see more dirty
> memory, since we will mark whole THP page dirty at once.

This clashes pretty badly with
http://ozlabs.org/~akpm/mmots/broken-out/clear_refs-redefine-callback-functions-for-page-table-walker.patch

> Sanity checked with CRIU test suite. More testing is required.

Will you be doing that testing or was this a request for Cyrill & co to
help?

Perhaps this is post-3.15 material.
