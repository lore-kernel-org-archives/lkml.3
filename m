Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaEOBcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:32:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbaEOBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:32:49 -0400
Date: Wed, 14 May 2014 18:32:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Subject: Re: [RFC PATCH 00/11] Add support for devtmpfs in user namespaces
Message-ID: <20140515013245.GA1764@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 04:34:48PM -0500, Seth Forshee wrote:
> Unpriveleged containers cannot run mknod, making it difficult to support
> devices which appear at runtime.

Wait.

Why would you even want a container to see a "new" device?  That's the
whole point, your container should see a "clean" system, not the "this
USB device was just plugged in" system.  Otherwise, how are you going to
even tell that container a new device showed up?  Are you now going to
add udev support in containers?  Hah, no.

> Using devtmpfs is one possible
> solution, and it would have the added benefit of making container setup
> simpler. But simply letting containers mount devtmpfs isn't sufficient
> since the container may need to see a different, more limited set of
> devices, and because different environments making modifications to
> the filesystem could lead to conflicts.
> 
> This series solves these problems by assigning devices to user
> namespaces. Each device has an "owner" namespace which specifies which
> devtmpfs mount the device should appear in as well allowing priveleged
> operations on the device from that namespace. This defaults to
> init_user_ns. There's also an ns_global flag to indicate a device should
> appear in all devtmpfs mounts.

I'd strongly argue that this isn't even a "problem" at all.  And, as I
said at the Plumbers conference last year, adding namespaces to devices
isn't going to happen, sorry.  Please don't continue down this path.

greg k-h
