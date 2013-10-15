Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab3JOQzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:55:22 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52294 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab3JOQzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:55:19 -0400
In-Reply-To: <525D6CD4.5090403@c-s.fr>
References: <201310111256.r9BCuepM006243@localhost.localdomain> <OFF3401910.4A8AA6D0-ONC1257C01.0052FC82-C1257C01.00539C55@transmode.se> <525D6CD4.5090403@c-s.fr>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Subject: Re: [PATCH] powerpc 8xx: Fixing memory init issue with CONFIG_PIN_TLB
X-KeepSent: 6759CC56:EB344A53-C1257C05:005CC383;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF6759CC56.EB344A53-ONC1257C05.005CC383-C1257C05.005CF353@transmode.se>
Date: Tue, 15 Oct 2013 18:55:16 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 15/10/2013 18:55:16,
	Serialize complete at 15/10/2013 18:55:16
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

leroy christophe <christophe.leroy@c-s.fr> wrote on 2013/10/15 18:27:00:
> 
> 
> Le 11/10/2013 17:13, Joakim Tjernlund a écrit :
> > "Linuxppc-dev"
> > <linuxppc-dev-bounces+joakim.tjernlund=transmode.se@lists.ozlabs.org>
> > wrote on 2013/10/11 14:56:40:
> >> Activating CONFIG_PIN_TLB allows access to the 24 first Mbytes of 
memory
> > at
> >> bootup instead of 8. It is needed for "big" kernels for instance when
> > activating
> >> CONFIG_LOCKDEP_SUPPORT. This needs to be taken into account in 
init_32
> > too,
> >> otherwise memory allocation soon fails after startup.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> diff -ur linux-3.11.org/arch/powerpc/kernel/head_8xx.S
> > linux-3.11/arch/powerpc/kernel/head_8xx.S
> >> --- linux-3.11.org/arch/powerpc/mm/init_32.c   2013-09-02
> > 22:46:10.000000000 +0200
> >> +++ linux-3.11/arch/powerpc/mm/init_32.c   2013-09-09 
11:28:54.000000000
> > +0200
> >> @@ -213,7 +213,12 @@
> >>       */
> >>      BUG_ON(first_memblock_base != 0);
> >>
> >> +#ifdef CONFIG_PIN_TLB
> >> +   /* 8xx can only access 24MB at the moment */
> >> +   memblock_set_current_limit(min_t(u64, first_memblock_size,
> > 0x01800000));
> >> +#else
> >>      /* 8xx can only access 8MB at the moment */
> >>      memblock_set_current_limit(min_t(u64, first_memblock_size,
> > 0x00800000));
> >> +#endif
> >>   }
> >>   #endif /* CONFIG_8xx */
> > hmm, I think you should always map 24 MB (or less if RAM < 24 MB) and 
do
> > the same
> > in head_8xx.S.
> >
> > Or to keep it simple, just always map at least 16 MB here and in
> > head_8xx.S, assuming
> > that 16 MB is min RAM for any 8xx system running 3.x kernels.
> Yes we could do a more elaborated modification in the future. However it 

> also has an impact on the boot loader, so I'm not sure we should make it 

> the default without thinking twice.
> 
> In the meantime, my patch does take into account the existing situation 
> where you have 8Mb by default and 24Mb when you activate CONFIG_PIN_TLB.
> I see it as a bug fix and I believe we should include it at least in 
> order to allow including in the stable releases.
> 
> Do you see any issue with this approach ?

Not at all, so:
Acked-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
