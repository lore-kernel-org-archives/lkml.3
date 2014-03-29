Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaC2Vbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 17:31:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbaC2Vbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 17:31:31 -0400
Message-ID: <53373BB0.9060403@suse.cz>
Date: Sat, 29 Mar 2014 22:31:28 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        "Yann E . MORIN" <yann.morin.1998@free.fr>,
        Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] scripts: objdiff: detect object code changes between
 two commits
References: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
In-Reply-To: <1395627288-19975-1-git-send-email-jason@lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 24.3.2014 03:14, Jason Cooper napsal(a):
> 
> objdiff can be used in conjunction with a git rebase to confirm that
> each commit made no changes to the resulting object code.  It has the
> same return values as diff(1).

This looks nice. Just a few comments below:


> +# usage example:
> +#
> +# $ git checkout COMMIT_A
> +# $ <your fancy build command here>
> +# $ ./scripts/objdiff record path/to/*.o
> +#
> +# $ git checkout COMMIT_B
> +# $ <your fancy build command here>
> +# $ ./scripts/objdiff record path/to/*.o
> +#
> +# $ ./scripts/objdiff diff COMMIT_A COMMIT_B
> +# $
> +
> +# And to clean up (everything is in /tmp/objdiff-*)
> +# $ ./scripts/objdiff clean all

Can you change it to use some path in the source tree, like .tmp_objdiff
or so? Then you can have make distclean remove it and you can avoid the
fixed paths in /tmp.


> +		# force rebuild
> +		rm -f "$f"

Is this working around some kbuild bug, or is it more a "just in case?"
One usually assumes that "record" is a readonly operation and can be
repeated.

Thanks,
Michal
