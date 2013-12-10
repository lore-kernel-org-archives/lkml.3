Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab3LJULg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:11:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab3LJULf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:11:35 -0500
Message-ID: <1386706291.23829.17.camel@flatline.rdu.redhat.com>
Subject: Re: SELinux change in 3.13 causes sync hang
From: Eric Paris <eparis@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Anand Avati <avati@redhat.com>, James Morris <jmorris@namei.org>,
        Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 15:11:31 -0500
In-Reply-To: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
References: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 15:06 -0500, Josh Boyer wrote:
> We've had a report[1] in Fedora of sync(1) hanging after logging into
> GNOME and running the command in a terminal.  I was able to recreate
> this on my local system and did a git bisect.  The bisect blames:
> 
> commit 102aefdda4d8275ce7d7100bc16c88c74272b260
> Author: Anand Avati <avati@redhat.com>
> Date:   Tue Apr 16 18:56:19 2013 -0400
> 
>     selinux: consider filesystem subtype in policies
> 

I think this should revert cleanly (and if so is what we should do).
Josh is testing that right now...

Anand, I know policy ships with:
fs_use_xattr fuse.glusterfs gen_context(system_u:object_r:fs_t,s0);
So we must have a bug where other fuse filesystems are tripping on this
rule.  Since we are trying to use xattrs on a gvfs filesystem.

/me still grows that fuse refuses to respond to xattr requests until
mount(8) (that's right mount(8) not even mount(3) completes)

