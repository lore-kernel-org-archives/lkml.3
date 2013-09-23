Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3IWUmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:42:43 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:32801 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3IWUmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:42:42 -0400
Date: Mon, 23 Sep 2013 14:42:32 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Cc: tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH 09/13] tpm: Pull everything related to
 sysfs into tpm-sysfs.c
Message-ID: <20130923204232.GB16345@obsidianresearch.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1379960083-8942-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <52408E5D.4020904@tycho.nsa.gov>
 <20130923193633.GA9194@obsidianresearch.com>
 <5240A2A3.4040102@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240A2A3.4040102@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 04:20:51PM -0400, Daniel De Graaf wrote:

> That's fine; it wasn't really advertised in the description, and was
> mostly added in order to demonstrate the locality security label binding
> in Xen's vtpm-stubdom.

Ok, lets take it out for now then? I'll send a patch.

> >It looks like this driver was introduced in the 3.12 merge window, we
> >could drop the attribute, and try to merge a core supported locality
> >API in 3.13? What do you think?
> >
> >But, if you say it is needed, it is easy enough to adjust this patch
> >series.

> If it's replaced with an alternative, I don't think the sysfs attribute
> will need to remain.  I am not aware of any clients that currently use
> this attribute.  The sysfs attribute could remain as the common interface
> for changing locality, unless you think an ioctl on /dev/tpm0 or
> something else would be preferable (the attribute was just the simplest
> way to implement locality switching at the time).

Off the very top of my head:

I suspect that a good API would be a sysfs attribute
'default_locality' and an IOCTL to change localities.  The
default_locality would only take effect when the /dev/tpmX is opened,
so fiddling with sysfs doesn't break active users.

The struct ops I've added would have a function to change localities,
some of the generic TPM functions should be revised to have a locality
argument.

Some thought is needed to determine what locality in-kernel users
should be using. I suspect userspace and kernel space should not be
forced to the same locality.

Should user space be restricted to a subset of localities?

What use models do you see with the security label binding mechanism
you have on the hypervisor side?

Jason
