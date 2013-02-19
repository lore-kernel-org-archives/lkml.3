Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3BSBsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:48:45 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36559 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757708Ab3BSBsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:48:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKABzZIlF5LHbb/2dsb2JhbABEhWC1PIUSgQQXc4IfAQEFOhwjEAgDFQMJGgsPBSUDIROIEbFBj38VjjoiPQeDQAOWK4lZhwCBUoFJ
Date: Tue, 19 Feb 2013 12:48:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 07/16] xfs: Update ioctl(XFS_IOC_FREE_EOFBLOCKS)
 to handle callers in any userspace
Message-ID: <20130219014840.GI26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-7-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:11:00PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Modify the ioctl to convert from uids, gid, and projids in the
>   current user namespace to kuids, kgids, and kprojids, and to report
>   an error if the conversion fails.

Please just convert to xfs_dqid_t at the interface.

> - Create struct xfs_internal_eofblocks to hold the same information as
>   struct xfs_eofblocks but with uids, gids, and projids stored as
>   kuids, kgids, and kprojids preventing confusion.

No need. Just convert the struct xfs_eof_blocks to define them all
as xfs_dqid_t and convert them in place to the type that is
compatible with the XFS core use of these fields (i.e. comparing
them with the on-disk inode uid/gid/prid values).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
