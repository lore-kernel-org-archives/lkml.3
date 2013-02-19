Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3BSBb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:31:59 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61090 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754265Ab3BSBb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:31:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAPvTIlF5LHbb/2dsb2JhbABEhWC1OoUSgQQXc4IfAQEEATocIxAIAxUDCSUPBSUDIROIDAWxR493FY1aYCIyCweDQAOWK5BZgxuBVg
Date: Tue, 19 Feb 2013 12:31:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 08/16] xfs: Use kprojids when allocating inodes.
Message-ID: <20130219013154.GH26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-8-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-8-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:11:01PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> In xfs_create and xfs_symlink compute the desired kprojid and pass it
> down into xfs_ialloc.

NACK.

The first time you posted this code I NACKed it because:

>> This sort of thing just makes me cringe. This is all internal
>> project ID management that has nothing to do with namespaces.
>> It's for project ID's that are inherited from the parent inode,
>> and as such we do not care one bit what the namespace is.
>> Internal passing of project IDs like this this should not be
>> converted at all as it has nothing at all to do with the
>> namespaces.

Please drop this patch or replace it with a simple patch that passes
the project ID as an xfs_dqid_t (i.e. a flat, 32 bit quota
identifier) instead so you can kill the prid_t type.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
