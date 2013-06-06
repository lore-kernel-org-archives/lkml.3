Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3FFVvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:51:55 -0400
Received: from cdw.me.uk ([91.203.57.136]:33029 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab3FFVvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:51:54 -0400
Date: Thu, 6 Jun 2013 22:51:52 +0100
From: Chris Webb <chris@arachsys.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building a BSD-jail clone out of namespaces
Message-ID: <20130606215150.GG17158@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u8f89g5.fsf@xmission.com>
 <87ehcf8aef.fsf@xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Eric W. Biederman" <ebiederm@xmission.com> writes:

> Hmm.  I guess it depends on how your VM is reading them.  If it is
> blocked based access to the filesystem you have a problem.   If the VM
> is effectively NFS mounting the filesystem you can do all kinds of
> things.
> 
> It is possible to just change the user namespace and setup your mapping,
> effectively running your VM in the user namespace, and that would allow
> the VM to see your mapped uids.

In some cases I was thinking of mounting a filesystem directly from a block
device, but more often it would be directories in a local host filesystem.
I use qemu's built in virtio 9p-over-pci to pass these in at present.

So in principle, that does mean I could store UIDs translated and wrap
everything else I do at host level in a userns translation layer as well,
but it's quite an intrusive thing to do and I imagine it would preclude
lightweight throwaway containers where I share the host filesystem read-only
into a container.

This is why I was quite keen to avoid mangled ownerships in the host
filesystems at all, but from what you say, that goal sounds like this might
be rather tricky to achieve.

> There are too many things in /proc and /sys and similar that
> grant access to uid == 0.

Ah yes, I can see why this is a thorny one. Is it just the synthetic
filesystems like /proc and /sys that are the problem, or are there loads of
other places in the kernel that assume uid == 0 implies privilege? I.e. is
it 'just' a matter of somehow securing access to procfs and sysfs, or a much
wider issue?

Best wishes,

Chris.
