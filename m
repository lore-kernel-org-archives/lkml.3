Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbbA2LwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:52:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbbA2LwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:52:22 -0500
Date: Thu, 29 Jan 2015 14:51:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com, thomas@grouk.net,
        rickard_strandqvist@spectrumdigital.se, gregkh@linuxfoundation.org,
        tapaswenipathak@gmail.com, linux-kernel@vger.kernel.org,
        Heba Aamer <heba93aamer@gmail.com>, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH] staging: rtl8712: fix Prefer ether_addr_copy() over
 memcpy()
Message-ID: <20150129115157.GV6456@mwanda>
References: <20150128155325.GA18123@mohammed-Inspiron-3537>
 <54C912E8.5060606@lwfinger.net>
 <20150128213011.GA2294@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150128213011.GA2294@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 11:30:11PM +0200, Aya Mahfouz wrote:
> On Wed, Jan 28, 2015 at 10:48:40AM -0600, Larry Finger wrote:
> > On 01/28/2015 09:53 AM, Heba Aamer wrote:
> > >This patch fixes the following checkpatch.pl warning:
> > >Prefer ether_addr_copy() over memcpy()
> > >if the Ethernet addresses are __aligned(2)
> > >
> > >I used the following coccinelle script:
> > >
> > >@@
> > >expression E1,E2;constant E3;
> > >@@
> > >
> > >- memcpy(E1, E2, E3)
> > >+ ether_addr_copy(E1, E2)
> > >
> > >
> > >pahole showed that the used structs are aligned to u16.
> > 
> > I think you can stop here. The commit message is much too long for a 2-line patch.
> > 
> > BTW, have you tested this patch? In particular, it needs to be tested on an
> > architecture where alignment is important. Using x86 is not sufficient. The
> > reason I ask is that there have been a lot of patches lately that change
> > locking and alignment issues that are only build tested, and have never been
> > tested with real hardware on any platform.
> > 
> > One other thing, checkpatch only suggests that this change should be made.
> > It is certainly not mandatory. As you have not indicated that it has been
> > tested,
> > 
> > NACK
> > 
> > Larry
> >
> Hello Larry,
> 
> Thank you for your patience. Heba has submitted this patch as part
> of a workshop she currently attends. She has checked the alignment
> through pahole and it showed that the variables of complex structs
> are aligned. She has attached the output of pahole, so that the
> community can verify her results and hence the lengthy output.
> 
> She can also cross compile the kernel and verify the output for
> other architectures using pahole. Kindly let us know if this suits
> you. And please name any specific architecture that you would to see
> tested. If this is still not enough from your point of view, let
> us know what should be done further to verify the correctness of
> the patch.
> 

Really, I hate this checkpatch.pl warning, too.  The patches are
difficult to review because you need a lot of context and there is a
small chance that the patch will introduce a bug.

I was the person who introduced the rule that the patch submitter has to
prove the alignment is correct after two people told me basically that,
"The patch submitter's job is to sed the code and the maintainer's job
is to review the code."

In this case we don't really need to use pahole.  "mac" is a 6 byte
char array declared on the stack after a couple of integers.
pnetdev->dev_addr is a pointer.  &pdata[0x12] is a pointer plus an even
offset.  This patch is fine.  But the changelog is too long and has a
lot of not at all relevant output from pahole.

It's not really a practical thing to say that the patch writer has to
cross compile on a different arch.

regards,
dan carpenter

