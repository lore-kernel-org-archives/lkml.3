Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaEVIfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:35:14 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51541 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaEVIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:35:11 -0400
Date: Thu, 22 May 2014 12:35:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Message-ID: <20140522083506.GC8946@moon>
References: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
 <20140522011110.B0090E009B@blue.fi.intel.com>
 <20140522053247.GA8946@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522053247.GA8946@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:32:47AM +0400, Cyrill Gorcunov wrote:
> On Thu, May 22, 2014 at 04:11:10AM +0300, Kirill A. Shutemov wrote:
> > Andrew Morton wrote:
> > > On Wed, 21 May 2014 22:04:22 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> > > 
> > > > Currently we split all THP pages on any clear_refs request. It's not
> > > > necessary. We can handle this on PMD level.
> > > > 
> > > > One side effect is that soft dirty will potentially see more dirty
> > > > memory, since we will mark whole THP page dirty at once.
> > > 
> > > This clashes pretty badly with
> > > http://ozlabs.org/~akpm/mmots/broken-out/clear_refs-redefine-callback-functions-for-page-table-walker.patch
> > 
> > Hm.. For some reason CRIU memory-snapshotting test cases fail on current
> > linux-next. I didn't debug why. Mainline works. Folks?
> 
> Thanks for noticing, Kirill! I don't test linux-test regulary will try and
> report the results.

OK, I managed to run criu on linux-next. Due to changes in vdso it no longer
able to run. I'll handle it in criu and ping you then.
