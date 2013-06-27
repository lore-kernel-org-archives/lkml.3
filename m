Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3F0NnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:43:13 -0400
Received: from cdw.me.uk ([91.203.57.136]:40914 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab3F0NnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:43:12 -0400
Date: Thu, 27 Jun 2013 14:43:09 +0100
From: Chris Webb <chris@arachsys.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Building a BSD-jail clone out of namespaces
Message-ID: <20130627134308.GG18100@arachsys.com>
References: <20130606161010.GI12062@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606161010.GI12062@arachsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> Prompted by the new userns support merged in the 3.8/3.9 kernels, I've been
> playing with namespaces and trying to understand how I could use them to
> build containers to replace some of my uses of qemu-kvm virtual machines.

I now have most things working as I'd want and am just polishing my
userspace container tool before release to make sure it fits well with
common conventions such as those mentioned at

  http://www.freedesktop.org/wiki/Software/systemd/ContainerInterface/

and parses /etc/subuid and /etc/subgid files in the format you've defined
them in your shadow patches. I was delighted by how it all nests nicely,
provided I bind mount my /dev nodes from the level above rather than try to
mknod them in the outer container.

I'd like to arrange for slightly different behaviour when the tool is run at
the top-level 'host' user namespace, for example warning about attempts to
map the dangerous UID 0.

Is there a canonical way to detect when I'm in the top-level user namespace?
I can clearly try doing something which should be impossible for a
non-top-level root user like opening /proc/kpageflags for reading or
/proc/sys/ctrl-alt-del for writing, but I wondered if there was something
more idiomatic as a test? (Some sort of 'get parent namespace' that might
return null at top-level maybe?)

Cheers,

Chris.
