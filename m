Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaJWBLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 21:11:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:64764 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750928AbaJWBLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 21:11:30 -0400
Date: Wed, 22 Oct 2014 21:11:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Marek <mmarek@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        Peter Foley <pefoley2@pefoley.com>, linux-kbuild@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kbuild: Fix output of make kernelrelease
Message-ID: <20141022211115.576b0053@gandalf.local.home>
In-Reply-To: <20141022194408.GA20989@pobox.suse.cz>
References: <20141022101944.70d637cc@gandalf.local.home>
	<20141022194408.GA20989@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 21:44:08 +0200
Michal Marek <mmarek@suse.cz> wrote:

> Dne 22.10.2014 v 16:19 Steven Rostedt napsal(a):
> > 
> > Commit 7ff525712acf "kbuild: fake the "Entering directory ..." message
> > more simply" changed the output of "make kernelrelease" such that the
> > kernel release version was not the last line printed. This broke various
> > tools that would find the kernel release with "make kernelrelease | tail -1".
> 
> The cleaner and recommended (see recent make help) way is to use make -s:
> 
> $ make O=build -s kernelrelease
> 3.18.0-rc1+
> 
> no further processing is needed.


I don't mind changing my script with your patch. But this does break
other scripts of mine that I need to hunt down and change. My fear is
why do we need the '-s' when there may be other methods to preserve the
old functionality.

If this is breaking my scripts, I wonder if it is also breaking other
scripts out there too? As you stated, it wasn't until recently that the
help message recommended the '-s'.

-- Steve


> 
> 
> > One of those tools that broke was ktest.pl which resides in the kernel.
> 
> Can you please apply this patch?
> 
> Thanks,
> Michal
> 
> >From c660b235e25eee053337e0e6c952e87f39839c63 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Wed, 22 Oct 2014 21:25:39 +0200
> Subject: [PATCH] ktest: Use make -s kernelrelease
> 
> The previous tail -1 broke with commit 7ff525712acf ("kbuild: fake the
> "Entering directory ..." message more simply")
> 
> Reported-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  tools/testing/ktest/ktest.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> index bf13981..60fe020 100755
> --- a/tools/testing/ktest/ktest.pl
> +++ b/tools/testing/ktest/ktest.pl
> @@ -2005,7 +2005,7 @@ sub get_version {
>      # get the release name
>      return if ($have_version);
>      doprint "$make kernelrelease ... ";
> -    $version = `$make kernelrelease | tail -1`;
> +    $version = `$make -s kernelrelease`;
>      chomp($version);
>      doprint "$version\n";
>      $have_version = 1;

