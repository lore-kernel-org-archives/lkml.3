Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab3JJTzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:55:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756644Ab3JJTzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:55:07 -0400
Date: Thu, 10 Oct 2013 12:55:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: Re: [PATCH v3 3/3] mm/zswap: avoid unnecessary page scanning
Message-Id: <20131010125506.158c871becad30328abf6838@linux-foundation.org>
In-Reply-To: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
References: <000101ceb836$1a4c0ee0$4ee42ca0$%yang@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Sep 2013 16:21:49 +0800 Weijie Yang <weijie.yang@samsung.com> wrote:

> add SetPageReclaim before __swap_writepage so that page can be moved to the
> tail of the inactive list, which can avoid unnecessary page scanning as this
> page was reclaimed by swap subsystem before.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: stable@vger.kernel.org
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

As a minor(?) performance tweak, I don't believe this is suitable for
-stable backporting, so I took that out.  If you believe this was a
mistake, please explain why.


