Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbaKNKwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:52:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48232 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965270AbaKNKwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:52:31 -0500
Date: Fri, 14 Nov 2014 10:52:21 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3.16.y-ckt 009/170] NFS: Fix /proc/fs/nfsfs/servers and
 /proc/fs/nfsfs/volumes
Message-ID: <20141114105221.GB7276@hercules>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
 <1415704129-12709-10-git-send-email-luis.henriques@canonical.com>
 <1415946985.3398.125.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415946985.3398.125.camel@decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 06:36:25AM +0000, Ben Hutchings wrote:
> On Tue, 2014-11-11 at 11:06 +0000, Luis Henriques wrote:
> > 3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "Eric W. Biederman" <ebiederm@xmission.com>
> > 
> > commit 65b38851a17472d31fec9019fc3a55b0802dab88 upstream.
> > 
> > The usage of pid_ns->child_reaper->nsproxy->net_ns in
> > nfs_server_list_open and nfs_client_list_open is not safe.
> > 
> > /proc for a pid namespace can remain mounted after the all of the
> > process in that pid namespace have exited.  There are also times
> > before the initial process in a pid namespace has started or after the
> > initial process in a pid namespace has exited where
> > pid_ns->child_reaper can be NULL or stale.  Making the idiom
> > pid_ns->child_reaper->nsproxy a double whammy of problems.
> > 
> > Luckily all that needs to happen is to move /proc/fs/nfsfs/servers and
> > /proc/fs/nfsfs/volumes under /proc/net to /proc/net/nfsfs/servers and
> > /proc/net/nfsfs/volumes and add a symlink from the original location,
> > and to use seq_open_net as it has been designed.
> > 
> > Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> > Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> [...]
> 
> This needs a follow-up:
> 
> commit 21e81002f9788a3af591416b6dec60d7b67f2fb2
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Mon Sep 8 16:17:55 2014 -0700
> 
>     nfs: fix kernel warning when removing proc entry
> 

Thank you, Ben.  I missed that one.  Its now in the -review for this
release.

Cheers,
--
Luís

> Ben.
> 
> -- 
> Ben Hutchings
> Never put off till tomorrow what you can avoid all together.

