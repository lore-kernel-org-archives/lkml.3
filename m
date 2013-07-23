Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab3GWXop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:44:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968Ab3GWXon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:44:43 -0400
Date: Tue, 23 Jul 2013 16:44:43 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/6] ldsem patchset, reordered and rebased
Message-ID: <20130723234442.GA27433@kroah.com>
References: <20130603192436.GB22733@kroah.com>
 <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371294291-3807-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 07:04:45AM -0400, Peter Hurley wrote:
> On 06/03/2013 03:24 PM, Greg Kroah-Hartman wrote:> On Mon, May 20, 2013 at 07:38:57PM -0400, Peter Hurley wrote:
> >> On 05/20/2013 07:06 PM, Greg Kroah-Hartman wrote:
> >>> On Mon, May 20, 2013 at 05:44:00PM -0400, Peter Hurley wrote:
> >>>> On 05/20/2013 03:34 PM, Greg Kroah-Hartman wrote:
> >>>>> On Tue, Apr 16, 2013 at 06:15:51AM -0400, Peter Hurley wrote:
> >>>>>> Just as the tty pair must be locked in a stable sequence
> >>>>>> (ie, independent of which is consider the 'other' tty), so must
> >>>>>> the ldisc pair be locked in a stable sequence as well.
> >>>>>>
> >>>>>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> >>>>>> ---
> >>>>>>   drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>>>>>   1 file changed, 87 insertions(+)
> >>>>>
> >>>>> This patch breaks the build :(
> >>>>
> >>>> Sorry about that.
> >>>>
> >>>>> I've taken the first one, care to mush this one with the 7/7 patch, so
> >>>>> there are no build breaks, and resend the 5 resulting patches so I can
> >>>>> apply these?
> >>>>
> >>>> Maybe it would be better to reorder 7/7 to be 1/6, if that's ok?
> >>>> More work for me but the history will be cleaner.
> >>>
> >>> Sure, that works for me as well, care to just resend them?  Or, I can
> >>> dig them out of my archive if needed.
> >>
> >> I'll resend them because the rebase will require some re-editing.
> > 
> > Did you ever resend these?  If so, I didn't see them :(
> 
> Greg,
> 
> Sorry for the delay here. In addition to the re-editing required,
> I merged in a couple of fixes and these needed re-testing.
> 
> These apply cleanly to tty-next.
> 
> Changes from previous 7-patch series:
> 1. In tty_ldisc_ref(), snapshot tty->ldisc holding ldsem.
>    The conditions for this to be a fix cannot actually occur but
>    this is better anyway.
> 2. In tty_set_ldisc(), the new ldisc needs to be released if
>    tty_ldisc_lock_pair_timeout() fails.

Now applied, thanks.

greg k-h
