Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbaJ2XlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:41:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbaJ2XlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:41:11 -0400
Date: Wed, 29 Oct 2014 16:40:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org, arnd@arndb.de, tj@kernel.org,
        marcel@holtmann.org, desrt@desrt.ca, hadess@hadess.net,
        dh.herrmann@gmail.com, tixxdz@opendz.org,
        simon.mcvittie@collabora.co.uk, daniel@zonque.org,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        teg@jklm.no
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141029234001.GB16520@kroah.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <alpine.LRH.2.00.1410292354480.11562@twin.jikos.cz>
 <20141029231106.GB16548@kroah.com>
 <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1410300019570.11562@twin.jikos.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:24:02AM +0100, Jiri Kosina wrote:
> On Wed, 29 Oct 2014, Greg Kroah-Hartman wrote:
> 
> > > > kdbus is a kernel-level IPC implementation that aims for resemblance to
> > > > the the protocol layer with the existing userspace D-Bus daemon while
> > > > enabling some features that couldn't be implemented before in userspace.
> > > 
> > > I'd be interested in the features that can't be implemented in userspace 
> > > (and therefore would justify existence of kdbus in the kernel). Could you 
> > > please point me to such list / documentation?
> > 
> > Lennart has given whole talks about this in the past, here's a recent
> > talk going into the details:
> > 	https://www.youtube.com/watch?v=HPbQzm_iz_k
> 
> I think it's a reasonable expectation that kernel patch submissions should 
> be reasonably self-contained though. We've always been very strict about 
> pushing everybody to provide extensive cover letters, changelogs and 
> explanations, so this shouldn't really be an exception, I think.

There is a 1815 line documentation file in this series, so we aren't
trying to not provide this type of information here at all.  But yes,
more background, about why this can't be done in userspace (zero copy,
less context switches, proper credential passing, timestamping, availble
at early-boot, LSM hooks for security models to tie into, race-free
interfaces, container/namespace support, etc.) should be added to the
docs as well.

> > > It seems to me that most of the highlight features from the cover letter 
> > > can be "easily" (for certain definition of that word, of course) 
> > > implemented in userspace (vmsplice(), sending fd through unix socket, user 
> > > namespaces, UUID management, etc).
> > 
> > We have dbus in userspace today, but that requires extra copies of data,
> 
> But we can do zero-copy between processess for quite some time already, so 
> what exactly is the issue here?

See the above list for more details.

We'll work on this for the next round of patches, thanks.

greg k-h
