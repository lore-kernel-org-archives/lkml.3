Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549AbaGXT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:27:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58121 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934078AbaGXT1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:27:25 -0400
Message-ID: <1406230029.3612.122.camel@fourier>
Subject: Re: [PATCH 3.8 076/116] xfs: ioctl check for capabilities in the
 current user namespace
From: Kamal Mostafa <kamal@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Dwight Engen <dwight.engen@oracle.com>, Ben Myers <bpm@sgi.com>
Date: Thu, 24 Jul 2014 12:27:09 -0700
In-Reply-To: <87iomnle1w.fsf@x220.int.ebiederm.org>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
	 <1406067727-19683-77-git-send-email-kamal@canonical.com>
	 <20140722231257.GT4453@dastard> <1406149558.3612.37.camel@fourier>
	 <87iomnle1w.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-23 at 18:51 -0700, Eric W. Biederman wrote:

> The fs,userns: Chage inode_capable to capable_wrt_inode_uidgid is
> appropriate for 3.8.  I think that one is applicable all of the way
> back to 3.4
> 
> I don't know if xfs in 3.8 called inode_capable in xfs and if it didn't
> you can remove that hunk.

Okay, yup, that's what was done in the 3.10-stable port which I should
have found and used in the first place.

So I have now queued that (fs,userns: Change inode_capable to
capable_wrt_inode_uidgid) up again for 3.8-stable.

Thanks very much, Eric.  I appreciate you not letting this one slip past
me!

 -Kamal


>   To keep things very simple you could just
> skip the rename of inode_capable to capable_wrt_uidgid and just
> include the one line change to add kgid_has_mapping.
> 
> But that bug fix is very much applicable to older kernels.
> 
> Eric
> 


