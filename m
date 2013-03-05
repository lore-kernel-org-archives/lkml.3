Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3CEVgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:36:46 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49532 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3CEVgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:36:43 -0500
Date: Wed, 6 Mar 2013 05:37:03 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com, vjaquez@igalia.com,
        rene.sapiens@ti.com, x0095078@ti.com, omar.ramirez@ti.com
Subject: Re: [PATCH 6/7] tidspbridge: convert to idr_alloc()
Message-ID: <20130305213703.GA10826@kroah.com>
References: <1362513772-15174-1-git-send-email-tj@kernel.org>
 <1362513772-15174-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362513772-15174-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 12:02:51PM -0800, Tejun Heo wrote:
> idr_get_new*() and friends are about to be deprecated.  Convert to the
> new idr_alloc() interface.
> 
> There are some peculiarities and possible bugs in the converted
> functions.  This patch preserves those.
> 
> * drv_insert_node_res_element() returns -ENOMEM on alloc failure,
>   -EFAULT if id space is exhausted.  -EFAULT is at best misleading.
> 
> * drv_proc_insert_strm_res_element() is even weirder.  It returns
>   -EFAULT if kzalloc() fails, -ENOMEM if idr preloading fails and
>   -EPERM if id space is exhausted.  What's going on here?
> 
> * drv_proc_insert_strm_res_element() doesn't free *pstrm_res after
>   failure.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Víctor Manuel Jáquez Leal <vjaquez@igalia.com>
> Cc: Rene Sapiens <rene.sapiens@ti.com>
> Cc: Armando Uribe <x0095078@ti.com>
> Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
> ---
>  drivers/staging/tidspbridge/rmgr/drv.c | 70 +++++++++++++---------------------
>  1 file changed, 26 insertions(+), 44 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

