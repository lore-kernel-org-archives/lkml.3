Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3KGEnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:43:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3KGEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:43:48 -0500
Message-ID: <527AB7D1.9080307@suse.cz>
Date: Wed, 06 Nov 2013 22:42:41 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>
Subject: Re: Kbuild: Ignore GREP_OPTIONS env variable
References: <20131030160635.GE13290@pd.tnic>
In-Reply-To: <20131030160635.GE13290@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 30.10.2013 17:06, Borislav Petkov napsal(a):
> So I had defined GREP_OPTIONS=--color=always on one of my boxes and had
> forgotten about it and the kernel build started failing because we use
> grep quite a while in the tree and it started issuing shell color markup
> which generated garbage files, like the syscall headers on x86, for
> example.
> 
> I have a fix below which seems to take care of it but what is the
> general opinion: Do we want to be more robust against the environment we
> find on a machine before building the kernel or let the user figure it
> out himself that he should be using
> 
> GREP_OPTIONS=--color=auto
> 
> in the first place and it is his own moronic fault if he does 'always'?

I think that on a scale from one to ten, building with
GREP_OPTIONS=--color=always and building with LC_COLLATE=<language with
non-ASCII sorting rules> score about the same. And are already
sanitizing the LC_* variables.


> +GREP_OPTIONS=
> +export GREP_OPTIONS

Just remove it from the enviromnet completely, like the next statement does:

> +
>  # Avoid funny character set dependencies
>  unexport LC_ALL
>  LC_COLLATE=C

Michal

