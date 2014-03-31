Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaCaU4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:56:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbaCaU4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:56:30 -0400
Date: Mon, 31 Mar 2014 13:56:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Rocco Folino <lordzen87@gmail.com>, aaro.koskinen@iki.fi,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [RFC] quiet checkpatch style recommendation about no spaces
 around bitfield :
Message-Id: <20140331135628.d8eb8bea432d509835710202@linux-foundation.org>
In-Reply-To: <1396279898.21529.39.camel@joe-AO722>
References: <1396269280-32665-1-git-send-email-lordzen87@gmail.com>
	<20140331150638.GQ6991@mwanda>
	<1396279898.21529.39.camel@joe-AO722>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 08:31:38 -0700 Joe Perches <joe@perches.com> wrote:

> > > @@ -143,13 +143,13 @@ union cvmx_usbcx_gahbcfg {
> > >  	 *	* 1'b1: Unmask the interrupt assertion to the application.
> > >  	 */
> > >  	struct cvmx_usbcx_gahbcfg_s {
> > > -		uint32_t reserved_9_31	: 23;
> > > -		uint32_t ptxfemplvl	: 1;
> > > -		uint32_t nptxfemplvl	: 1;
> > > -		uint32_t reserved_6_6	: 1;
> > > -		uint32_t dmaen		: 1;
> > > -		uint32_t hbstlen	: 4;
> > > -		uint32_t glblintrmsk	: 1;
> > > +		uint32_t reserved_9_31:23;
> > > +		uint32_t ptxfemplvl:1;
> > > +		uint32_t nptxfemplvl:1;
> > > +		uint32_t reserved_6_6:1;
> > > +		uint32_t dmaen:1;
> > > +		uint32_t hbstlen:4;
> > > +		uint32_t glblintrmsk:1;
> > >  	} s;
> > The warning here is:
> > ERROR: spaces prohibited around that ':' (ctx:WxW)
> > I have done a kernel wide search for these warnings
> 
> Really?  How?
> 
> >  and I think we
> > should disable this warning.  It has too many false positives like this.
> 
> It does seem a bit noisy to me too.
> 
> Andy?  Andrew?

I suspect we don't use bitfields enough for a particular style to have
emerged.  Personally I think the above patch made the code harder to
read, so...
