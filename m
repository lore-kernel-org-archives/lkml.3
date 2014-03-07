Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaCGUpl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:45:41 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59838 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaCGUpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:45:39 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [systemd-devel] Suspending access to opened/active /dev/nodes during application runtime
From: Lukasz Pawelczyk <havner@gmail.com>
In-Reply-To: <20140307190939.GA8082@kroah.com>
Date: Fri, 7 Mar 2014 21:45:28 +0100
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        libvir-list@redhat.com, lxc-devel@lists.linuxcontainers.org,
        systemd-devel@lists.freedesktop.org,
        David Herrmann <dh.herrmann@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <93871091-7845-4BCC-A841-F724BEDF6E4B@gmail.com>
References: <E7B2439D-FF36-4353-8E1A-C58E5C33A89F@gmail.com> <20140307190939.GA8082@kroah.com>
To: Greg KH <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 7 Mar 2014, at 20:09, Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Mar 07, 2014 at 07:46:44PM +0100, Lukasz Pawelczyk wrote:
>> Problem:
>> Has anyone thought about a mechanism to limit/remove an access to a
>> device during an application runtime? Meaning we have an application
>> that has an open file descriptor to some /dev/node and depending on
>> *something* it gains or looses the access to it gracefully (with or
>> without a notification, but without any fatal consequences).
>> 
>> Example:
>> LXC. Imagine we have 2 separate containers. Both running full operating
>> systems. Specifically with 2 X servers. Both running concurrently of
>> course. Both need the same input devices (e.g. we have just one mouse).
> 
> Stop right there.
> 
> If they "both" need an input device, then they should use the "shared"
> input device stream, i.e. evdev.
> 
> And it goes the same for every type of device the kernel is exposing to
> userspace, if you want to "share" them, then you need to work on
> changing the kernel to be able to handle shared devices.

I think you might have misunderstood me. They are using a shared input stream (evdev in this case). The problem is I don’t want them to eavesdrop on each other. So it’s not about making it to work. It’s about making them to work „in turns”.

> And odds are, you will get back a big "as-if" comment from the kernel
> developers, as for almost all devices, they can't be shared, for very
> good reasons.

Evdev devices can.


-- 
Regards,
Havner



