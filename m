Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3JOKoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 06:44:08 -0400
Received: from ip-196-116.sn1.eutelia.it ([62.94.196.116]:13389 "EHLO
	goldrake.enneenne.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753078Ab3JOKoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 06:44:05 -0400
Date: Tue, 15 Oct 2013 12:43:50 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Chavent <Paul.Chavent@onera.fr>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>
Message-ID: <20131015104350.GI4285@enneenne.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Paul Chavent <Paul.Chavent@onera.fr>, linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@redhat.com>
References: <1381495232-12152-1-git-send-email-paul.chavent@onera.fr>
 <20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131011124720.bf38f18affa8baf0b009875a@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 192.168.32.10
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] pps : add non blocking option to PPS_FETCH ioctl.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on goldrake.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:47:20PM -0700, Andrew Morton wrote:
> On Fri, 11 Oct 2013 14:40:32 +0200 Paul Chavent <Paul.Chavent@onera.fr> wrote:
> 
> > The PPS_FETCH ioctl is blocking still the reception of a PPS
> > event. But, in some case, one may immediately need the last event
> > date. This patch allow to get the result of PPS_FETCH if the device
> > has the O_NONBLOCK flag set.
> 
> Are the PPS ioctls actually documented anywhere? 
> Documentation/pps/pps.txt is silent.
> 
> That's a shame, because it would be nice to have a formal description
> of the the PPS_FETCH semantics which leads to an understanding of why
> things are the way they are, how PPS_FETCH is supposed to be used, etc.
> 
> Also, the presence of such documentation would permit me to bug you for
> not having updated it!  We need *some* channel for telling people about
> the driver, and updates to it.  Maybe linuxpps.org has it somewhere,
> but I couldn't immediately find it.

Hi Andrew! Actually RFC 2783 doesn't use ioctls to get access to PPS
data but it defines some functions. LinuxPPS, that is the Linux PPS
implementation, uses ioctls to implement these functions.

If you like having an idea about how these functions are implemented
into LinuxPPS, you can see here:

   http://www.linuxpps.org/gitweb/?p=pps-tools;a=blob;f=timepps.h;h=d2628d2d061ea2a3623e57990d9ada62623773cf;hb=5980a044bcdb4c1d1a8b1ecff986fa63719519b3

> Your implementation requires that the file be opened non-blocking.  But
> I'd have thought that adding a new and separate ioctl mode would be a
> cleaner and more flexible implementation - that way an app which wants
> both blocking and non-blocking behaviour doesn't need to open the file
> twice.
> 
> Also, this is actually a non-backward-compatible change for any
> application which happened to be opening the file with O_NONBLOCK! 
> Hopefully there aren't any such applications...

The major application that I know using these layer is NTPD... however
all RFC compliant applications should not use ioctls to get access the
PPS data and this patch should be a "special" case.

Thanks for your time,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
