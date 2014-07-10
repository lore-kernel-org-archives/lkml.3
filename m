Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaGJWPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:15:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGJWPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:15:53 -0400
Date: Thu, 10 Jul 2014 15:15:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-mm <linux-mm@kvack.org>,
        Oded Gabbay <oded.gabbay@amd.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH 28/83] mm: Change timing of notification to IOMMUs about
 a page to be invalidated
Message-Id: <20140710151551.55646da50617fe9997e2830c@linux-foundation.org>
In-Reply-To: <1405029208-6703-1-git-send-email-oded.gabbay@amd.com>
References: <1405029208-6703-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 00:53:26 +0300 Oded Gabbay <oded.gabbay@gmail.com> wrote:

> From: Andrew Lewycky <Andrew.Lewycky@amd.com>
> 
> This patch changes the location of the mmu_notifier_invalidate_page function
> call inside try_to_unmap_one. The mmu_notifier_invalidate_page function
> call tells the IOMMU that a pgae should be invalidated.
> 
> The location is changed from after releasing the physical page to
> before releasing the physical page.
> 
> This change should prevent the bug that would occur in the
> (rare) case where the GPU attempts to access a page while the CPU
> attempts to swap out that page (or discard it if it is not dirty).

um OK, but what is the effect on all the other
mmu_notifier_ops.invalidate_page() implementations?

Please spell this out in full detail within the changelog and be sure
to cc the affected maintainers.


