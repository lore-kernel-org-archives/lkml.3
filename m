Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3IWO4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab3IWO4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:56:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] block: register_blkdev doesn't check name against NULL
References: <1378809614-17490-1-git-send-email-vaughan.cao@oracle.com>
	<1378866250-22679-1-git-send-email-vaughan.cao@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Sep 2013 10:56:27 -0400
In-Reply-To: <1378866250-22679-1-git-send-email-vaughan.cao@oracle.com>
	(Vaughan Cao's message of "Wed, 11 Sep 2013 10:24:10 +0800")
Message-ID: <x49mwn3y4bo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vaughan Cao <vaughan.cao@oracle.com> writes:

> register_blkdev(0, NULL) can result kernel Oops by copying from NULL
> in strlcpy(). Fix it by checking NULL pointer at the beginning and
> WARN when encountered in unregister_blkdev.

Uhh, so yeah, this is an exported function, so I could see maybe wanting
to do the argument checking.  But honestly, if your driver can't even
get this right, is there any hope of it actually working?

This seems like a pointless patch to me, but ultimately it's up to Jens.

Cheers,
Jeff

p.s. the kerneldoc tells you what to put there:
 * @name: the name of the new block device as a zero terminated string
