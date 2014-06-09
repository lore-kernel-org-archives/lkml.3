Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbaFIVVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:21:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaFIVVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:21:17 -0400
Message-ID: <5396254B.8070907@suse.cz>
Date: Mon, 09 Jun 2014 23:21:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Guido_G=FCnther?= <agx@sigxcpu.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genksyms: Include scripts/Makefile.lib
References: <20140523131522.GA25950@bogon.m.sigxcpu.org>
In-Reply-To: <20140523131522.GA25950@bogon.m.sigxcpu.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 23.5.2014 15:15, Guido Günther napsal(a):
> Otherwise when building out of tree like
> 
> make V=1 O=/var/scratch/kernel/
> 
> it fails like
> 
> make -f /home/agx/linux/scripts/Makefile.build obj=scripts
> make -f /home/agx/linux/scripts/Makefile.build obj=scripts/genksyms
> (cat /dev/null; ) > scripts/genksyms/modules.order
>   gcc -Wp,-MD,scripts/genksyms/.lex.lex.o.d -Iscripts/genksyms -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer  -I/home/agx/linux/scripts/genksyms -Iscripts/genksyms -c -o scripts/genksyms/lex.lex.o scripts/genksyms/lex.lex.c
> scripts/genksyms/lex.lex.c_shipped:567:23: fatal error: parse.tab.h: No such file or directory
> compilation terminated.
> scripts/Makefile.host:134: recipe for target 'scripts/genksyms/lex.lex.o' failed
> make[3]: *** [scripts/genksyms/lex.lex.o] Error 1
> /home/agx/linux/scripts/Makefile.build:465: recipe for target 'scripts/genksyms' failed
> make[2]: *** [scripts/genksyms] Error 2
> /home/agx/linux/Makefile:542: recipe for target 'scripts' failed
> 
> Signed-off-by: Guido Günther <agx@sigxcpu.org>
> ---
> 
> I'm not sure wether this is the root cause and would be happy any
> input on where to dig. GNU make is version 4.0.
> 
>  scripts/genksyms/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/scripts/genksyms/Makefile b/scripts/genksyms/Makefile
> index aca33b9..1d86d14 100644
> --- a/scripts/genksyms/Makefile
> +++ b/scripts/genksyms/Makefile
> @@ -1,3 +1,4 @@
> +include scripts/Makefile.lib
>  
>  hostprogs-y	:= genksyms
>  always		:= $(hostprogs-y)

scripts/Makefile.lib is included by the Makefile that includes
scripts/genksyms/Makefile. So this is certainly not the right fix. With
which kernel version are you seeing this and what are the exact steps to
reproduce? Also please attach the full log leading to the failure.
Needless to say, I can't reproduce it.

Thanks,
Michal

