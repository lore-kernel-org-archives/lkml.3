Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3GKCAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 22:00:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:61066 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922Ab3GKCAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 22:00:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgonALgQ3lF5LD3k/2dsb2JhbABagwkygm2qfwKOVIUsBAGBDhd0giMBAQU6HCMQCAMUBAklDwUlAyETCYgFDbdBFo4AGwEUgR0HgwlsA5dZgSqQIYMjKoE1
Date: Thu, 11 Jul 2013 12:00:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Paul Taysom <taysom@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, sonnyrao@chromium.org
Subject: Re: [PATCH] fs: sync: fixed performance regression
Message-ID: <20130711020012.GA5652@dastard>
References: <1373497956-8770-1-git-send-email-taysom@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373497956-8770-1-git-send-email-taysom@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 04:12:36PM -0700, Paul Taysom wrote:
> The following commit introduced a 10x regression for
> syncing inodes in ext4 with relatime enabled where just
> the atime had been modified.
> 
>     commit 4ea425b63a3dfeb7707fc7cc7161c11a51e871ed
>     Author: Jan Kara <jack@suse.cz>
>     Date:   Tue Jul 3 16:45:34 2012 +0200
>     vfs: Avoid unnecessary WB_SYNC_NONE writeback during sys_sync and reorder sync passes
> 
>     See also: http://www.kernelhub.org/?msg=93100&p=2
> 
> Fixed by putting back in the call to writeback_inodes_sb.
> 
> I'll attach the test in a reply to this e-mail.
> 
> The test starts by creating 512 files, syncing, reading one byte
> from each of those files, syncing, and then deleting each file
> and syncing. The time to do each sync is printed. The process
> is then repeated for 1024 files and then the next power of
> two up to 262144 files.
> 
> Note, when running the test, the slow down doesn't always happen
> but most of the tests will show a slow down.

Can you please check if the patch attached to this mail:

http://marc.info/?l=linux-kernel&m=137276874025813&w=2

Fixes your problem?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
