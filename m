Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbbASSbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:31:24 -0500
Received: from mail.sig21.net ([80.244.240.74]:43319 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbbASSar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:30:47 -0500
X-Greylist: delayed 1419 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2015 13:30:47 EST
Date: Mon, 19 Jan 2015 19:06:42 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk,
        teg@jklm.no, jkosina@suse.cz, luto@amacapital.net,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel@zonque.or, dh.herrmann@gmail.com, tixxdz@opendz.org
Subject: Re: [PATCH v3 00/13] Add kdbus implementation
Message-ID: <20150119180642.GA27957@sig21.net>
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-21-Score: -1.0 (-)
X-Spam-21-Report: No, score=-1.0 required=8.0 tests=ALL_TRUSTED=-1,URIBL_BLOCKED=0.001 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg and Daniel,

I don't have a clue so I need to ask some stupid questions...

On Fri, Jan 16, 2015 at 11:16:04AM -0800, Greg Kroah-Hartman wrote:
> kdbus is a kernel-level IPC implementation that aims for resemblance to
> the the protocol layer with the existing userspace D-Bus daemon while
> enabling some features that couldn't be implemented before in userspace.
> 
> The documentation in the first patch in this series explains the
> protocol and the API details.

How about the big picture?

> Reasons why this should be done in the kernel, instead of userspace as
> it is currently done today include the following:
[abbreviated]
> - performance
> - security
> - semantics for apps with heavy data payloads


First of all I wonder about the relationship with D-Bus.
http://dbus.freedesktop.org/doc/dbus-specification.html says:

   D-Bus is designed for two specific use cases:

       A "system bus" for notifications from the system to user
       sessions, and to allow the system to request input from
       user sessions.

       A "session bus" used to implement desktop environments such
       as GNOME and KDE. 

   D-Bus is not intended to be a generic IPC system for any
   possible application, and intentionally omits many features
   found in other IPC systems for this reason. 

Does this also apply to kdbus?  If not, what are the
suggested uses of kdbus beyond those where D-Bus is
currently used?

Another related quote by Havoc Pennington:
http://lists.freedesktop.org/archives/dbus/2012-March/015024.html

   In general, reading this, I think in some cases there are
   problems that make sense to fix in dbus, and in other cases
   there are problems that are best solved by not using dbus.
   ...
   there are about 10000 IPC solutions already, from ICE (both of
   them) to ZeroMQ to AMQP to CORBA to X11 to HTTP to SOAP to
   WebSockets to SUN-RPC to whatever-the-heck. To me, trying to
   make dbus configurable so that it can substitute for any of
   these is a Bad Idea (tm).

Do you think it also applies to kdbus?


Wrt the performance improvement achieved by kdbus, my impression
about D-Bus is that the number of messages on my system is
about a dozen per minute.  Are there actually any existing
applications using D-Bus that have a performance issue?
Or is this only about future possible uses?


Linked from http://kroah.com/log/blog/2014/01/15/kdbus-details/,
http://lwn.net/Articles/580194/ "The unveiling of kdbus" says:

   Unlike most other kernels, Linux has never had a well-designed
   IPC mechanism. Windows and Mac OS have this feature; even
   Android, based on Linux, has one in the form of the "binder"
   subsystem. Linux, instead, has only had the primitives —
   sockets, FIFOs, and shared memory — but those have never been
   knitted together into a reasonable application-level API. Kdbus
   is an attempt to do that knitting and create something that is
   at least as good as the mechanisms found on other systems.

These are bold words. I'm not sure what Windows and Mac OS
have in terms of IPC, but the above suggests that kdbus
is *the* new Linux IPC that everyone will use for everything,
rather than a special purpose facility.
True?


Thanks,
Johannes
