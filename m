Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaEUTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:19:22 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47033 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaEUTTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:19:18 -0400
Date: Wed, 21 May 2014 23:19:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Message-ID: <20140521191915.GC12819@moon>
References: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 10:04:22PM +0300, Kirill A. Shutemov wrote:
> Currently we split all THP pages on any clear_refs request. It's not
> necessary. We can handle this on PMD level.
> 
> One side effect is that soft dirty will potentially see more dirty
> memory, since we will mark whole THP page dirty at once.
> 
> Sanity checked with CRIU test suite. More testing is required.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Dave Hansen <dave.hansen@intel.com>

Looks reasonable to me, thanks!

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
