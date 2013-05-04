Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030Ab3EDS7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:59:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46606 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758427Ab3EDS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:59:00 -0400
Date: Sat, 4 May 2013 19:58:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] fs: Fix hang with BSD accounting on frozen filesystem
Message-ID: <20130504185857.GG25399@ZenIV.linux.org.uk>
References: <1367619083-8093-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367619083-8093-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 12:11:23AM +0200, Jan Kara wrote:
> When BSD process accounting is enabled and logs information to a
> filesystem which gets frozen, system easily becomes unusable because
> each attempt to account process information blocks. Thus e.g. every task
> gets blocked in exit.
> 
> It seems better to drop accounting information (which can already happen
> when filesystem is running out of space) instead of locking system up.
> So we just skip the write if the filesystem is frozen.

Applied, with one modification - file_start_write_trylock() added and
used instead of sb_start_write_trylock()
