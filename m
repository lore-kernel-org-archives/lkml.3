Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaCGTHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:07:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43143 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaCGTHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:07:53 -0500
Date: Fri, 7 Mar 2014 11:09:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lukasz Pawelczyk <havner@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, lxc-devel@lists.linuxcontainers.org,
        systemd-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [systemd-devel] Suspending access to opened/active /dev/nodes
 during application runtime
Message-ID: <20140307190939.GA8082@kroah.com>
References: <E7B2439D-FF36-4353-8E1A-C58E5C33A89F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E7B2439D-FF36-4353-8E1A-C58E5C33A89F@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 07:46:44PM +0100, Lukasz Pawelczyk wrote:
> Problem:
> Has anyone thought about a mechanism to limit/remove an access to a
> device during an application runtime? Meaning we have an application
> that has an open file descriptor to some /dev/node and depending on
> *something* it gains or looses the access to it gracefully (with or
> without a notification, but without any fatal consequences).
> 
> Example:
> LXC. Imagine we have 2 separate containers. Both running full operating
> systems. Specifically with 2 X servers. Both running concurrently of
> course. Both need the same input devices (e.g. we have just one mouse).

Stop right there.

If they "both" need an input device, then they should use the "shared"
input device stream, i.e. evdev.

And it goes the same for every type of device the kernel is exposing to
userspace, if you want to "share" them, then you need to work on
changing the kernel to be able to handle shared devices.

And odds are, you will get back a big "as-if" comment from the kernel
developers, as for almost all devices, they can't be shared, for very
good reasons.

So work down the list of devices you really need access to, and either
work to provide a way for the kernel to mediate them, or, work to only
have one "container" access to one device, and not have all containers
access to it at the same time.

This has been discussed many times in the past, on mailing lists and in
person at the Linux Plumbers conference last year.  This isn't a systemd
issue, it is a "you are using the kernel in ways it was not designed to
be used" issue.

good luck, you will need it...

greg k-h
