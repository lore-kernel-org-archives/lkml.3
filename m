Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbbASVKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 16:10:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36296 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbASVKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 16:10:54 -0500
Date: Mon, 19 Jan 2015 21:10:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [RFC 1/2] FS: mount_bdev from vfs instead of filesystem specific
 mount function.
Message-ID: <20150119211050.GG29656@ZenIV.linux.org.uk>
References: <1421700440-15128-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421700440-15128-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 09:47:20PM +0100, Fabian Frederick wrote:
> Currently, a lot of filesystem mounting functions feature in
> file_system_type only to be called from vfs mount_fs and call mount_bdev.
> 
> This patch adds fill_super function to that structure and lets vfs
> call mount_bdev when no mount function is declared.

NAK.  First of all, quite a few of them are _not_ mount_bdev() users.
What's more, you are trading about 4 lines per filesystem (two of them
being { and }) for a layering violation.

No point whatsoever.  fill_super() is no more a method than e.g. get_block().
