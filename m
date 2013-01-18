Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3ARDkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:40:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:40:11 -0500
Date: Fri, 18 Jan 2013 01:40:01 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 013/222] iscsi-target: Fix bug in handling of ExpStatSN
 ACK during u32 wrap-around
Message-ID: <20130118034000.GE2872@herton-Z68MA-D2H-B3>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
 <1358351822-7675-14-git-send-email-herton.krzesinski@canonical.com>
 <1358478106.15692.159.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358478106.15692.159.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 03:01:46AM +0000, Ben Hutchings wrote:
> On Wed, 2013-01-16 at 13:53 -0200, Herton Ronaldo Krzesinski wrote:
> > 3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Steve Hodgson <steve@purestorage.com>
> > 
> > commit 64c13330a38935120501b19c97a3e6095747c7a1 upstream.
> > 
> > This patch fixes a bug in the hanlding of initiator provided ExpStatSN and
> > individual iscsi_cmd->stat_sn comparision during iscsi_conn->stat_sn
> > wrap-around within iscsit_ack_from_expstatsn() code.
> > 
> > This bug would manifest itself as iscsi_cmd descriptors not being Acked
> > by a lower ExpStatSn, causing them to be leaked until an iSCSI connection
> > or session reinstatement event occurs to release all commands.
> > 
> > Also fix up two other uses of incorrect CmdSN SNA comparison to use wrapper
> > usage from include/scsi/iscsi_proto.h.
> > 
> > Signed-off-by: Steve Hodgson <steve@purestorage.com>
> > Signed-off-by: Roland Dreier <roland@purestorage.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > [ herton: hdr->refcmdsn has the converted be32_to_cpu value on 3.5 ]
> > Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> [...]
> 
> You need this as well:
> 
> commit 044882a62f34cd6460196c13773bd210be39d717
> Author: Roland Dreier <roland@purestorage.com>
> Date:   Mon Jan 7 11:45:16 2013 -0800
> 
>     iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->stat_sn)

Thanks, I'll queue it up with final release.

> 
> Ben.
> 
> -- 
> Ben Hutchings
> It's easier to fight for one's principles than to live up to them.

-- 
[]'s
Herton
