Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679Ab3HGXaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:30:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56115 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518Ab3HGXat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:30:49 -0400
Message-ID: <5202D8A4.70608@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 16:30:44 -0700
From: Zach Levis <zml@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.3
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com, Zach Levis <zach@zachsthings.com>
Subject: Re: [PATCH v3 0/3] fs/binfmts: Improve handling of loops
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com> <1375485703-4077-1-git-send-email-zml@linux.vnet.ibm.com> <20130806211150.GH2280@outflux.net>
In-Reply-To: <20130806211150.GH2280@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080723-5806-0000-0000-000022581C0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 02:11 PM, Kees Cook wrote:
> Hi Zach,
>
> I like the idea behind these clean ups. Thanks for working on them!
>
> On Fri, Aug 02, 2013 at 04:21:40PM -0700, Zach Levis wrote:
>> This v3 is based off Oleg's changes from "exec: more cleanups" and
>> "exec: minor cleanups + minor fix"
>
> I would echo all of Oleg's comments on the series so far. Additionally,
working on that. v4 will take a little longer since I'm working on some 
more significant changes to make sure I reset all of the possible data 
in the linux_binprm struct and reuse the code from do_execve_common for 
that as much as possible.

> please use "scripts/checkpatch.pl" for checking your patches for common
> errors (see item 4 in Documentation/SubmittingPatches). I see a number
> of problems that are detected by the tool:
>
> WARNING: line over 80 characters
> #52: FILE: fs/exec.c:1403:
> +               if (retval == -ELOOP && bprm->recursion_depth == 0) { /* cur, previous */
>
> ...
>
> ERROR: trailing statements should be on next line
> #269: FILE: fs/binfmt_em86.c:70:
> +               if (retval < 0) return retval;
>
> ...
>
> ERROR: "(foo*)" should be "(foo *)"
> #341: FILE: fs/binfmt_flat.c:791:
> +       memset((void*)(datapos + data_len), 0, bss_len +
>
> etc.
>
will do
> After that, be sure to use "scripts/get_maintainer.pl" for generating
> your CC list (see item 5 in SubmittingPatches; I initially missed this
> series -- adding more CCs for people that have touched the code can help
> with your reviews).
Sorry about that. Will do in the future

>
> Also, you only need to include a single Signed-off-by line for
> yourself. :)
Well, then it seems I'll be sending the next rev from my personal email, 
seeing as I've only got a week and a half left on my internship here 
(and until I lose access to my IBM email).
>
>> It incorporates Oleg and Andrew's suggestions and takes care
>> of the issue from Dan's patch "fs/binfmts: double unlock in
>> search_binary_handler()"
>
> In the commit message, can you include some examples of how to generate
> the loops you're encountering? This helps people understand why you're
> doing what you're doing and provides a way for people to reproduce the
> conditions themselves.
Commit 2/3 has a link to a gist with testcases for the scripts -- I 
stuck them in a gist so they didn't clog up the commit message. If 
there's a way you'd prefer me to reference them let me know.

>
> Thanks,
>
> -Kees
>

