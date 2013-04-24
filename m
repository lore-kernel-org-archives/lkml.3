Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab3DXGtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:49:50 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:46802 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3DXGtt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:49:49 -0400
Date: Wed, 24 Apr 2013 01:49:45 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 6/6] add documentation on proc.txt
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Minchan Kim <minchan@kernel.org>
References: <1366767664-17541-1-git-send-email-minchan@kernel.org>
	<1366767664-17541-7-git-send-email-minchan@kernel.org>
In-Reply-To: <1366767664-17541-7-git-send-email-minchan@kernel.org> (from
	minchan@kernel.org on Tue Apr 23 20:41:04 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1366786185.18069.160@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2013 08:41:04 PM, Minchan Kim wrote:
> This patch adds stuff about new reclaim field in proc.txt
> 
> Cc: Rob Landley <rob@landley.net>
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
> 
> Rob, I didn't add your Acked-by because interface was slight changed.
> I hope you give Acke-by after review again.
> Thanks.
> 
>  Documentation/filesystems/proc.txt | 22 ++++++++++++++++++++++
>  mm/Kconfig                         |  7 +------
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.txt  
> b/Documentation/filesystems/proc.txt
> index 488c094..1411ad0 100644
> --- a/Documentation/filesystems/proc.txt
> +++ b/Documentation/filesystems/proc.txt
> @@ -136,6 +136,7 @@ Table 1-1: Process specific entries in /proc
>   maps		Memory maps to executables and library files	 
> (2.4)
>   mem		Memory held by this process
>   root		Link to the root directory of this process
> + reclaim	Reclaim pages in this process
>   stat		Process status
>   statm		Process memory status information
>   status		Process status in human readable form
> @@ -489,6 +490,27 @@ To clear the soft-dirty bit
> 
>  Any other value written to /proc/PID/clear_refs will have no effect.
> 
> +The file /proc/PID/reclaim is used to reclaim pages in this process.
> +To reclaim file-backed pages,
> +    > echo file > /proc/PID/reclaim
> +
> +To reclaim anonymous pages,
> +    > echo anon > /proc/PID/reclaim
> +
> +To reclaim all pages,
> +    > echo all > /proc/PID/reclaim
> +
> +Also, you can specify address range of process so part of address  
> space
> +will be reclaimed. The format is following as
> +    > echo addr size-byte > /proc/PID/reclaim
> +
> +NOTE: addr should be page-aligned.

And size in bytes should be a multiple of page size?

> +
> +Below is example which try to reclaim 2 pages from 0x100000.
> +
> +To reclaim both pages in address range,
> +    > echo $((1<<20) 8192 > /proc/PID/reclaim

Would you like to balance your parentheses?

Acked-by: Rob Landley <rob@landley.net>

Rob