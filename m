Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3AYAL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 19:11:28 -0500
Received: from mail-ia0-f182.google.com ([209.85.210.182]:33536 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYALU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 19:11:20 -0500
MIME-Version: 1.0
In-Reply-To: <1357590280-31535-4-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1357590280-31535-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<1357590280-31535-4-git-send-email-sjenning@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 16:11:19 -0800
Message-ID: <CAPkvG_fFoc3ExetwxwN-vNMOOmkWgCYmh+shj3wFvjYB5i6YsQ@mail.gmail.com>
Subject: Re: [PATCHv2 3/9] staging: zsmalloc: add page alloc/free callbacks
From: Nitin Gupta <ngupta@vflare.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 12:24 PM, Seth Jennings
<sjenning@linux.vnet.ibm.com> wrote:
> This patch allows users of zsmalloc to register the
> allocation and free routines used by zsmalloc to obtain
> more pages for the memory pool.  This allows the user
> more control over zsmalloc pool policy and behavior.
>
> If the user does not wish to control this, alloc_page() and
> __free_page() are used by default.
>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zcache/zcache-main.c     |    2 +-
>  drivers/staging/zram/zram_drv.c          |    2 +-
>  drivers/staging/zsmalloc/zsmalloc-main.c |   43 ++++++++++++++++++++++--------
>  drivers/staging/zsmalloc/zsmalloc.h      |    8 +++++-
>  4 files changed, 41 insertions(+), 14 deletions(-)
>

Some documentation about zs_ops in zs_create_pool() would be useful.
Otherwise, looks good to me.

Acked-by: Nitin Gupta <ngupta@vflare.org>
