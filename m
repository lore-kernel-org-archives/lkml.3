Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3AQQF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:05:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:33703 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063Ab3AQQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:05:57 -0500
Date: Thu, 17 Jan 2013 08:05:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Steve Hodgson <steve@purestorage.com>,
        Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [ 037/221] iscsi-target: Fix bug in handling of ExpStatSN ACK
 during u32 wrap-around
Message-ID: <20130117160547.GB5885@kroah.com>
References: <20130115184958.025580322@linuxfoundation.org>
 <20130115185000.709964724@linuxfoundation.org>
 <1358429844.15692.134.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358429844.15692.134.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 01:37:24PM +0000, Ben Hutchings wrote:
> On Tue, 2013-01-15 at 10:49 -0800, Greg Kroah-Hartman wrote:
> > 3.7-stable review patch.  If anyone has any objections, please let me know.
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
> [...]
> 
> You'll need to add this fix:
> 
> commit 64fe4f4f181cc2fe97d4176bf6ee6e3725ae33ec
> Author: Roland Dreier <roland@purestorage.com>
> Date:   Mon Jan 7 11:45:16 2013 -0800
> 
>     iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->stat_sn)

Thanks for that, now queued up.

greg k-h
