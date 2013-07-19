Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab3GSKF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:05:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760121Ab3GSKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:05:57 -0400
Date: Fri, 19 Jul 2013 15:35:43 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH V2 0/2] [BUGFIX] virtio/console: Fix two bugs of
 splice_write
Message-ID: <20130719100543.GM3087@amit-x200.redhat.com>
References: <20130719091951.9698.95194.stgit@yunodevel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719091951.9698.95194.stgit@yunodevel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 19 Jul 2013 [18:19:51], Yoshihiro YUNOMAE wrote:
> Hi,
> 
> This patch set fixes two bugs of splice_write in the virtio-console driver.
> 
> [BUG1] Although pipe->nrbufs is empty, the driver tries to do splice_write.
>        => This induces oops in sg_init_table().
> 
> [BUG2] No lock for competition of splice_write.
>        => This induces oops in splice_from_pipe_feed() by bug of any user
>           application.
> 
> These reports are written in each patch.
> 
> Changes in V2:
> - Fix a locking problem for error
> 
> Thanks!

Reviewed-by: Amit Shah <amit.shah@redhat.com>

For the patches to be picked up in the stable trees, you need to
include CC: <stable@vger.kernel.org> in the sign-off area of the
patches, just cc'ing in the patch posting doesn't help.  See
Documentation/stable_kernel_rules.txt.

Can you submit a v3 with that change, and also add my reviewed-by
line?

		Amit
