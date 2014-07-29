Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbaG2Xo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:44:29 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35253 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaG2Xo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:44:28 -0400
Date: Tue, 29 Jul 2014 16:44:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
In-Reply-To: <1406675255.12100.22.camel@joe-AO725>
Message-ID: <alpine.DEB.2.02.1407291641580.961@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic> <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
 <1406675255.12100.22.camel@joe-AO725>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Joe Perches wrote:

> Maybe yet another vsprintf extension?
> 
> Maybe %pH<vartype> where vartype is one of [hh, h, u, ul, ull]
> with something like
> 	u64 t1 = (u64)*(appropriate cast)vartype;
> 	u64 t2 = t1;
> 	int index = 0;
> 	while ((t1 >>= 10)) {
> 		index++;
> 		t2 >>= 10;
> 	}
> 	
> to output the equivalent of
> 	%llu%s, t2, "bkmgtpezy"[index]
> ala dump_pagetables
> 

Prarit has a good point about unnecessarily rounding the value, which is 
exactly what the patch is addressing, and it wouldn't be good to be 
changing the units depending on the value if anybody is using it for 
anything other than reading it with their own two eyes.  Since 
EFI_PAGE_SIZE will always be in KB, it makes sense to export it in KB.
