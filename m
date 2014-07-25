Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbaGYSR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:17:58 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:47116 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaGYSR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:17:57 -0400
Date: Fri, 25 Jul 2014 14:17:56 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: Abhi Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Message-ID: <669415318.13475310.1406312276453.JavaMail.zimbra@redhat.com>
In-Reply-To: <1406309888-10749-2-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com> <1406309888-10749-2-git-send-email-adas@redhat.com>
Subject: Re: [Cluster-devel] [RFC PATCH 1/5] fs: xstat system call VFS bits
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF30 (Linux)/8.0.6_GA_5922)
Thread-Topic: xstat system call VFS bits
Thread-Index: 9lqiIBvb23XWiam9BO/Rf9Vo3v2RGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> This patch adds the VFS bits of the xstat patchset by David
> Howells. The xgetdents syscall uses this to obtain stat
> information for directory entries.
> 
> Signed-off-by: Abhi Das <adas@redhat.com>
> ---
>  arch/x86/syscalls/syscall_32.tbl |   2 +
>  arch/x86/syscalls/syscall_64.tbl |   2 +
>  fs/stat.c                        | 338
>  ++++++++++++++++++++++++++++++++++++---
>  include/linux/fs.h               |   4 +
>  include/linux/stat.h             |  14 +-
>  include/linux/syscalls.h         |   5 +
>  include/uapi/linux/fcntl.h       |   1 +
>  include/uapi/linux/stat.h        | 110 +++++++++++++
>  8 files changed, 453 insertions(+), 23 deletions(-)
(snip)
> +static int xstat_get_params(unsigned int mask, struct xstat __user *buffer,
> +			    struct kstat *stat)
> +{
> +	memset(stat, 0xde, sizeof(*stat)); // DEBUGGING

Did you forget to remove this DEBUGGING statement? In either case, the c++
comment should be /* */.

Regards,

Bob Peterson
Red Hat File Systems
