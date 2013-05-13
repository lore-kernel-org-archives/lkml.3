Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3EMVhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:37:05 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37513 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3EMVhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:02 -0400
Date: Mon, 13 May 2013 14:36:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <thornber@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/2] dmcache: Implement a flush message
Message-ID: <20130513213657.GA8043@blackbox.djwong.org>
References: <20130508214845.GA7729@blackbox.djwong.org>
 <20130508220526.GA24132@redhat.com>
 <20130509203616.GA5713@blackbox.djwong.org>
 <20130509204751.GB5712@blackbox.djwong.org>
 <20130510102224.GF20880@debian>
 <20130510175149.GC5712@blackbox.djwong.org>
 <20130511152523.GA18988@redhat.com>
 <5190D6B8.7020905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5190D6B8.7020905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 02:04:08PM +0200, Peter Rajnoha wrote:
> On 11.05.2013 17:25, Mike Snitzer wrote:> On Fri, May 10 2013 at  1:51pm
> -0400,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> ...
> >> afaict, there isn't anything in the initscripts that tears down dm
> devices
> >> prior to invoking reboot(), and the kernel drivers don't have reboot
> notifiers
> >> to flush things out either.  I've been told that lvm does this, but I
> don't see
> >> anything in the Ubuntu or RHEL6 that would suggest a teardown script...
> >
> > See:
> https://git.fedorahosted.org/cgit/lvm2.git/commit/?id=c698ee14bbb1310cf2383c8977d14a8e29139f8c
> >
> > But I'm not sure which distros have hooked blkdeactivate in (cc'ing
> > prajnoha for his insight).
> >
> 
> The blk-availability initscript/systemd unit that gets called at
> shutdown/reboot and which in turn calls the blkdeactivate is already
> used in RHEL 6.4 onwards and also in Fedora 18 onwards. However, for
> Fedora, you need to enable the systemd unit explicitly at the moment
> (systemctl enable blk-availability.service). To have it enabled by
> default, the distro-wide default systemd configuration needs to be
> edited which is controlled by systemd-preset file (I hope F19 is going
> to have this enabled by default finally).
> 
> As for any other distros, it's up to the maintainers in that distro to
> make use of the new script - I haven't looked if they started using it
> or not. But upstream already provides it since lvm2 v2.02.98.

Aha!  Thank you for providing the missing link.  Now it all makes sense. :)

(fwiw Ubuntu's latest is 2.02.95.)

--D
> 
> Peter
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
