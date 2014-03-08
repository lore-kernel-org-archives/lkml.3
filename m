Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaCHCjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 21:39:32 -0500
Received: from tango.0pointer.de ([85.214.72.216]:33398 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCHCjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 21:39:31 -0500
Date: Sat, 8 Mar 2014 03:39:29 +0100
From: Lennart Poettering <mzerqung@0pointer.de>
To: Lukasz Pawelczyk <havner@gmail.com>
Cc: systemd-devel@lists.freedesktop.org, libvir-list@redhat.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        lxc-devel@lists.linuxcontainers.org
Subject: Re: [systemd-devel] Suspending access to opened/active /dev/nodes
 	during application runtime
Message-ID: <20140308023929.GA1413@tango.0pointer.de>
References: <9D7BA6C9-9F1F-4D09-8F4F-E7DA4720FF97@gmail.com>
 <20140307192410.GA24453@tango.0pointer.de>
 <9E972401-6FA3-439B-9531-49D1FCC8D61D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9E972401-6FA3-439B-9531-49D1FCC8D61D@gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07.03.14 21:51, Lukasz Pawelczyk (havner@gmail.com) wrote:

> >> Problem:
> >> Has anyone thought about a mechanism to limit/remove an access to a
> >> device during an application runtime? Meaning we have an
> >> application that has an open file descriptor to some /dev/node and
> >> depending on *something* it gains or looses the access to it
> >> gracefully (with or without a notification, but without any fatal
> >> consequences).
> > 
> > logind can mute input devices as sessions are switched, to enable
> > unpriviliged X11 and wayland compositors.
> 
> Would you please elaborate on this? Where is this mechanism? How does
> it work without kernel space support? Is there some kernel space
> support I’m not aware of?

There's EVIOCREVOKE for input devices and
DRM_IOCTL_SET_MASTER/DRM_IOCTL_DROP_MASTER for DRM devices. See logind
sources.

> > Before you think about doing something like this, you need to fix the
> > kernel to provide namespaced devices (good luck!)
> 
> Precisly! That’s the generic idea. I’m not for implementing it though
> at this moment. I just wanted to know whether anybody actually though
> about it or maybe someone is interested in starting such a work, etc.

It's not just about turning on and turning off access to the event
stream. It's mostly about enumeration and probing which doesn't work in
containers, and is particularly messy if you intend to share devices
between containers.

> > logind can do this for you between sessions. But such a container setup
> > will never work without proper device namespacing.
> 
> So how can it do it when there is no kernel support? You mean it could
> be doing this if the support were there?

EVIOCREVOKE and the DRM ioctls are pretty real...

Lennart

-- 
Lennart Poettering, Red Hat
