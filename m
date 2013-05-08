Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab3EHRNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:13:00 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60277 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3EHRM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:12:59 -0400
Date: Thu, 9 May 2013 01:12:48 +0800
From: Wang YanQing <udknight@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]TTY: Fix tty can't be restarted by TCXONC ioctl request
Message-ID: <20130508171247.GA6925@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	linux-kernel@vger.kernel.org
References: <20130507184734.GA2459@udknight>
 <20130507185800.GA10713@kroah.com>
 <20130508015545.GA1937@udknight>
 <20130508020200.GA15695@kroah.com>
 <20130508131624.GA1938@udknight>
 <518A6CAF.9020301@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A6CAF.9020301@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:18:07AM -0400, Peter Hurley wrote:
> On 05/08/2013 09:16 AM, Wang YanQing wrote:
> > On Tue, May 07, 2013 at 07:02:00PM -0700, Greg KH wrote:
> >> What about Peter's comments on this patch?
> >>
> > Peter's comments will import policy,
> >
> > I means we should let userspace to decide whether
> > and when to restart tty with the mechanism of TCXONC
> > instead of restart tty accidental when make n_tty_set_termios
> > call.
> 
> There would be no accidental restart. Userspace is specifically
> disabling user-controlled output flow control by clearing
> IXON in termios. Userspace is _expecting_ a 'started' tty.
> 
> If you insist that this must be controllable from userspace,
> then that is already possible:
> 
> 	tcflow(fd, TCOOFF);
> 	tcflow(fd, TCOON);

Indeed you can't do what you said with TCOOFF and TCOON
if you read the codes, that's what this patch fix.

Thanks.
