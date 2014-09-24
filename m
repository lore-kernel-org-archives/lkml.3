Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaIXPmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:42:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45776 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaIXPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:41:56 -0400
Date: Wed, 24 Sep 2014 18:41:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-ID: <20140924154142.GG5865@mwanda>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
 <20140924075206.GC5865@mwanda>
 <20140924143555.GJ28253@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924143555.GJ28253@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:35:55AM -0700, Andi Kleen wrote:
> On Wed, Sep 24, 2014 at 10:52:06AM +0300, Dan Carpenter wrote:
> > On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
> > > On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
> > > > Added a function strzcpy which works the same as strncpy,
> > > > but guaranteed to produce the trailing null character.
> > > 
> > > Do we really need the bizarre strncpy padding semantics for anything?
> > > Why not just use strlcpy?
> > 
> > We do need the padding in many places to prevent information leaks.
> 
> Like where?
> 

You're asking what would break if we switched every strncpy() to
strlcpy() but it's not an easy question to answer.

I've looked a lot at information leaks, but strings are still a blind
spot for my Smatch.  My check only looks at normal variables, arrays.
Eventually I hope to fix this, of course.

I did a git search and Rickard has added some examples, but there were
definitely other places that rely strncpy() padding before.

regards,
dan carpenter

