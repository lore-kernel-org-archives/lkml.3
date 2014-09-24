Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaIXHwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:52:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24964 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaIXHwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:52:19 -0400
Date: Wed, 24 Sep 2014 10:52:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-ID: <20140924075206.GC5865@mwanda>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140924011753.GG28253@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924011753.GG28253@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 06:17:53PM -0700, Andi Kleen wrote:
> On Wed, Sep 24, 2014 at 12:13:36AM +0200, Rickard Strandqvist wrote:
> > Added a function strzcpy which works the same as strncpy,
> > but guaranteed to produce the trailing null character.
> 
> Do we really need the bizarre strncpy padding semantics for anything?
> Why not just use strlcpy?

We do need the padding in many places to prevent information leaks.

So we end up open coding the last NUL after so many of the strncpy()
calls.  And we're adding more NUL terminators all over the place now
just to make the code easier to audit.

regards,
dan carpenter
