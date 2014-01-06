Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaAFTcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:32:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:6633 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754517AbaAFTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:32:09 -0500
Date: Mon, 6 Jan 2014 14:32:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: mmarek <mmarek@suse.cz>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Yang Bai <hamo.by@gmail.com>
Subject: Re: [PATCH] scripts: Have make TAGS not include structure members
Message-ID: <20140106143200.207ab91c@gandalf.local.home>
In-Reply-To: <20140103132432.GA32469@sepie.suse.cz>
References: <20131115093645.6dc03918@gandalf.local.home>
	<CAMuHMdXSBSOkfd2MGbn=rpXQRZYw5TKLsR=3SoeSyrcD2CzunA@mail.gmail.com>
	<20131119155907.11fbdecea0aa40764a3d927a@linux-foundation.org>
	<20131119190426.27b010e4@gandalf.local.home>
	<20131119160855.2527630f87d060801d9ee3bb@linux-foundation.org>
	<20131119191435.4dce1499@gandalf.local.home>
	<528BFFBF.4050807@codeaurora.org>
	<20131119193414.48912cbd@gandalf.local.home>
	<20140103132432.GA32469@sepie.suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014 14:24:32 +0100
mmarek <mmarek@suse.cz> wrote:


> 
> The logic looks OK, but it is not completely obvious that $@ means

Hmm, it $@ is standard shell variable of "all commands". In fact, we
probably should change all the $1 to that instead. But I don't care how
we do it.

> 'etags --no-members, iff called as etags'. How about using a more
> descriptive variable like this?
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 58c4559..3afc479 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -219,7 +219,7 @@ exuberant()
>  
>  emacs()
>  {
> -	all_target_sources | xargs $1 -a                        \
> +	all_target_sources | xargs $1 $no_members -a            \
>  	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
>  	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
>  	--regex='/^TRACE_EVENT(\([^,)]*\).*/trace_\1/'		\
> @@ -308,12 +308,15 @@ case "$1" in
>  
>  	"tags")
>  		rm -f tags
> +		no_members=
>  		xtags ctags
>  		remove_structs=y
>  		;;
>  
>  	"TAGS")
>  		rm -f TAGS
> +		# Do not index struct members when generating Emacs TAGS
> +		no_members=--no-members
>  		xtags etags

Sure, I'll update this and send another patch.

Thanks,

-- Steve

