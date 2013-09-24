Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3IXOY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:24:58 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:45150 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3IXOY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:24:57 -0400
Date: Tue, 24 Sep 2013 15:24:53 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: False positive in checkpatch
Message-ID: <20130924142453.GK13914@dm>
References: <20130923225949.GA26278@linux.vnet.ibm.com>
 <1379996467.3575.67.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379996467.3575.67.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 09:21:07PM -0700, Joe Perches wrote:
> On Mon, 2013-09-23 at 15:59 -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > The checkpatch.pl script complains as follows:
> > 
> > ERROR: need consistent spacing around '*' (ctx:WxB)
> > #57: FILE: include/linux/rcupdate.h:564:
> > +		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
> > 
> > Of course, the two uses of '*' are doing different things, so it should
> > be OK for the spacing to be different.
> > 
> > Could you please fix this?
> > 
> > 							Thanx, Paul
> > 
> 
> Hi Paul.
> 
> Try this patch: https://lkml.org/lkml/2013/9/2/428
> 
> Andy?  Can you verify this suggested patch please?

Ok so fundamentally this goes wrong because we detect the typeof()
__force part as a type, but 'space' which is a type subsituted in is not
so identifiable.  This leads to us identifying the '*' as a binary one.

You patch prevents the error being emitted indeed, but as we have
missidentified it anything else which applies to the correct type would
be missed I think.

I will see if I can get this to identify this form better.

-apw
