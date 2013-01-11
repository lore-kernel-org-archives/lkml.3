Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3AKWww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:52:52 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:48189 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754762Ab3AKWwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:52:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMNAOSW8FB5Labi/2dsb2JhbABEhVCyFIYeF3OCHgEBBScTHCMQCAMYCSUPBQ0YAyETiAcDDq5/DYdWFYtjhS4DlDWBVYEdiDGBaoUSgwk
Date: Sat, 12 Jan 2013 09:52:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Abhijit Pawar <abhi.c.pawar@gmail.com>, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH 1/1] fs/xfs remove obsolete simple_strto<foo>
Message-ID: <20130111225246.GO3120@dastard>
References: <1357740282-2377-1-git-send-email-abhi.c.pawar@gmail.com>
 <50EFB2FE.2000307@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EFB2FE.2000307@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 02:36:46PM +0800, Jeff Liu wrote:
> On 01/09/2013 10:04 PM, Abhijit Pawar wrote:
> > This patch replaces usages of obsolete simple_strtoul with kstrtoint in xfs_args and suffix_strtoul.
> > 
> > Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
> > ---
> > +			if (kstrtoint(value, 10, &dswidth))
> > +				return EINVAL;
> >  		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
> >  			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> >  		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
> > 
> checkpatch.pl show warning if we return EINVAL as below:
> WARNING: return of an errno should typically be -ve (return -EINVAL)
> 
> Can we just ignore such code style issue?

Returning a positive error is not a code style issue. It's a
correctness issue. the core of the XFS code returns positive error
numbers as that's the way it was done on Irix (where the XFs code
comes from). The rest of the Linux code tends to use negative values
for error returns, and we've never converted the XFS code base to
negative errors.

You should always feel free to ignore checkpatch warnings that make
no sense. I haven't used checkpatch now for several years - I
stopped using it when it got too noisy warning about uselesss,
trivial things in the XFS code base....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
