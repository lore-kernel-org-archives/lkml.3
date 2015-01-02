Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbbABVP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:15:29 -0500
Received: from rrcs-76-79-27-186.west.biz.rr.com ([76.79.27.186]:12987 "EHLO
	rrcs-76-79-27-186.west.biz.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751815AbbABVP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:15:27 -0500
Date: Fri, 2 Jan 2015 15:15:21 -0600
From: Jeff Epler <jepler@unpythonic.net>
To: Laurent Georget <laurent.georget@supelec.fr>
Cc: Richard Cochran <richardcochran@gmail.com>,
        linux-man <linux-man@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] adjtimex: PPM scaling is by 2^-16
Message-ID: <20150102211519.GA55815@unpythonic.net>
References: <54A2DEAD.2050708@supelec.fr>
 <20150102024118.GA8293@unpythonic.net>
 <20150102062920.GB4221@localhost.localdomain>
 <54A6C9B5.4050904@supelec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A6C9B5.4050904@supelec.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 05:39:17PM +0100, Laurent Georget wrote:
> +    long freq;        /* Frequency offset, in units of 2^-16 PPM
> +                         (parts per million) (see NOTES below) */
...
> +.SH NOTES
> +In struct
> +.IR timex ,
> +.IR freq ,
> +.IR ppsfreq ,
> +and
> +.I stabil
> +are PPM (parts per million) with a 16-bits fractional part, which means that a
> +value of 1 in one of those fields actually means 2^-16 PPM, and 2^16=65535 is
> +1 PPM. This is the case for both input values (in the case of
> +.IR freq )
> +and output values.

I appreciate the addition of the NOTES section, this is likely to be
unclear to first-time readers and that section should clear it up
nicely.  Giving the definition of PPM as "parts per million" is good
too.

However, the patch got line-wrapped again (I fixed it manually above).
With line-wrapped fix, consider it

Reviewed-by: Jeff Epler <jepler@unpythonic.net>

hm, as a separate issue, "ppm" seems to typically be written in
lowercase.  see e.g., http://en.wikipedia.org/wiki/Parts-per_notation

Jeff
