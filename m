Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3IAA4b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 20:56:31 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35734 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab3IAA43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 20:56:29 -0400
X-Sasl-enc: ud4I25ktU0x+UEMivsPCR8Kd4lwhvFA/mwrzjFrwE7cI 1377996988
Message-ID: <1377996985.4223.6.camel@perseus.fritz.box>
Subject: Re: [PATCH 0/9] [RFC v2] safely drop directory dentry on failed
 revalidate
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Ric Wheeler <rwheeler@redhat.com>, Anand Avati <avati@redhat.com>,
        Brian Foster <bfoster@redhat.com>, David Howells <dhowells@redhat.com>,
        Eric Paris <eparis@redhat.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Date: Sun, 01 Sep 2013 08:56:25 +0800
In-Reply-To: <CAJfpegv18PCygsnpYXNLv6mD+Lff9dbVwtoV4OCbzjftc8HVAA@mail.gmail.com>
References: <1375975490-18673-1-git-send-email-miklos@szeredi.hu>
	 <20130821054055.GN27005@ZenIV.linux.org.uk>
	 <1377748272.9297.47.camel@tucsk.piliscsaba.szeredi.hu>
	 <1377818677.2355.25.camel@perseus.fritz.box>
	 <1377819852.2355.28.camel@perseus.fritz.box>
	 <CAJfpegv18PCygsnpYXNLv6mD+Lff9dbVwtoV4OCbzjftc8HVAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 10:59 +0200, Miklos Szeredi wrote:
> On Fri, Aug 30, 2013 at 1:44 AM, Ian Kent <raven@themaw.net> wrote:
> 
> >> The check in waitq.c above "is" used to validate the need to callback to
> >> the daemon to request a mount.
> 
> Okay.  But then shouldn't the check be  "if (d_mountpoint(dentry)) valid = 0;" ?

I don't think so.

But again, may_umount() might do what's needed here too.

I don't think this is enough because it doesn't cover the case where the
dentry is not simple_empty() but has no mounts below. That's not a
normal use case but could happen if the daemon crashed at just the wrong
time, encountered an error condition that didn't allow it to cleanup
directories, or a user umounted triggers within the tree before starting
the daemon.

> 
> Thanks,
> Miklos


