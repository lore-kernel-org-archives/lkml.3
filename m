Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaDXFG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:06:56 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60497 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaDXFGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:06:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140424023925.GW18016@ZenIV.linux.org.uk>
References: <CALCETrXE_T-3eKmVKZNkAfoyvC0CcUATDK7fGPvQrR9H=RHQag@mail.gmail.com>
 <20140424023925.GW18016@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Apr 2014 22:06:33 -0700
Message-ID: <CALCETrV0n4QZCdxPrz+PeLRqM0yD4rkJ1xO4WgK7Mvvmqa-mew@mail.gmail.com>
Subject: Re: How do I make a clean mount namespace?
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 7:39 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Apr 22, 2014 at 03:12:11PM -0700, Andy Lutomirski wrote:
>> I want to set up a little container.  So I unshare the mount namespace
>> and mount something somewhere (say /mnt) that I want to be my new
>> root.  Now what?
>>
>> pivot_root("/mnt", "/mnt/garbage") seems to frequently return -EBUSY.
>
> RTFM.  Literally - man 2 pivot_root and look for the only place where
> it mentions EBUSY.
>
> If you get that error, check what you've got in /proc/mounts (in the
> namespace your process is in, obviously) just before the syscall.
> With these arguments you really want /mnt to be a mountpoint.  If your
> new root really lives on the same fs as the old one, just do
> mount --bind /mnt /mnt before any other mounts.

Wow -- thanks!  I read that part, but I'm apparently bad at following
directions.

Should I expect things to work if I unshare mounts but don't do a
mount --make-rprivate / before the pivot_rot?

--Andy
