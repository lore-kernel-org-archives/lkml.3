Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaLPU6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:58:53 -0500
Received: from smtprelay0046.hostedemail.com ([216.40.44.46]:51418 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750791AbaLPU6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:58:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:967:973:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2525:2560:2563:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4605:4823:5007:6261:7903:8660:8957:9025:9149:9388:10004:10400:10848:10881:11026:11256:11257:11473:11658:11914:12043:12050:12517:12519:12679:12806:13069:13146:13148:13161:13229:13230:13311:13357:13848:14093:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burst61_4d3cab418a04d
X-Filterd-Recvd-Size: 2189
Message-ID: <1418763529.14140.9.camel@perches.com>
Subject: newbies CheckpatchTips for multiline statements (Breaking function
 calls)
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernelnewbies <kernelnewbies@kernelnewbies.org>
Date: Tue, 16 Dec 2014 12:58:49 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kernelnewbies.org/CheckpatchTips

The block about "Breaking function calls" is dubious.

The majority of code today uses arguments aligned to parenthesis.
The suggested 1 tab is in fact very infrequently used.

CodingStyle has this as "substantially to the right", not 1 tab.

btw: there's a perferred/preferred tyop too.

------------

Breaking function calls

Sometimes a call to a function has several variables, and you need to
break the line in the middle of those variables. Look at this example: 

 
        pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN, GFP_KERNEL, &pdata->urb->transfer_dma);


This line is too long, so we want to break it up. By default, vim will
increase the indentation of the trailing line by one tab: 

        pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
                GFP_KERNEL, &pdata->urb->transfer_dma);


This style is fine, and generally perferred. However, some driver
writers prefer to have the trailing line of a function call line up with
the starting '('. They use tabs, followed by spaces, to align the
trailing line: 

 
        pdata->urbdata = usb_alloc_coherent(pdata->udev, ACD_URB_BUFFER_LEN,
                                            GFP_KERNEL,
                                            &pdata->urb->transfer_dma);


Again, the one tab indent style is preferred, but don't change lines
that use the other style. 


