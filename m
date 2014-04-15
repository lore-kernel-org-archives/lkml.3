Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaDOUKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:10:34 -0400
Received: from imap.thunk.org ([74.207.234.97]:54755 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbaDOUK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:10:28 -0400
Date: Tue, 15 Apr 2014 16:10:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][9/11][MANUX] Kernel compatibility : ext2's dtime field?
Message-ID: <20140415201026.GJ4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>, linux-kernel@vger.kernel.org
References: <534D3770.7010806@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D3770.7010806@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:43:12PM +0200, Emmanuel Colbus wrote:
> Now, another question. In ext2, what is the point of the dtime field?
> Personaly, I'm never setting it, because, well, if an inode is removed,
> it's removed, and nobody is supposed to access it again; and anyways,
> since no syscall allows seeing it, the dtime seems to me like nothing
> but an information leakage. But I doubt you would have put a useless
> data in the filesystem, so I'm likely overlooking something; if so, what
> is it?

For ext2, it was useful as a way of being able to do some emergency
undelete operations on a file system.  These days, it's mostly for
debugging purposes.

This field is also used as a linked list in ext3 and ext4 for "orphan
inodes" and inodes which are in the process of being truncated or for
which should be truncated after a crash (to avoid leaking stale data,
for example).

						- Ted
