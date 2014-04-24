Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaDXCj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:39:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53513 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaDXCj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:39:26 -0400
Date: Thu, 24 Apr 2014 03:39:25 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: How do I make a clean mount namespace?
Message-ID: <20140424023925.GW18016@ZenIV.linux.org.uk>
References: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:12:11PM -0700, Andy Lutomirski wrote:
> I want to set up a little container.  So I unshare the mount namespace
> and mount something somewhere (say /mnt) that I want to be my new
> root.  Now what?
> 
> pivot_root("/mnt", "/mnt/garbage") seems to frequently return -EBUSY.

RTFM.  Literally - man 2 pivot_root and look for the only place where
it mentions EBUSY.

If you get that error, check what you've got in /proc/mounts (in the
namespace your process is in, obviously) just before the syscall.
With these arguments you really want /mnt to be a mountpoint.  If your
new root really lives on the same fs as the old one, just do
mount --bind /mnt /mnt before any other mounts.
