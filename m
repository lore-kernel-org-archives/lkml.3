Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934849Ab3BTLBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:01:25 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:57696 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933396Ab3BTLBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:01:23 -0500
Message-ID: <1361358077.1341.14.camel@x61.thuisdomein>
Subject: Re: [PATCH] [SCSI] aacraid: silence two GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Date: Wed, 20 Feb 2013 12:01:17 +0100
In-Reply-To: <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
References: <1360440561.1350.27.camel@x61.thuisdomein>
	 <1361356823.2581.43.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2013 11:01:17.0368 (UTC) FILETIME=[9B616380:01CE0F59]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 10:40 +0000, James Bottomley wrote:
> On Sat, 2013-02-09 at 21:09 +0100, Paul Bolle wrote:
> > --- a/drivers/scsi/aacraid/src.c
> > +++ b/drivers/scsi/aacraid/src.c
> > @@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
> >  		fib->hw_fib_va->header.StructType = FIB_MAGIC2;
> >  		fib->hw_fib_va->header.SenderFibAddress = (u32)address;
> >  		fib->hw_fib_va->header.u.TimeStamp = 0;
> > -		BUG_ON((u32)(address >> 32) != 0L);
> > +		BUG_ON(((u64)address >> 32) != 0UL);
> 
> Actually, this isn't the right way to do this.  The correct way would be
> address >> 16 >> 16, but no-one is expected to remember this, so we have
> it macroised in kernel.h as upper_32_bits().
> 
> So this should become
> 
> BUG_ON(upper_32_bits(address) != 0L);

Thanks. I hadn't yet stumbled onto that macro.

> and a similar change for the below.

I hope to send an updated patch shortly.


Paul Bolle

