Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaGaDcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:32:04 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:29609 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888AbaGaDcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:32:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArILAM+32VN5LHOdPGdsb2JhbABZgw6BKYInhQinewEBAQEBAQajGwGBChcFAQEBATg2hAQBBTocIxAIAw4KCSUPBSUDBxoTiEG+PxcYhWSJUAeESgEEm2OYLysvgQMk
Date: Thu, 31 Jul 2014 13:31:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Abhi Das <adas@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] fs: Add dirreadahead syscall and VFS hooks
Message-ID: <20140731033156.GQ26465@dastard>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
 <1406309851-10628-2-git-send-email-adas@redhat.com>
 <CAHO5Pa2fW6mZRTao3uEx2p_X9GvO1btrbb9Bg2ns94+p4biKAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa2fW6mZRTao3uEx2p_X9GvO1btrbb9Bg2ns94+p4biKAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 10:21:50AM +0200, Michael Kerrisk wrote:
> [CC+=linux-api]
> 
> On Fri, Jul 25, 2014 at 7:37 PM, Abhi Das <adas@redhat.com> wrote:
> > Also adds a void *opaque field to struct dir_context that can be
> > used by filesystems to temporarily store any context as this
> > struct gets passed around in the fs.

So the prototype is:

int dir_readahead(int fd, off64_t offset, unsigned int count);

Why do we need a new syscall for this?

$ man 2 readahead
....
ssize_t readahead(int fd, off64_t offset, size_t count);
....
	EINVAL fd does not refer to a file type to which readahead() can be applied.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
