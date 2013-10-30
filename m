Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab3J3TcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:32:09 -0400
Received: from mout.gmx.net ([212.227.17.20]:65352 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab3J3TcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:32:06 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Joe Perches <joe@perches.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH 1/2] tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
Date: Wed, 30 Oct 2013 20:35:36 +0100
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Ashley Lai <ashley@ashleylai.com>, Rajiv Andrade <mail@srajiv.net>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>,
        stable@vger.kernel.org
References: <1383093628-31580-1-git-send-email-peterhuewe@gmx.de> <1383095144.12439.41.camel@joe-AO722>
In-Reply-To: <1383095144.12439.41.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310302035.36579.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:WJy9TWjsBgl280anmr2KPr+8Nux6/XQCsf+tlOiV7c9brgQaGRI
 X7TA2CXIiGE8WqHcbGBWnp3JQV//YeGupEjaJkcORiBRTH8r5G/ZHcHysH8xEQ65BU5PEgi
 H5Oelo+hyUEUV4q55Rz/WynAnWLBReLsLCl5L8g0KMiMCBBYJaNmELsEcHSG7P5fyJUndyg
 rh9J8n3EviY6055IzEVhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe, Jason
> fyi: using
> 	if (strcmp(foo, bar) < 0)
> is canonical.

Yeah of course you're both right - 
    if (strcmp(foo, bar) < 0) 
is the correct version.
Sorry about the rubbish patch.


> lib/string.c:strcmp returns only -1,0,1
> so that's what the arch versions should do too.
> However, arch implementations do vary...

Joe, You are right on this one as well.

I did not pay attention to where cscope did send me 
- it was arch/x86/boot/string.c which implements it as 

        while (*s1 || *s2) {
                delta = *s2 - *s1;
                if (delta)
                        return delta;
                s1++;
                s2++;
        }

Although I know that this is not used here, 
it differs from the version in lib. (Maybe worth changing?)


In anycase 
    if (strcmp(foo, bar) < 0)
is better than
    if (strcmp(foo, bar) == -1)
so I'll resend the patch.

Thanks for reviewing!

Peter

