Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbbANJLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:11:14 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41426 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbbANJLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:11:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
References: <CAECXXi7Ax3t2b7x=KqUF1udNKWgQnGebVtkyLHnjhxEZ2o=M5g@mail.gmail.com>
	<CANZNk812oKH3k+bW8Jb2fQHxOS+pF=ghHpekB4X8QtQm67X-hQ@mail.gmail.com>
	<CAECXXi4mEV2=-w95LJCDA=zf6f8_SCRBHYkp2tTwUuAJiOjaQQ@mail.gmail.com>
Date: Wed, 14 Jan 2015 17:11:09 +0800
Message-ID: <CACVXFVNN7j8qJedmimeegeg7KVdakkZdEvrTtw=USX8R_bHPEw@mail.gmail.com>
Subject: Re: NBD Maintainer
From: Ming Lei <tom.leiming@gmail.com>
To: Paul Clements <paul.clements@us.sios.com>
Cc: Andrey Utkin <andrey.krieger.utkin@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 3:26 AM, Paul Clements
<paul.clements@us.sios.com> wrote:
> On Tue, Jan 13, 2015 at 11:14 AM, Andrey Utkin
> <andrey.krieger.utkin@gmail.com> wrote:
>> Hi Paul,
>> could you please describe
>
>> - how wide is NBD usage today (any estimation is ok),
>
> It depends somewhat on who you consider to be users. There are two
> groups of NBD "users":
>
> 1) integrators and admins (who work directly with nbd)
> 2) users of the systems and software that the first group creates
>
> My guess is that the first group is in the hundreds. The second in the
> thousands. NBD usage tends to fall into one the following classes:
>
> - support of diskless thin clients (mainly at universities and such)
> - replication (used in conjunction with some form of mirroring scheme,
> this becomes a network-raid device of sorts)
> - block device emulation/user-level block device (e.g., qemu-nbd)
> (because NBD has a fairly flexible design, including a fully
> user-level server component, it has been used by quite a few people as
> a user-level block device for various different purposes)

The 3rd one should have huge users since qemu-nbd is used
to access VM image and Openstack(nova) uses it to launch VM
instance.

>
>> - what is in a TODO list,
>
> Nothing specific, other than merging in pending patches, of which
> there are a few (check the nbd-general archives).
>
>> - what are critical bugs or important issues requiring work, if there are any.
>
> There is a network timeout issue, which is probably one of the more
> important fixes to get in:
>
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=770479

Last time I studied nbd driver a while to see if socket aio can be
used to improve performance, but looks not get some fruits.


Thanks,
Ming Lei
