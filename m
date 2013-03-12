Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3CLI7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:59:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46858 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab3CLI67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:58:59 -0400
Date: Tue, 12 Mar 2013 09:58:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] EDAC fixes for 3.8
Message-ID: <20130312085855.GB5455@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-edac <linux-edac@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20121211140108.GC4303@liondog.tnic>
 <20130307095703.03d040ee@redhat.com>
 <20130307130635.GD5239@pd.tnic>
 <20130307110213.7a5a9978@redhat.com>
 <20130309154635.GA18316@pd.tnic>
 <20130311090746.199a4c06@redhat.com>
 <20130311092848.652c0d46@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130311092848.652c0d46@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 09:28:48AM -0300, Mauro Carvalho Chehab wrote:
> @@ -740,7 +740,6 @@ struct mem_ctl_info {
>  	u32 fake_inject_ue;
>  	u16 fake_inject_count;
>  #endif
> -	__u8 csbased : 1,	/* csrow-based memory controller */
>  	     __resv  : 7;

I don't know how you tested this one, but it doesn't even build. I fixed
it up though, while applying.

In file included from arch/x86/kernel/nmi.c:23:0:
include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
In file included from arch/x86/kernel/traps.c:44:0:
include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
make[2]: *** [arch/x86/kernel/nmi.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[2]: *** [arch/x86/kernel/traps.o] Error 1
make[1]: *** [arch/x86/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....
In file included from drivers/edac/edac_stub.c:16:0:
include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
make[2]: *** [drivers/edac/edac_stub.o] Error 1
make[2]: *** Waiting for unfinished jobs....
In file included from drivers/edac/amd64_edac.h:72:0,
                 from drivers/edac/amd64_edac.c:1:
include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
In file included from drivers/edac/amd64_edac.h:72:0,
                 from drivers/edac/amd64_edac_inj.c:1:
include/linux/edac.h:743:7: error: expected specifier-qualifier-list before ‘__resv’
make[2]: *** [drivers/edac/amd64_edac_inj.o] Error 1
make[2]: *** [drivers/edac/amd64_edac.o] Error 1
make[1]: *** [drivers/edac] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
