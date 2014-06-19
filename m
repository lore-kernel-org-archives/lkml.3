Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbaFSUxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:53:13 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:53634 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965016AbaFSUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:53:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3871:3874:3876:4321:4605:5007:7652:8829:9121:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig61_1baee0d611e44
X-Filterd-Recvd-Size: 2058
Message-ID: <1403211188.2753.9.camel@joe-AO725>
Subject: Re: [PATCH] staging: rtl8192 Check for Null return from
 dev_skb_alloc
From: Joe Perches <joe@perches.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, lisa@xenapiadmin.com,
        Valentina Manea <valentina.manea.m@gmail.com>, ben@decadent.org.uk,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Jun 2014 13:53:08 -0700
In-Reply-To: <CAPDOMVhBHa3QqFY+5T+noCxKkffN6Mo0PrN1_1ZRV22RNXUKXg@mail.gmail.com>
References: <1403209102-10633-1-git-send-email-xerofoify@gmail.com>
	 <CAPDOMVhBHa3QqFY+5T+noCxKkffN6Mo0PrN1_1ZRV22RNXUKXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 16:20 -0400, Nick Krause wrote:
> Hey Guys,
> So Sorry about wasting your time with bad patchs.
> I feel bad about that. I hope this patch is O.K.
> now. :(

Oh, one other thing...

> > diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_firmware.c
[]
> > @@ -36,7 +36,6 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
> >                              u32 buffer_len)
> >  {
> >         struct r8192_priv *priv = rtllib_priv(dev);
> > -       bool                rt_status = true;
> >         u16                 frag_threshold;
> >         u16                 frag_length, frag_offset = 0;
> >         int                 i;
[]
> > @@ -99,7 +100,7 @@ static bool fw_download_code(struct net_device *dev, u8 *code_virtual_address,
> >
> >         write_nic_byte(dev, TPPoll, TPPoll_CQ);
> >
> > -       return rt_status;
> > +       return false;

This should be:

	return true;



