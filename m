Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab3FCMvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:51:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29009 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3FCMu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:50:58 -0400
Date: Mon, 3 Jun 2013 15:50:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/8] pktcdvd: Convert printk to pr_<level>
Message-ID: <20130603125057.GB23987@mwanda>
References: <1369978679.10556.36.camel@joe-AO722>
 <cover.1370048648.git.joe@perches.com>
 <92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
 <20130603095714.GA23987@mwanda>
 <1370260771.2025.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370260771.2025.15.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:59:31AM -0700, Joe Perches wrote:
> On Mon, 2013-06-03 at 12:57 +0300, Dan Carpenter wrote:
> > On Fri, May 31, 2013 at 09:11:23PM -0700, Joe Perches wrote:
> > > +static const char *sense_key_string(__u8 index)
> > > +{
> > > +	static const char *info[9] = {
> > > +		"No sense", "Recovered error", "Not ready",
> > > +		"Medium error", "Hardware error", "Illegal request",
> > > +		"Unit attention", "Data protect", "Blank check"
> > > +	};
> > > +	if (index < 8)
> > 
> > Off by one:
> > 
> > 	if (index < 9)
> 
> Kinda, but that's the original code.
> 
> It should be ARRAY_SIZE and I think it should be
> done in a separate patch.
> 
> Someone should say if "Blank check" is really one
> of the sense key values possible or if it should
> just be deleted.

Read it again.  ;)  In the original code, 8 was valid.

Andy is right though that it should be ARRAY_SIZE().

regards,
dan carpenter

