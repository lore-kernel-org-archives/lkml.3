Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaCaPbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:31:49 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:56389 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753514AbaCaPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:31:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2904:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: verse43_831e14dc5fa1c
X-Filterd-Recvd-Size: 2436
Message-ID: <1396279898.21529.39.camel@joe-AO722>
Subject: [RFC] quiet checkpatch style recommendation about no spaces around
 bitfield :
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rocco Folino <lordzen87@gmail.com>, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Date: Mon, 31 Mar 2014 08:31:38 -0700
In-Reply-To: <20140331150638.GQ6991@mwanda>
References: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
	 <20140331150638.GQ6991@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 18:06 +0300, Dan Carpenter wrote:
> On Mon, Mar 31, 2014 at 02:34:40PM +0200, Rocco Folino wrote:
> > Fixed bit fields code style issues
[]
> > diff --git a/drivers/staging/octeon-usb/octeon-hcd.h b/drivers/staging/octeon-usb/octeon-hcd.h
[]
> > @@ -143,13 +143,13 @@ union cvmx_usbcx_gahbcfg {
> >  	 *	* 1'b1: Unmask the interrupt assertion to the application.
> >  	 */
> >  	struct cvmx_usbcx_gahbcfg_s {
> > -		uint32_t reserved_9_31	: 23;
> > -		uint32_t ptxfemplvl	: 1;
> > -		uint32_t nptxfemplvl	: 1;
> > -		uint32_t reserved_6_6	: 1;
> > -		uint32_t dmaen		: 1;
> > -		uint32_t hbstlen	: 4;
> > -		uint32_t glblintrmsk	: 1;
> > +		uint32_t reserved_9_31:23;
> > +		uint32_t ptxfemplvl:1;
> > +		uint32_t nptxfemplvl:1;
> > +		uint32_t reserved_6_6:1;
> > +		uint32_t dmaen:1;
> > +		uint32_t hbstlen:4;
> > +		uint32_t glblintrmsk:1;
> >  	} s;
> The warning here is:
> ERROR: spaces prohibited around that ':' (ctx:WxW)
> I have done a kernel wide search for these warnings

Really?  How?

>  and I think we
> should disable this warning.  It has too many false positives like this.

It does seem a bit noisy to me too.

Andy?  Andrew?

>From a treewide checkpatch scan next-20140307:

$ grep "spaces prohibited around that ':' (ctx:WxW)" checkpatch.all | wc -l
11194

I don't see any other uses of that message for
anything other than bitfields.


