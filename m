Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaCGUxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:53:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43746 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaCGUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:53:53 -0500
Date: Fri, 7 Mar 2014 12:55:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lukasz Pawelczyk <havner@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, lxc-devel@lists.linuxcontainers.org,
        systemd-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [systemd-devel] Suspending access to opened/active /dev/nodes
 during application runtime
Message-ID: <20140307205540.GA6354@kroah.com>
References: <E7B2439D-FF36-4353-8E1A-C58E5C33A89F@gmail.com>
 <20140307190939.GA8082@kroah.com>
 <93871091-7845-4BCC-A841-F724BEDF6E4B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93871091-7845-4BCC-A841-F724BEDF6E4B@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 09:45:28PM +0100, Lukasz Pawelczyk wrote:
> 
> On 7 Mar 2014, at 20:09, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Mar 07, 2014 at 07:46:44PM +0100, Lukasz Pawelczyk wrote:
> >> Problem:
> >> Has anyone thought about a mechanism to limit/remove an access to a
> >> device during an application runtime? Meaning we have an application
> >> that has an open file descriptor to some /dev/node and depending on
> >> *something* it gains or looses the access to it gracefully (with or
> >> without a notification, but without any fatal consequences).
> >> 
> >> Example:
> >> LXC. Imagine we have 2 separate containers. Both running full operating
> >> systems. Specifically with 2 X servers. Both running concurrently of
> >> course. Both need the same input devices (e.g. we have just one mouse).
> > 
> > Stop right there.
> > 
> > If they "both" need an input device, then they should use the "shared"
> > input device stream, i.e. evdev.
> > 
> > And it goes the same for every type of device the kernel is exposing to
> > userspace, if you want to "share" them, then you need to work on
> > changing the kernel to be able to handle shared devices.
> 
> I think you might have misunderstood me. They are using a shared input
> stream (evdev in this case). The problem is I don’t want them to
> eavesdrop on each other. So it’s not about making it to work. It’s
> about making them to work „in turns”.

See Lennart's comment about namespaces for devices, and how the kernel
doesn't support it, for the answer to this.

Sorry, not going to happen, use real virtual machines if you want to do
this.

greg k-h
