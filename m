Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaI2XqF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:46:05 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:41335 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaI2XqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:46:04 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 16:45:42 -0700
Message-ID: <CALCETrWivFAqiWAfAYzZ4fgKC87H+VhyOLrfb+ONCjMmqKG9eQ@mail.gmail.com>
Subject: Removing shared subtrees?
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I know, shared subtrees in recursive bind mounts are a
misfeature that existed for the sole purpose of allowing recursive
binds + chroot to emulate mount namespaces.  But we have mount
namespaces, so what are they for?

They're totally fsked up.  For example, don't try this on a live system:

# mount --make-rshared /
# mount --rbind / /mnt
# umount -l /mnt

It will unmount *everything*.  On Fedora, you don't even need the
--make-rshared part.  WTF?

Can we just remove the feature entirely in linux-next and see if
anyone complains?  I'm all for propagation across mount namespaces,
but I suspect that, at the very least, there is no legitimate reason
whatsoever for mounts to propagate from a recursive bind mount back to
the origin.

IOW, can we kill shared mounts and just keep private and slave mounts?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
