Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907Ab3DQHBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:01:23 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65520 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3DQHBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:01:20 -0400
Date: Wed, 17 Apr 2013 00:01:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Libin <huawei.libin@huawei.com>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-mm@kvack.org, guohanjun@huawei.com,
        wangyijing@huawei.com
Subject: Re: [PATCH 4/6] char: use vma_pages() to replace (vm_end - vm_start)
 >> PAGE_SHIFT
In-Reply-To: <1366030138-71292-4-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.DEB.2.02.1304162359560.5220@chino.kir.corp.google.com>
References: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com> <1366030138-71292-4-git-send-email-huawei.libin@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Libin wrote:

> diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
> index e1f60f9..ed0703f 100644
> --- a/drivers/char/mspec.c
> +++ b/drivers/char/mspec.c
> @@ -168,7 +168,7 @@ mspec_close(struct vm_area_struct *vma)
>  	if (!atomic_dec_and_test(&vdata->refcnt))
>  		return;
>  
> -	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
> +	last_index = vma_pages(vdata);
>  	for (index = 0; index < last_index; index++) {
>  		if (vdata->maddr[index] == 0)
>  			continue;

vdata is of type struct vma_data * and vma_pages() takes a formal of type 
struct vm_area_struct *, so these are incompatible.  Hopefully you tested 
the other changes and simply lack an ia64 cross compiler for this one, 
because it will emit a warning.
