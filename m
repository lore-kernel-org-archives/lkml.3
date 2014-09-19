Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbaISPqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:46:47 -0400
Received: from gw1.transmode.se ([195.58.98.146]:64785 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbaISPqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:46:45 -0400
In-Reply-To: <20140919135756.A060D1AB26D@localhost.localdomain>
References: <20140919135756.A060D1AB26D@localhost.localdomain>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>, scottwood@freescale.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] powerpc32: add support for csum_add()
X-KeepSent: 808E087E:AC49C5B7-C1257D58:0055AC30;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Message-ID: <OF808E087E.AC49C5B7-ONC1257D58.0055AC30-C1257D58.0056ACBD@transmode.se>
Date: Fri, 19 Sep 2014 17:46:42 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.3FP6|November 21, 2013) at
 19/09/2014 17:46:43,
	Serialize complete at 19/09/2014 17:46:43
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Leroy <christophe.leroy@c-s.fr> wrote on 2014/09/19 15:57:56:

> +#define HAVE_ARCH_CSUM_ADD
> +static inline __wsum csum_add(__wsum csum, __wsum addend)
> +{
> +    __asm__("\n\
> +   addc %0,%0,%1 \n\
> +   addze %0,%0 \n\
> +   "
> +   : "=r" (csum)
> +   : "r" (addend), "0"(csum));

hmm, I wonder if not this is better written as:
: "+r" (csum): "r" (addend))

  Jocke
