Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaDDL1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:27:39 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:36717 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaDDL1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:27:37 -0400
Message-ID: <533E9725.90708@gmail.com>
Date: Fri, 04 Apr 2014 13:27:33 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrey Vagin <avagin@openvz.org>
CC: mtk.manpages@gmail.com, linux-man@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] maps.2: fd for a file mapping must be opened for reading
References: <1396599875-10562-1-git-send-email-avagin@openvz.org>
In-Reply-To: <1396599875-10562-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 10:24 AM, Andrey Vagin wrote:
> Here is no difference between MAP_SHARED and MAP_PRIVATE.

Thanks, Andrey. That man page text has been there for a very long time,
but but does not seem to correspond to the truth in any kernel version
going back even to Linux 1.0. Patch applied.

Cheers,

Michael


> do_mmap_pgoff()
> 	switch (flags & MAP_TYPE) {
> 	case MAP_SHARED:
> 	...
> 	/* fall through */
> 	case MAP_PRIVATE:
> 		if (!(file->f_mode & FMODE_READ))
> 			return -EACCES;
> 
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  man2/mmap.2 | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/man2/mmap.2 b/man2/mmap.2
> index c0fd321..b469f84 100644
> --- a/man2/mmap.2
> +++ b/man2/mmap.2
> @@ -393,9 +393,7 @@ is set (probably to
>  .TP
>  .B EACCES
>  A file descriptor refers to a non-regular file.
> -Or
> -.B MAP_PRIVATE
> -was requested, but
> +Or a file mapping was requested, but
>  .I fd
>  is not open for reading.
>  Or
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
