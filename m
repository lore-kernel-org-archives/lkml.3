Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaEVSu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:50:28 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:40788 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751037AbaEVSu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:50:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwLAH5FflNbsFZY/2dsb2JhbABPCoMHUqpCBQGDOpcBAYEMF3SCJQEBBAEnExwjBQsIAw4KLjkeBhOIOQwBCNZ3EwSFVYcAgRUIXAeEQAEDjz+KMQGTJoM6O4Ex
Date: Thu, 22 May 2014 20:50:24 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Kurt Garloff <garloff@suse.de>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] drivers/scsi/tmscsim.c: replace shift loop by ilog2
Message-Id: <20140522205024.dc969a00070e41a2370eb0fb@skynet.be>
In-Reply-To: <537D6F23.3010704@roeck-us.net>
References: <20140520184809.56d3707440f64e2d9656e3c7@skynet.be>
	<1400605602.26709.11.camel@joe-AO725>
	<20140522002822.GA6446@roeck-us.net>
	<1400720632.11896.7.camel@joe-AO725>
	<537D6F23.3010704@roeck-us.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2014 20:29:39 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> On 05/21/2014 06:03 PM, Joe Perches wrote:
> > On Wed, 2014-05-21 at 17:28 -0700, Guenter Roeck wrote:
> >> On Tue, May 20, 2014 at 10:06:42AM -0700, Joe Perches wrote:
> >>> On Tue, 2014-05-20 at 18:48 +0200, Fabian Frederick wrote:
> >>>> Cc: Kurt Garloff <garloff@suse.de>
> >>>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>>> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> >>>> ---
> >>>>   drivers/scsi/tmscsim.c | 2 +-
> >>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> >>> []
> >>>> @@ -1611,7 +1611,7 @@ dc390_Reselect( struct dc390_acb* pACB )
> >>>>         printk (KERN_ERR "DC390: Reselection must select host adapter: %02x!\n", lun);
> >>>>       else
> >>>>         lun ^= 1 << pACB->pScsiHost->this_id; /* Mask AdapterID */
> >>>> -    id = 0; while (lun >>= 1) id++;
> >>>> +    id = ilog2(lun);
> >>>>       /* Get LUN */
> >>>>       lun = DC390_read8 (ScsiFifo);
> >>>>       if (!(lun & IDENTIFY_BASE)) printk (KERN_ERR "DC390: Resel: Expect identify message!\n");
> >>>
> >>> Hey Fabian.
> >>>
> >>> You've submitted several of these now.
> >>>
> >>> Have you gone through all of these to make sure
> >>> that the ilog2(<foo>) uses are always using a
> >>> non-zero <foo>?
> >>>
> >> Maybe I am missing something. Why not just use fls() ?
> >
> > fls strains Andrew Morton's brain.
> >
> > https://lkml.org/lkml/2014/5/19/771
> >
> 
> :-).
> 
> On the other side fls(1) == 1 while ilog2(1) == 0. So some test is necessary anyway.
> 
> Guenter
> 

I wasn't aware of a problem with 0 value ... I guess we can forget 
conversion here.

Fabian
