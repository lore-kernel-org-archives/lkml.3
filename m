Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3EGLQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:16:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3EGLQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:16:45 -0400
Date: Tue, 7 May 2013 13:16:30 +0200
From: Andrew Jones <drjones@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        Anthony Liguori <aliguori@us.ibm.com>,
        Orit Wasserman <owasserm@redhat.com>,
        Juan Quintela <quintela@redhat.com>, Hugh Dickins <hughd@google.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>, Mel Gorman <mgorman@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 1/4] mm: madvise MADV_USERFAULT
Message-ID: <20130507111629.GA10720@hawk.usersys.redhat.com>
References: <1367870221-12676-1-git-send-email-aarcange@redhat.com>
 <1367870221-12676-2-git-send-email-aarcange@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367870221-12676-2-git-send-email-aarcange@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 09:56:58PM +0200, Andrea Arcangeli wrote:
> +++ b/mm/madvise.c
> @@ -93,6 +93,21 @@ static long madvise_behavior(struct vm_area_struct * vma,
>  		if (error)
>  			goto out;
>  		break;
> +	case MADV_USERFAULT:
> +		if (vma->vm_ops) {
> +			error = -EINVAL;
> +			goto out;
> +		}
> +		new_flags |= VM_USERFAULT;
> +		break;
> +	case MADV_NOUSERFAULT:
> +		if (vma->vm_ops) {
> +			WARN_ON(new_flags & VM_USERFAULT);
> +			error = -EINVAL;
> +			goto out;
> +		}
> +		new_flags &= ~VM_USERFAULT;
> +		break;
>  	}
>  
>  	if (new_flags == vma->vm_flags) {
> @@ -405,6 +420,7 @@ madvise_behavior_valid(int behavior)
>  	case MADV_HUGEPAGE:
>  	case MADV_NOHUGEPAGE:
>  #endif
> +	case MADV_USERFAULT:

Missing MADV_NOUSERFAULT: here

>  	case MADV_DONTDUMP:
>  	case MADV_DODUMP:
>  		return 1;
