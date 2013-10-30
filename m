Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3J3Ou7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:50:59 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:41671 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3J3Ou6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:50:58 -0400
Message-ID: <52711CC7.8080107@mentor.com>
Date: Wed, 30 Oct 2013 16:50:47 +0200
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH rebased] sysfs: return correct error code on unimplemented
 mmap()
References: <20131029230524.GA14393@kroah.com> <1383134912-31152-1-git-send-email-vladimir_zapolskiy@mentor.com>
In-Reply-To: <1383134912-31152-1-git-send-email-vladimir_zapolskiy@mentor.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 30 Oct 2013 14:50:57.0961 (UTC) FILETIME=[715A0190:01CED57F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On 10/30/13 14:08, Vladimir Zapolskiy wrote:
> Both POSIX.1-2008 and Linux Programmer's Manual have a dedicated return
> error code for a case, when a file doesn't support mmap(), it's ENODEV.
>
> This change replaces overloaded EINVAL with ENODEV in a situation
> described above for sysfs binary files.
>
> Signed-off-by: Vladimir Zapolskiy<vladimir_zapolskiy@mentor.com>
> Cc: Greg Kroah-Hartman<gregkh@linuxfoundation.org>
> ---
>   fs/sysfs/file.c |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index 0d7368d4..382db3c 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -477,7 +477,6 @@ static int sysfs_bin_mmap(struct file *file, struct vm_area_struct *vma)
>   	if (!sysfs_get_active(of->sd))
>   		goto out_unlock;
>
> -	rc = -EINVAL;
>   	if (!battr->mmap)
>   		goto out_put;
>

as you asked the patch is rebased on top of linux-next, if you encounter 
any problems related to the change, please let me know.

Thanks,
Vladimir
