Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbbAMT0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:26:05 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50552 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAMT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
References: <CAECXXi7Ax3t2b7x=KqUF1udNKWgQnGebVtkyLHnjhxEZ2o=M5g@mail.gmail.com>
	<CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
Date: Tue, 13 Jan 2015 14:26:01 -0500
Message-ID: <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
Subject: Re: NBD Maintainer
From: Paul Clements <paul.clements@us.sios.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 11:14 AM, Andrey Utkin
<andrey.krieger.utkin@gmail.com> wrote:
> Hi Paul,
> could you please describe

> - how wide is NBD usage today (any estimation is ok),

It depends somewhat on who you consider to be users. There are two
groups of NBD "users":

1) integrators and admins (who work directly with nbd)
2) users of the systems and software that the first group creates

My guess is that the first group is in the hundreds. The second in the
thousands. NBD usage tends to fall into one the following classes:

- support of diskless thin clients (mainly at universities and such)
- replication (used in conjunction with some form of mirroring scheme,
this becomes a network-raid device of sorts)
- block device emulation/user-level block device (e.g., qemu-nbd)
(because NBD has a fairly flexible design, including a fully
user-level server component, it has been used by quite a few people as
a user-level block device for various different purposes)

> - what is in a TODO list,

Nothing specific, other than merging in pending patches, of which
there are a few (check the nbd-general archives).

> - what are critical bugs or important issues requiring work, if there are any.

There is a network timeout issue, which is probably one of the more
important fixes to get in:

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770479
