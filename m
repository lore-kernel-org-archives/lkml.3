Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab3CLKz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:55:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537Ab3CLKzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:55:25 -0400
Date: Tue, 12 Mar 2013 07:55:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312075513.5953751a@redhat.com>
In-Reply-To: <20130312085855.GB5455@pd.tnic>
References: <20121211140108.GC4303@liondog.tnic>
	<20130307095703.03d040ee@redhat.com>
	<20130307130635.GD5239@pd.tnic>
	<20130307110213.7a5a9978@redhat.com>
	<20130309154635.GA18316@pd.tnic>
	<20130311090746.199a4c06@redhat.com>
	<20130311092848.652c0d46@redhat.com>
	<20130312085855.GB5455@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 12 Mar 2013 09:58:55 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Mon, Mar 11, 2013 at 09:28:48AM -0300, Mauro Carvalho Chehab wrote:
> > @@ -740,7 +740,6 @@ struct mem_ctl_info {
> >  	u32 fake_inject_ue;
> >  	u16 fake_inject_count;
> >  #endif
> > -	__u8 csbased : 1,	/* csrow-based memory controller */
> >  	     __resv  : 7;
> 
> I don't know how you tested this one, but it doesn't even build. I fixed
> it up though, while applying.

Funny enough, it compiled on one machine. I noticed this issue when
compiling the Fedora kernel and just dropped the __resv field, that it is
not used anywhere. So, on the Fedora 18 Kernel I pointed, I just dropped both
lines.

Regards,
Mauro

> 
> In file included from arch/x86/kernel/nmi.c:23:0:
> include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
> In file included from arch/x86/kernel/traps.c:44:0:
> include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
> make[2]: *** [arch/x86/kernel/nmi.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> make[2]: *** [arch/x86/kernel/traps.o] Error 1
> make[1]: *** [arch/x86/kernel] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [arch/x86] Error 2
> make: *** Waiting for unfinished jobs....
> In file included from drivers/edac/edac_stub.c:16:0:
> include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
> make[2]: *** [drivers/edac/edac_stub.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> In file included from drivers/edac/amd64_edac.h:72:0,
>                  from drivers/edac/amd64_edac.c:1:
> include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
> In file included from drivers/edac/amd64_edac.h:72:0,
>                  from drivers/edac/amd64_edac_inj.c:1:
> include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
> make[2]: *** [drivers/edac/amd64_edac_inj.o] Error 1
> make[2]: *** [drivers/edac/amd64_edac.o] Error 1
> make[1]: *** [drivers/edac] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> 


-- 

Cheers,
Mauro
