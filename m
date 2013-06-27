Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3F0Fu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:50:57 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63531 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3F0Fuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130627044705.GB29790@dastard>
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard>
	<87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard>
Date: Wed, 26 Jun 2013 22:50:51 -0700
Message-ID: <CAEsagEjP6jGhcZObr4QhNxsa=9ZxR5QTfxU+9YHg7GxFx+QuJQ@mail.gmail.com>
Subject: Re: [PATCH] Optimize wait_sb_inodes()
From: Daniel Phillips <daniel.raymond.phillips@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "tux3@tux3.org" <tux3@tux3.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Wed, Jun 26, 2013 at 9:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> You have your own wait code, that doesn't make what the VFS does
> unnecesary. Quite frankly, I don't trust individual filesystems to
> get it right - there's a long history of filesystem specific data
> sync problems (including in XFS), and the best way to avoid that is
> to ensure the VFS gets it right for you.

I agree that some of the methods Tux3 uses to implement data integrity, sync
and friends may be worth lifting up to core, or better, to a library,
but we will
all be better served if such methods are given time to mature first. After all,
that basically describes the entire evolution of the VFS: new concepts start
in a filesystem, prove themselves useful, then may be lifted up to be shared.

It is important to get the order right: prove first, then lift.

Regards,

Daniel
