Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3F0HW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:22:26 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:45107 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3F0HWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <87y59w5dye.fsf@devron.myhome.or.jp>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard>
	<87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard>
	<87y59w5dye.fsf@devron.myhome.or.jp>
Date: Thu, 27 Jun 2013 00:22:18 -0700
Message-ID: <CAEsagEirOdtisf5DrnmnEsfdWpAt31qDm9rwD_i4LhmBgYoPVw@mail.gmail.com>
Subject: Re: [PATCH] Optimize wait_sb_inodes()
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Dave Chinner <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:18 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> ...vfs can't know the data is whether after sync point or before
> sync point, and have to wait or not. FS is using the behavior like
> data=journal has tracking of those already, and can reuse it.

Clearly showing why the current interface is inefficient.

In the old days, core liked to poke its nose into the buffers of
every fs too, and those days are thankfully gone (thanks to
akpm iirc). Maybe the days of core sticking its nose into the
the inode dirty state of every fs are soon to end as well.

Why does core even need to know about the inodes a fs is
using? Maybe for some filesystems it saves implementation
code, but for Tux3 it just wastes CPU and adds extra code.

Regards,

Daniel
