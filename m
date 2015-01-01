Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbbAASlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 13:41:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56974 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAASlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 13:41:10 -0500
Date: Thu, 1 Jan 2015 18:41:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-audit@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Audit fixes for 3.19 #2
Message-ID: <20150101184108.GA28149@ZenIV.linux.org.uk>
References: <3159430.4MhUX0bhoZ@sifl>
 <CA+55aFzwqafHa6ARO-zkCDaHZozZDDvETBMmbnvNsnu1L9v2=w@mail.gmail.com>
 <3787508.5gHb8qD3XR@sifl>
 <20150101000149.GP22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150101000149.GP22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 12:01:49AM +0000, Al Viro wrote:

> Umm...  How about just adding a function that would be used instead of
> all those
>         struct filename filename = { .name = name };
> and created an object that would be destroyed later by putname()?

... such as getname_kernel(), actually.  There are 5 places like that:
fs/exec.c:open_exec(), fs/namei.c:do_path_lookup(),
fs/namei.c:kern_path_mountpoint(), fs/namei.c:do_file_open_root(),
fs/open.c:filp_open().  Said that, I'm not sure that no call chains
allow names just under PATH_MAX, so getname_kernel() might need to be
taught to handle those.

