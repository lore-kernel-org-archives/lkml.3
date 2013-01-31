Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3AaBFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:05:35 -0500
Received: from tundra.namei.org ([65.99.196.166]:42346 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787Ab3AaBFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:05:33 -0500
Date: Thu, 31 Jan 2013 12:02:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] digsig: Fix memory leakage in digsig_verify_rsa()
In-Reply-To: <CALLzPKai_9SR2pBDe8fU1sGTf+fN=EDGGU1HKQ-LTdWuP0Ti5Q@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1301311201380.24326@tundra.namei.org>
References: <783235259540e27e745f68316b1735e8d4ce9137.1359125652.git.dmitry.kasatkin@intel.com> <CALLzPKai_9SR2pBDe8fU1sGTf+fN=EDGGU1HKQ-LTdWuP0Ti5Q@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the practical impact of this?  Could an attacker kill the machine?


On Wed, 30 Jan 2013, Kasatkin, Dmitry wrote:

> On Fri, Jan 25, 2013 at 4:54 PM, Dmitry Kasatkin
> <dmitry.kasatkin@intel.com> wrote:
> > From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> >
> > digsig_verify_rsa() does not free kmalloc'ed buffer returned by
> > mpi_get_buffer().
> >
> > Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
> > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  lib/digsig.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/lib/digsig.c b/lib/digsig.c
> > index 8c0e629..dc2be7e 100644
> > --- a/lib/digsig.c
> > +++ b/lib/digsig.c
> > @@ -162,6 +162,8 @@ static int digsig_verify_rsa(struct key *key,
> >         memset(out1, 0, head);
> >         memcpy(out1 + head, p, l);
> >
> > +       kfree(p);
> > +
> >         err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
> >         if (err)
> >                 goto err;
> > --
> > 1.7.10.4
> >
> 
> James, can you please apply this patch.
> 
> - Dmitry
> 

-- 
James Morris
<jmorris@namei.org>
