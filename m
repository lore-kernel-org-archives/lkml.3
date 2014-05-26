Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaEZPpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:45:43 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:34235 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaEZPpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:45:42 -0400
Date: Mon, 26 May 2014 17:45:36 +0200
From: Seth Forshee <seth.forshee@canonical.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: Jens Axboe <axboe@kernel.dk>, Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Marian Marinov <mm@1h.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lxc-devel] [RFC PATCH 11/11] loop: Allow priveleged operations
 for root in the namespace which owns a device
Message-ID: <20140526154536.GA31721@ubuntu-mba51>
Mail-Followup-To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	Marian Marinov <mm@1h.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
 <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
 <537EE129.1020603@1h.com>
 <20140526091614.GA13666@ubuntu-mba51>
 <1401118325.7572.82.camel@canyon.ip6.wittsend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401118325.7572.82.camel@canyon.ip6.wittsend.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:32:05AM -0400, Michael H. Warfield wrote:
> On Mon, 2014-05-26 at 11:16 +0200, Seth Forshee wrote:
> > On Fri, May 23, 2014 at 08:48:25AM +0300, Marian Marinov wrote:
> > > -----BEGIN PGP SIGNED MESSAGE-----
> > > Hash: SHA1
> > > 
> > > One question about this patch.
> > > 
> > > Why don't you use the devices cgroup check if the root user in that namespace is allowed to use this device?
> > > 
> > > This way you can be sure that the root in that namespace can not access devices to which the host system did not gave
> > > him access to.
> 
> > That might be possible, but I don't want to require something on the
> > host to whitelist the device for the container. Then loop would need to
> > automatically add the device to devices.allow, which doesn't seem
> > desirable to me. But I'm not entirely opposed to the idea if others
> > think this is a better way to go.
> 
> I don't see any safe way to avoid it.  The host has to be in control of
> what devices can and can not be accessed by the container.

Hmm, for testing I've been giving access to 7:* block devices since my
containers can't mknod and only see device nodes for loop devices they
have access to, but maybe I'm not being sufficiently paranoid.

