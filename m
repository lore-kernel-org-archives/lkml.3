Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaFQEUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbaFQEUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:20:32 -0400
Date: Tue, 17 Jun 2014 00:20:08 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nicholas Krause <xerofoify@gmail.com>, valentina.manea.m@gmail.com,
        lisa@xenapiadmin.com, ben@decadent.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check if skb_alloc returns Null in function
 fw_download_code
Message-ID: <20140617042008.GA18068@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Nicholas Krause <xerofoify@gmail.com>, valentina.manea.m@gmail.com,
	lisa@xenapiadmin.com, ben@decadent.org.uk,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1402975393-26830-1-git-send-email-xerofoify@gmail.com>
 <20140617040745.GA3648@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617040745.GA3648@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 09:07:45PM -0700, Greg KH wrote:
 > On Mon, Jun 16, 2014 at 11:23:13PM -0400, Nicholas Krause wrote:
 > > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
 > > ---
 > >  drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c | 2 ++
 > >  1 file changed, 2 insertions(+)
 > > 
 > > diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
 > > index 1a95d1f..11e915e 100644
 > > --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
 > > +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
 > > @@ -61,11 +61,13 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
 > >  		}
 > >  
 > >  		skb  = dev_alloc_skb(frag_length + 4);
 > > +		if (!skb) {
 > >  		memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 > >  		tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 > >  		tcb_desc->queue_index = TXCMD_QUEUE;
 > >  		tcb_desc->bCmdOrInit = DESC_PACKET_TYPE_INIT;
 > >  		tcb_desc->bLastIniPkt = bLastIniPkt;
 > > +		}
 > >  
 > 
 > Please run your patches through scripts/checkpatch.pl to find the errors
 > before sending them out and having someone else point them out to you...

I suspect checkpatch would pick up the indentation mess, but
indentation is the least of this patch's problems.

if that alloc_skb fails, going around the loop again is pointless, and
harmful. (we'll oops right below that added bracket).

on failure, this should be returning 0 so that the caller
handles the failure appropriately.

	Dave

