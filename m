Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069Ab3BMQpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:45:52 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:33298 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775Ab3BMQpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:45:50 -0500
Date: Wed, 13 Feb 2013 08:45:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Spelvin <linux@horizon.com>,
        Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, giometti@linux.it
Subject: Re: [PATCH v2 0/9] 3.8-rc regression with pps-ldisc due to 70ece7a731
Message-ID: <20130213164547.GA8520@kroah.com>
References: <cover.1360677367.git.linux@horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360677367.git.linux@horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 08:56:07AM -0500, George Spelvin wrote:
> The standard N_TTY line discipline used to not use the tty->disc_data
> field, so N_PPS felt free to use it.  That has now changed, requiring
> that N_PPS use a different method to find its private data.
> 
> (In the current, buggy, state, N_PPS follows a wild pointer and explodes
> in an interrupt hander as soon as a pulse actually arrives.)
> 
> Compared to v1, this has been rearranges to the first three patches are
> the minimial bugfixes:
> 
> * 1/9 "Add pps_lookup_dev() function"
>   This adds the infrastructure necessary to bypass disc_data use.
> 
> * 2/9 "Use pps_lookup_dev to reduce ldisc coupling"
>   This actually fixes the bug.
> 
> * 3/9 "Fix a use-after free bug when unregistering a source."
>   This is actually an old bug, present before 3.7.  I'd like to solicit
>   feedback from folks who know device drivers better to ask if I did
>   things right.  I'd also appreciate a look at patch 8/9 which is a more
>   aggressive cleanup of the same bug.

I can take these through my tty tree, but it would be very good if I
actually had the ack from the PPS maintainer...

Rodolfo, any objection for me taking these?

thanks,

greg k-h
