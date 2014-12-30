Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaL3Us5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 15:48:57 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48361 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL3Us4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 15:48:56 -0500
Message-ID: <54A30FB4.8020606@gmail.com>
Date: Tue, 30 Dec 2014 21:48:52 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: mtk.manpages@gmail.com, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] posix_fadvise.2: Document the behaviour of partial
 page discard requests
References: <1417567367-9298-1-git-send-email-mgorman@suse.de> <1417567367-9298-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1417567367-9298-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 01:42 AM, Mel Gorman wrote:
> It is not obvious from the interface that partial page discard requests
> are ignored. It should be spelled out.

Thanks, Mel. Applied.

Cheers,

Michael


> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  man2/posix_fadvise.2 | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/man2/posix_fadvise.2 b/man2/posix_fadvise.2
> index 25d0c50..07313a9 100644
> --- a/man2/posix_fadvise.2
> +++ b/man2/posix_fadvise.2
> @@ -144,6 +144,11 @@ A program may periodically request the kernel to free cached data
>  that has already been used, so that more useful cached pages are not
>  discarded instead.
>  
> +Requests to discard partial pages are ignored. It is preferable to preserve
> +needed data than discard unneeded data. If the application requires that
> +data be considered for discarding then \fIoffset\fP and \fIlen\fP must be
> +page-aligned.
> +
>  Pages that have not yet been written out will be unaffected, so if the
>  application wishes to guarantee that pages will be released, it should
>  call
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
