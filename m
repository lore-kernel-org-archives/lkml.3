Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3LEXVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:21:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:18149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3LEXVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:21:51 -0500
Date: Fri, 6 Dec 2013 02:21:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Will Tange <bh34rt@gmail.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: silicom: fix 'return is not a function,
 parentheses are not required' in bpctl_mod.c
Message-ID: <20131205232140.GE5443@mwanda>
References: <1386278633-29641-1-git-send-email-bh34rt@gmail.com>
 <20131205225051.GC28413@mwanda>
 <1386284955.10003.20.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386284955.10003.20.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 03:09:15PM -0800, Joe Perches wrote:
> On Fri, 2013-12-06 at 01:50 +0300, Dan Carpenter wrote:
> > On Thu, Dec 05, 2013 at 10:23:53PM +0100, Will Tange wrote:
> > > Fixes warnings regarding redundant parantheses thrown by the checkpatch tool in bpctl_mod.c
> []
> > 	if (ret < 0)
> > 		return BP_NOT_CAP;
> > 	if (ret == 0)
> > 		return 1;
> > 	return 0;
> > 
> > More lines, but simpler to understand than the original.
> > 
> > Think of checkpatch.pl as a pointer to bad code and not that we just
> > have to silence checkpatch and move on.
> 
> So true.
> 
> If 0 is the expected ret value and 1 is the
> expected function return for not-errored use,
> I suggest changing the last bit to:
> 
> 	if (ret < 0)
> 		return BP_NOT_CAP;
> 	else if (ret > 0)
> 		return 0;
> 
> 	return 1;
> 
> so that the error conditions are done first
> and the normal return is at the bottom of
> the function.

In this function, -1 means fail, 1 means "on" and 0 means "off".  I
sorted them from lowest to highest: negative, zero and greater than
zero.

regards,
dan carpenter
