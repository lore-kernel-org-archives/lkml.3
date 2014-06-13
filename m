Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaFMJrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:47:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46363 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaFMJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:47:01 -0400
Date: Fri, 13 Jun 2014 12:46:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] checkpatch: warn on missing spaces in broken up quoted
 strings
Message-ID: <20140613094651.GF5015@mwanda>
References: <20140613065346.GA28134@mwanda>
 <1402651822.12385.31.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402651822.12385.31.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 02:30:22AM -0700, Joe Perches wrote:

> > +# check for missing a space in a string concatination
> > +        if ($prevrawline =~ /[^\\][a-zA-Z]"$/ && $rawline =~ /^\+[\t ]+"[a-zA-Z]/) {
> > +            WARN('MISSING_SPACE',
> > +                 "break quoted strings at a space character\n" . $hereprev);
> > +        }
> 
> Probably want digits too so maybe \w instead of "[a-zA-Z]/
> 

Changing it to that adds the following 6 new warnings:

./drivers/staging/media/lirc/lirc_zilog.c:806 			    "1) -- please upgrade to a newer driver",
	- bug.

./drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:529 					 "24G_A[%d] = 0x%x\n", i,
./drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c:537 					 "24G_C[%d] = 0x%x\n", i,
	- the "24G_A" is the last 5 characters of a variable name so
	  this is sloppy code.

./drivers/scsi/pm8001/pm8001_ctl.c:297 			       "0x%08x 0x%08x\n",
./drivers/scsi/pm8001/pm8001_ctl.c:432 			       "0x%08x 0x%08x\n",
./drivers/scsi/qla2xxx/qla_nx2.c:1457 	    "0x%X 0x%X 0x%X 0x%X 0x%X 0x%X\n"
	- hex false positives

I thought about doing that when I wrote my original patch but I was
worried about more hex false positives.  If there are only those 3 then
it's probably not a big deal.  What do you think?

regards,
dan carpenter

