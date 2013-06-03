Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab3FCL7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:59:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34040 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754150Ab3FCL7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:59:32 -0400
Message-ID: <1370260771.2025.15.camel@joe-AO722>
Subject: Re: [PATCH V2 2/8] pktcdvd: Convert printk to pr_<level>
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 03 Jun 2013 04:59:31 -0700
In-Reply-To: <20130603095714.GA23987@mwanda>
References: <1369978679.10556.36.camel@joe-AO722>
	 <cover.1370048648.git.joe@perches.com>
	 <92da9370f91c4435cd62b71998f6d66db8680596.1370048648.git.joe@perches.com>
	 <20130603095714.GA23987@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 12:57 +0300, Dan Carpenter wrote:
> On Fri, May 31, 2013 at 09:11:23PM -0700, Joe Perches wrote:
> > +static const char *sense_key_string(__u8 index)
> > +{
> > +	static const char *info[9] = {
> > +		"No sense", "Recovered error", "Not ready",
> > +		"Medium error", "Hardware error", "Illegal request",
> > +		"Unit attention", "Data protect", "Blank check"
> > +	};
> > +	if (index < 8)
> 
> Off by one:
> 
> 	if (index < 9)

Kinda, but that's the original code.

It should be ARRAY_SIZE and I think it should be
done in a separate patch.

Someone should say if "Blank check" is really one
of the sense key values possible or if it should
just be deleted.


