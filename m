Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaCaIr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:47:26 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44590 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbaCaIrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:47:22 -0400
Date: Mon, 31 Mar 2014 10:47:16 +0200
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
To: Stewart Smith <stewart@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org, paulus@samba.org,
        anton@samba.org, nfont@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/le: enable RTAS events support
Message-ID: <20140331104716.1385b516@bahia.local>
In-Reply-To: <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
References: <20140328073344.26823.32931.stgit@bahia.local>
	<87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
Organization: IBM
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033108-2966-0000-0000-00000AC1C976
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 09:27:16 +1100
Stewart Smith <stewart@linux.vnet.ibm.com> wrote:
> Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
> >  struct rtas_error_log {
> > +#ifdef __BIG_ENDIAN__
> > +	/* Byte 0 */
> >  	unsigned long version:8;		/* Architectural version */
> > +	/* Byte 1 */
> 
> I think it would be great if we got rid of the usage of bitfields. As
> soon as the mood of the compiler changes, this code is going to break.

True... even though I am not so sure the compiler is likely to break
things in this specific case where no bitfield crosses the byte boundary.
Anyway, Nathan has done some work in the direction you suggest.

Nathan,

Could you send your patch to the list ?

Thanks.

-- 
Gregory Kurz                                     kurzgreg@fr.ibm.com
                                                 gkurz@linux.vnet.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)562 165 496

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

