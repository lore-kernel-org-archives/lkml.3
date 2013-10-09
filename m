Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3JIIDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:03:18 -0400
Received: from mail.abilis.ch ([195.70.19.74]:15472 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3JIIDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:03:09 -0400
Date: Wed, 9 Oct 2013 10:02:41 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] Add option to disable kernel compression
Message-ID: <20131009080240.GA3721@ab42.lan>
References: <2065777.DKEM6dSyjc@ws-stein>
 <1381235612-23988-1-git-send-email-christian.ruppert@abilis.com>
 <20131008122940.63aae6f1769a162eb8e5e602@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008122940.63aae6f1769a162eb8e5e602@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 12:29:40PM -0700, Andrew Morton wrote:
> On Tue,  8 Oct 2013 14:33:32 +0200 Christian Ruppert <christian.ruppert@abilis.com> wrote:
> 
> > Until now, kernel compression can only be disabled by deselecting
> > HAVE_<compression> in the architecture Kconfig.
> 
> Scratching my head a bit.  There's no way of deselecting these things. 
> I *think* you mean "by editing arch/xxx/Kconfig and removing all the
> "select HAVE_KERNEL_<compression>" lines"?

Exactly. I actually meant "not selecting" instead of deselecting. In
practise this comes down to editing arch/xxx/Kconfig and removing (or
adding) the respective HAVE_KERNEL_<compression> lines.

> > However, some
> > users/platforms within the same architecture might want to use
> > compression while others might want to disable it.
> 
> Why would anyone want to run an uncompressed kernel, btw?  Boot time?

Originally, the patch was developed because we wanted to compress the
kernel but other users of the ARC architecture didn't. We now have
customers of both camps ourselves, some say they can boot faster with
compression and some say they can boot faster without compression. This
probably depends on things like the FLASH chip they use etc.

> > This patch is a solution to the dilemma.
> > 
> > ...
> >
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -118,7 +118,6 @@ config HAVE_KERNEL_LZ4
> >  choice
> >  	prompt "Kernel compression mode"
> >  	default KERNEL_GZIP
> > -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
> >  	help
> >  	  The linux kernel is a kind of self-extracting executable.
> >  	  Several compression algorithms are available, which differ
> > @@ -137,6 +136,13 @@ choice
> >  
> >  	  If in doubt, select 'gzip'
> >  
> > +config KERNEL_UNCOMPRESSED
> > +	bool "No compression"
> > +	help
> > +	  No compression at all. The kernel is huge but the compression and
> > +	  decompression times are zero.
> > +	  This is usually not what you want.
> > +
> >  config KERNEL_GZIP
> >  	bool "Gzip"
> >  	depends on HAVE_KERNEL_GZIP
> 
> It's odd to create CONFIG_KERNEL_UNCOMPRESSED and not use it for
> anything, but I guess Kconfig's `choice' forces this.

I haven't found another way to do this but I'd be happy to send an
update if someone can point me to a cleaner implementation.

Greetings,
  Christian
