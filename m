Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab3LCWAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 17:00:41 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33686 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3LCWAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 17:00:38 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, clm@fb.com, viro@zeniv.linux.org.uk, zab@redhat.com,
        shaggy@kernel.org
Subject: [PATCH] DIO rewrite
Date: Tue,  3 Dec 2013 14:00:06 -0800
Message-Id: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the dio rewrite based on immutable biovecs that I've been working on
off and on for quite some time now; I think it's getting close to ready.

It passes xfstests with xfs and CONFIG_XFS_DEBUG=y, though it definitely needs
more review and outside testing. It doesn't quite work with btrfs but I think
with a bit of help from the btrfs people that one will be easy to figure out.

This  this cuts fs/direct-io.c almost in half by lines of code, makes it
_vastly_ easier to understand, and roughly halves the cpu overhead of the dio
code in the profiles I've looked at. It's only stage one of my master plan,
though.

Eventually, the goal is to get the filesystem direct_IO() method to take bios
(at which point it'll be analagous to a make_request fn, probably) - that'll
have a lot of benefits I won't go into here but it's going to take some
delicate surgery to get here. This code starts to restructure things in that
direction, doing about as much as I could without going outside of
fs/direct-io.c.

The patch series is on top of Jens' for-3.14/core branch, and includes all the
prereqs that haven't gone in yet. It's available in my git repo:

git://evilpiepirate.org/~kent/linux-bcache.git dio

