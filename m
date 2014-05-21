Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaEUT5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:57:31 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:34359 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaEUT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:57:30 -0400
Date: Wed, 21 May 2014 23:57:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Message-ID: <20140521195723.GD12819@moon>
References: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 12:34:46PM -0700, Andrew Morton wrote:
> On Wed, 21 May 2014 22:04:22 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > Currently we split all THP pages on any clear_refs request. It's not
> > necessary. We can handle this on PMD level.
> > 
> > One side effect is that soft dirty will potentially see more dirty
> > memory, since we will mark whole THP page dirty at once.
> 
> This clashes pretty badly with
> http://ozlabs.org/~akpm/mmots/broken-out/clear_refs-redefine-callback-functions-for-page-table-walker.patch
> 
> > Sanity checked with CRIU test suite. More testing is required.
> 
> Will you be doing that testing or was this a request for Cyrill & co to
> help?

We've talking to Kirill how to test is and end up that criu is
the best candidate (though I think I'll write selftest for
vanilla too, hopefully tomorrow).
