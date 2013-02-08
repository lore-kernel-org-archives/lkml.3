Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947368Ab3BHXhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:37:04 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64797 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947308Ab3BHXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:37:00 -0500
Date: Fri, 8 Feb 2013 15:36:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: George Spelvin <linux@horizon.com>
Cc: linux-serial@vger.kernel.org, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, giometti@linux.it
Subject: Re: [PATCH 0/7] 3.8-rc regression with pps-ldisc due to 70ece7a731
Message-ID: <20130208233656.GA7700@kroah.com>
References: <cover.1360307140.git.linux@horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360307140.git.linux@horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 02:05:40AM -0500, George Spelvin wrote:
> The standard N_TTY line discipline used to not use the tty->disc_data
> field, so N_PPS felt free to use it.  That has now changed, requiring
> that N_PPS use a different method to find its private data.
> 
> (In the current, buggy, state, N_PPS follows a wild pointer and explodes
> in an interrupt hander as soon as a pulse actually arrives.)
> 
> Strictly speaking, only patches 5 and 6 are the bugfix proper; the
> rest are various cleanups enabled by the looser coupling of the
> line disciplines.

As this is a breakage in 3.8-rc1, is there any way to pull out patches 5
and 6 in a format that I can apply them now, or in a way that I can get
them into 3.8.1 so that this gets fixed?  I can't apply all of these to
3.8-final now, as it's way too late.

thanks,

greg k-h
