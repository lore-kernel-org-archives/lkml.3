Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaFPGlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 02:41:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26817 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaFPGk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 02:40:59 -0400
Date: Mon, 16 Jun 2014 09:40:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
Message-ID: <20140616064053.GJ5015@mwanda>
References: <20140613065346.GA28134@mwanda>
 <1402651822.12385.31.camel@joe-AO725>
 <20140613094651.GF5015@mwanda>
 <1402689145.4462.13.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402689145.4462.13.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 12:52:25PM -0700, Joe Perches wrote:
> On Fri, 2014-06-13 at 12:46 +0300, Dan Carpenter wrote:
> > On Fri, Jun 13, 2014 at 02:30:22AM -0700, Joe Perches wrote:
> > 
> > > > +# check for missing a space in a string concatination
> > > > +        if ($prevrawline =~ /[^\\][a-zA-Z]"$/ && $rawline =~ /^\+[\t ]+"[a-zA-Z]/) {
> > > > +            WARN('MISSING_SPACE',
> > > > +                 "break quoted strings at a space character\n" . $hereprev);
> > > > +        }
> > > 
> > > Probably want digits too so maybe \w instead of "[a-zA-Z]/
> 
> Couple nits:
> 
> The indentation isn't right here.
> 
> And this check is probably better placed immediately
> after the "SPLIT_STRING" test.
> 
> []
> 
> > ./drivers/scsi/pm8001/pm8001_ctl.c:297 			       "0x%08x 0x%08x\n",
> > ./drivers/scsi/pm8001/pm8001_ctl.c:432 			       "0x%08x 0x%08x\n",
> > ./drivers/scsi/qla2xxx/qla_nx2.c:1457 	    "0x%X 0x%X 0x%X 0x%X 0x%X 0x%X\n"
> > 	- hex false positives
> 
> These look more like defects to me.
> 
> > I thought about doing that when I wrote my original patch but I was
> > worried about more hex false positives.  If there are only those 3 then
> > it's probably not a big deal.  What do you think?
> 
> I know it works on files, but I'm not sure it works on patches.
> 
> What happens when checking a single line replacement patch?
> 
> Likely the \\[a-zA-Z] check should include
> all the tests that the multiple line string exceptions use.
> 
> (?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$

That kind of complicate regex hurts my head.  How do I make it not
complain about:

		"foo\n\t"
		"bar";

regards,
dan carpenter
