Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934583AbaGXTyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:54:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934176AbaGXTyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:54:45 -0400
Date: Thu, 24 Jul 2014 21:53:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-doc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijls@redhat.com>
Subject: Re: [PATCH 3/5] mm, shmem: Add shmem_vma() helper
Message-ID: <20140724195302.GA28972@redhat.com>
References: <1406036632-26552-1-git-send-email-jmarchan@redhat.com> <1406036632-26552-4-git-send-email-jmarchan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406036632-26552-4-git-send-email-jmarchan@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Jerome Marchand wrote:
>
> +bool shmem_vma(struct vm_area_struct *vma)
> +{
> +	return (vma->vm_file &&
> +		vma->vm_file->f_dentry->d_inode->i_mapping->backing_dev_info
> +		== &shmem_backing_dev_info);
> +
> +}

Cosmetic nit, it seems that this helper could simply do

	return vma->vm_file && shmem_mapping(file_inode(vma->vm_file));

Oleg.

