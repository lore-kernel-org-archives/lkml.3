Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3JOLbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:31:45 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:46581 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3JOLbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:31:44 -0400
Date: Tue, 15 Oct 2013 13:30:21 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, adobriyan@gmail.com, vgoyal@redhat.com,
        willeke@de.ibm.com
Subject: Re: [PATCH 0/3] procfs, vmcore: fix regression of mmap on
 /proc/vmcore since v3.12-rc1
Message-ID: <20131015133021.44602125@holzheu>
In-Reply-To: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
References: <20131014093606.9801.11175.stgit@localhost6.localdomain6>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101511-1948-0000-0000-00000697AF5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hatayama,

We successfully tested your patches on s390, mmap for /proc/vmcore
seems to work again.

Thanks!

Michael

On Mon, 14 Oct 2013 18:36:06 +0900
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> This patch set fixes regression of mmap on /proc/vmcore since
> v3.12-rc1. The primary one is the 2nd patch. The 1st patch is another
> bug I found during investiation and it affects mmap on /proc/vmcore
> even if only 2nd patch is applied, so fix it together in this patch
> set. The last patch is just for cleaning up of target function in both
> 1st and 2nd patches.
> 
> ---
> 
> HATAYAMA Daisuke (3):
>       procfs: fix unintended truncation of returned mapped address
>       procfs: Call default get_unmapped_area on MMU-present architectures
>       procfs: clean up proc_reg_get_unmapped_area for 80-column limit
> 
> 
>  fs/proc/inode.c |   20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 

