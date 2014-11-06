Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaKFOob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:44:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaKFOo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:44:29 -0500
Message-ID: <545B894B.90602@suse.cz>
Date: Thu, 06 Nov 2014 15:44:27 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] compiler-gcc*.h: remove inaccurate comment about 'asm
 goto' miscompiles
References: <1414274982-14040-1-git-send-email-steven@uplinklabs.net>
In-Reply-To: <1414274982-14040-1-git-send-email-steven@uplinklabs.net>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2014 12:09 AM, Steven Noonan wrote:
> The bug referenced by the comment in this commit was not completely fixed in
> GCC 4.8.2, as I mentioned in a thread back in February[1]. The conclusion at
> that time was to make the quirk unconditional until the bug could be found and
> fixed in GCC. Unfortunately, when I submitted the patch (commit a9f18034)
> I left a comment in that claimed the bug was fixed in GCC 4.8.2+.  This comment
> is inaccurate, and should be removed.

I believe the original gcc bug was indeed fixed, but there's another bug [1] not
yet fixed, see also [2]. So maybe the new bug number should be added to the
comments?

Vlastimil

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61772
[2] https://lkml.org/lkml/2014/7/10/398

> [1] https://lkml.org/lkml/2014/2/12/797
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  include/linux/compiler-gcc4.h | 1 -
>  include/linux/compiler-gcc5.h | 1 -
>  2 files changed, 2 deletions(-)
> 
> diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
> index 2507fd2..d1a5582 100644
> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -71,7 +71,6 @@
>   *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
>   *
>   * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
> - * Fixed in GCC 4.8.2 and later versions.
>   *
>   * (asm goto is automatically volatile - the naming reflects this.)
>   */
> diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
> index cdd1cc2..c8c5659 100644
> --- a/include/linux/compiler-gcc5.h
> +++ b/include/linux/compiler-gcc5.h
> @@ -53,7 +53,6 @@
>   *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
>   *
>   * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
> - * Fixed in GCC 4.8.2 and later versions.
>   *
>   * (asm goto is automatically volatile - the naming reflects this.)
>   */
> 

