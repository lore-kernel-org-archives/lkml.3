Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992480AbaEPTw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:52:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46237 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755462AbaEPTw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:52:26 -0400
Message-ID: <1400269941.2221.98.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [lxc-devel] Mount and other notifiers, was: [RFC PATCH 00/11]
 Add support for devtmpfs in user namespaces
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: mhw@WittsEnd.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Pavel Emelianov <xemul@parallels.com>
Date: Fri, 16 May 2014 12:52:21 -0700
In-Reply-To: <1400269360.3540.26.camel@canyon.ip6.wittsend.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com>
	 <1400204545.7699.128.camel@canyon.ip6.wittsend.com>
	 <1400268008.2221.84.camel@dabdike.int.hansenpartnership.com>
	 <1400269360.3540.26.camel@canyon.ip6.wittsend.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-16 at 15:42 -0400, Michael H. Warfield wrote:
> > As an aside (probably requiring a new thread) we were wondering about
> > some type of notifier on the mount call that we could vector into the
> > host to perform the action.  The main issue for us is mount of procfs,
> > which really needs to be a bind mount in a container.  All of this led
> > me to speculate that we could use some type of syscall notifier
> > mechanism to manage capabilities in the host and even intercept and
> > complete the syscall action within the host rather than having to keep
> > evolving more an more complex kernel drivers to do this.
> 
> Interesting.  That could be very useful.  That might even help with the
> loop device case where the mounts have to go through loop devices for
> things like file system images and builds.  Very interesting...

Right, it might even make the loop case go away because now we can
present a dummy device in the container and when the host sees and
attempted mount on this, it just projects a bind mount into the
container and says I've *wink* mounted your "device" for you.

This idea is extremely rough, it came from a conversation I had with
Pavel (cc'd) just before OpenStack about how we might go about
eliminating our OpenVZ interception of the mount system call which
currently does all of this in kernel, so we have no code and no proof
that it's actually feasible (yet).

James


