Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3HFVMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:12:00 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60648 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557Ab3HFVL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:11:58 -0400
Date: Tue, 6 Aug 2013 14:11:50 -0700
From: Kees Cook <keescook@chromium.org>
To: Zach Levis <zml@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v3 0/3] fs/binfmts: Improve handling of loops
Message-ID: <20130806211150.GH2280@outflux.net>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
 <1375485703-4077-1-git-send-email-zml@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375485703-4077-1-git-send-email-zml@linux.vnet.ibm.com>
Organization: Chrome OS
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zach,

I like the idea behind these clean ups. Thanks for working on them!

On Fri, Aug 02, 2013 at 04:21:40PM -0700, Zach Levis wrote:
> This v3 is based off Oleg's changes from "exec: more cleanups" and
> "exec: minor cleanups + minor fix"

I would echo all of Oleg's comments on the series so far. Additionally,
please use "scripts/checkpatch.pl" for checking your patches for common
errors (see item 4 in Documentation/SubmittingPatches). I see a number
of problems that are detected by the tool:

WARNING: line over 80 characters
#52: FILE: fs/exec.c:1403:
+               if (retval == -ELOOP && bprm->recursion_depth == 0) { /* cur, previous */

...

ERROR: trailing statements should be on next line
#269: FILE: fs/binfmt_em86.c:70:
+               if (retval < 0) return retval;

...

ERROR: "(foo*)" should be "(foo *)"
#341: FILE: fs/binfmt_flat.c:791:
+       memset((void*)(datapos + data_len), 0, bss_len +

etc.

After that, be sure to use "scripts/get_maintainer.pl" for generating
your CC list (see item 5 in SubmittingPatches; I initially missed this
series -- adding more CCs for people that have touched the code can help
with your reviews).

Also, you only need to include a single Signed-off-by line for
yourself. :)

> It incorporates Oleg and Andrew's suggestions and takes care
> of the issue from Dan's patch "fs/binfmts: double unlock in
> search_binary_handler()"

In the commit message, can you include some examples of how to generate
the loops you're encountering? This helps people understand why you're
doing what you're doing and provides a way for people to reproduce the
conditions themselves.

Thanks,

-Kees

-- 
Kees Cook
Chrome OS Security
