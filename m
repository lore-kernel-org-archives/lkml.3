Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3GVSf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:35:29 -0400
Received: from longford.logfs.org ([213.229.74.203]:59878 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3GVSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:35:28 -0400
Date: Mon, 22 Jul 2013 13:03:38 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] [SCSI] sg: fix race condition in sg_open
Message-ID: <20130722170338.GA15824@logfs.org>
References: <1374075246-22923-1-git-send-email-vaughan.cao@oracle.com>
 <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374468033-8947-1-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 July 2013 12:40:29 +0800, Vaughan Cao wrote:
> 
> There is a race when open sg with O_EXCL flag. Also a race may happen between
> sg_open and sg_remove.
> 
> Changes from v4:
>  * [3/4] use ERR_PTR series instead of adding another parameter in sg_add_sfp
>  * [4/4] fix conflict for cherry-pick from v3.
> 
> Changes from v3:
>  * release o_sem in sg_release(), not in sg_remove_sfp().
>  * not set exclude with sfd_lock held.
> 
> Vaughan Cao (4):
>   [SCSI] sg: use rwsem to solve race during exclusive open
>   [SCSI] sg: no need sg_open_exclusive_lock
>   [SCSI] sg: checking sdp->detached isn't protected when open
>   [SCSI] sg: push file descriptor list locking down to per-device
>     locking
> 
>  drivers/scsi/sg.c | 178 +++++++++++++++++++++++++-----------------------------
>  1 file changed, 83 insertions(+), 95 deletions(-)

Patchset looks good to me, although I didn't test it on hardware yet.
Signed-off-by: Joern Engel <joern@logfs.org>

James, care to pick this up?

Jörn

--
Good warriors cause others to come to them and do not go to others.
-- Sun Tzu
