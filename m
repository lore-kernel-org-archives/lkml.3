Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbaICWSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:18:21 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37109 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbaICWSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140903220518.435911463@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
	<20140903220518.435911463@linuxfoundation.org>
Date: Wed, 3 Sep 2014 18:18:16 -0400
Message-ID: <CAHQdGtR8eH-rz3=4uBU=MjrXBUKhrRFO1rsjKqSxD_131MoTFQ@mail.gmail.com>
Subject: Re: [PATCH 3.14 83/88] NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        Stable Tree <stable@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 3, 2014 at 6:05 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>
> commit 65b38851a17472d31fec9019fc3a55b0802dab88 upstream.
>
> The usage of pid_ns->child_reaper->nsproxy->net_ns in
> nfs_server_list_open and nfs_client_list_open is not safe.
>
> /proc for a pid namespace can remain mounted after the all of the
> process in that pid namespace have exited.  There are also times
> before the initial process in a pid namespace has started or after the
> initial process in a pid namespace has exited where
> pid_ns->child_reaper can be NULL or stale.  Making the idiom
> pid_ns->child_reaper->nsproxy a double whammy of problems.
>
> Luckily all that needs to happen is to move /proc/fs/nfsfs/servers and
> /proc/fs/nfsfs/volumes under /proc/net to /proc/net/nfsfs/servers and
> /proc/net/nfsfs/volumes and add a symlink from the original location,
> and to use seq_open_net as it has been designed.
>
> Cc: Trond Myklebust <trond.myklebust@primarydata.com>
> Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

...and ditto. Please hold off applying until the commit is fixed in upstream.

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
