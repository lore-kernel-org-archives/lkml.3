Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaCLSWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:22:42 -0400
Received: from smtprelay0209.hostedemail.com ([216.40.44.209]:56347 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752740AbaCLSWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:22:40 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2110:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:3870:3871:3872:3874:4321:5007:7652:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12555:12740:13069:13071:13255:13311:13357:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: class96_50da839256b46
X-Filterd-Recvd-Size: 2196
Message-ID: <1394648554.3915.22.camel@joe-AO722>
Subject: Re: [PATCH V2 bluetooth-next 2/6] bluetooth: Convert uses of
 __constant_<foo> to <foo>
From: Joe Perches <joe@perches.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Network Development <netdev@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "bluez mailin list (linux-bluetooth@vger.kernel.org)" 
	<linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 12 Mar 2014 11:22:34 -0700
In-Reply-To: <34E193D0-F15B-4C23-83F7-697096916D4D@holtmann.org>
References: <cover.1394643455.git.joe@perches.com>
	 <51892631f2289665bf47b294c783ee9560a8317e.1394643455.git.joe@perches.com>
	 <F2E9571C-2D55-4529-A361-D8CD4B3FC491@holtmann.org>
	 <1394646755.3915.8.camel@joe-AO722>
	 <34E193D0-F15B-4C23-83F7-697096916D4D@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 11:11 -0700, Marcel Holtmann wrote:

> > 	/* Connection accept timeout ~20 secs */
> > -	param = __constant_cpu_to_le16(0x7d00);
> > +	param = cpu_to_le16(0x7d00);
> > 
> > 0x7d00 is 32000, presumably that's 32 seconds.
> 
> so it is 0x7d00 * 0.625 which results in 20 seconds.

Hi again Marcel.

Swell.  No worries then.

Is this clocking divisor defined somewhere?
Is .625 or 5/8 as a magic number defined somewhere?
(I didn't see it in a brief scan)
Maybe it'd be better to use 20000 * 5 / 8 or
add some define like

#define msecs_to_bt_clocks(ms) ((ms) * 5 / 8)

> > and
> > 		/* 160 msec page scan interval */
> > -		acp.interval = __constant_cpu_to_le16(0x0100);
> > +		acp.interval = cpu_to_le16(0x0100);
> > 256 msecs?
> 
> also here 0x0100 * 0.625 resulting in 160 msecs.

Same as above.

> patch has been applied to bluetooth-next tree.

cheers, Joe

