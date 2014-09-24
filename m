Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbaIXOOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:14:52 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:34271 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIXOOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:14:51 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 24 Sep 2014 10:14:49 -0400
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-ID: <20140924141449.GA13319@csclub.uwaterloo.ca>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
 <20140924075206.GC5865@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924075206.GC5865@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:52:06AM +0300, Dan Carpenter wrote:
> On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
> > Do we really need the bizarre strncpy padding semantics for anything?
> > Why not just use strlcpy?
> 
> We do need the padding in many places to prevent information leaks.
> 
> So we end up open coding the last NUL after so many of the strncpy()
> calls.  And we're adding more NUL terminators all over the place now
> just to make the code easier to audit.

I think the suggestion to use strlcpy makes sense too.  strlcpy seems
to do exactly what is needed and has a known behaviour already.

-- 
Len Sorensen
