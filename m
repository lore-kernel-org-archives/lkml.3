Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbbAVUIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:08:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbbAVUIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:08:37 -0500
Date: Thu, 22 Jan 2015 12:08:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shiraz Hashim <shashim@codeaurora.org>
Cc: linux-mm@kvack.org, oleg@redhat.com, gorcunov@openvz.org,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com
Subject: Re: [PATCH] mm: pagewalk: call pte_hole() for VM_PFNMAP during
 walk_page_range
Message-Id: <20150122120820.8c279cf8.akpm@linux-foundation.org>
In-Reply-To: <1421820793-28883-1-git-send-email-shashim@codeaurora.org>
References: <1421820793-28883-1-git-send-email-shashim@codeaurora.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015 11:43:13 +0530 Shiraz Hashim <shashim@codeaurora.org> wrote:

> walk_page_range silently skips vma having VM_PFNMAP set,
> which leads to undesirable behaviour at client end (who
> called walk_page_range). For example for pagemap_read,
> when no callbacks are called against VM_PFNMAP vma,
> pagemap_read may prepare pagemap data for next virtual
> address range at wrong index.

This changelog doesn't have enough information for me to be able to
work out whether a -stable backport is needed.  Please always describe
the user-visible effects of a bug.

