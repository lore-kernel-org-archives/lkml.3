Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaCCCKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:10:21 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42394 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbaCCCKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:10:06 -0500
X-Originating-IP: 50.43.14.201
Date: Sun, 2 Mar 2014 18:09:55 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] cris: cpuinfo_op should depend on CONFIG_PROC_FS
Message-ID: <20140303020955.GA4902@thin>
References: <1393756479-12530-1-git-send-email-geert@linux-m68k.org>
 <20140303111654.b300a91b38024e3c28811e95@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140303111654.b300a91b38024e3c28811e95@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 11:16:54AM +1100, Stephen Rothwell wrote:
> Hi Geert,
> 
> On Sun,  2 Mar 2014 11:34:39 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > Now allnoconfig started disabling CONFIG_PROC_FS:
> > 
> >     arch/cris/kernel/built-in.o:(.rodata+0xc): undefined reference to `show_cpuinfo'
> >     make: *** [vmlinux] Error 1
> > 
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> 
> Added as a merge fix to (for the akpm-current tree) linux-next from today.
> 
> [rest left here for Andrew and Josh ...]

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> > http://kisskb.ellerman.id.au/kisskb/buildresult/10665698/
> > 
> >  arch/cris/kernel/setup.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
> > index 32c3d248868e..905b70ea9939 100644
> > --- a/arch/cris/kernel/setup.c
> > +++ b/arch/cris/kernel/setup.c
> > @@ -165,6 +165,7 @@ void __init setup_arch(char **cmdline_p)
> >  	strcpy(init_utsname()->machine, cris_machine_name);
> >  }
> >  
> > +#ifdef CONFIG_PROC_FS
> >  static void *c_start(struct seq_file *m, loff_t *pos)
> >  {
> >  	return *pos < nr_cpu_ids ? (void *)(int)(*pos + 1) : NULL;
> > @@ -188,6 +189,7 @@ const struct seq_operations cpuinfo_op = {
> >  	.stop  = c_stop,
> >  	.show  = show_cpuinfo,
> >  };
> > +#endif /* CONFIG_PROC_FS */
> >  
> >  static int __init topology_init(void)
> >  {
> > -- 
> > 1.7.9.5
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


