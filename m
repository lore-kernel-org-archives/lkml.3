Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaICMrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:47:03 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:56635 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaICMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:47:00 -0400
Date: Wed, 3 Sep 2014 16:46:55 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC PATCH 2/3] procfs: show hierarchy of pid namespace
Message-ID: <20140903124655.GA5578@cachalot>
References: <1409740200-26461-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409740200-26461-3-git-send-email-chenhanxiao@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 03, 2014 at 18:29 +0800, Chen Hanxiao wrote:
> This patch will show the hierarchy of pid namespace
> under /proc/pidns like:
> /proc/pidns
> ├── hierarchy
> │   ├── pidns4026532399
> │   │   ├── pidns -> /proc/2863/ns/pid
> │   │   └── pidns4026532515
> │   │       └── pidns -> /proc/10611/ns/pid
> │   └── pidns4026532504
> │       └── pidns -> /proc/4450/ns/pid
> └── refresh

Re: this hierarchy:

1) I think it is a bit weird that there is a global hierarchy of NSs with
symlinks to actual NSs located in some random /proc/PID/ns/pid
directories.  It would be better to have a global tree with actual
directories and process directories would have symlinks to some subdirs
in this global tree.

2) The naming can be changed for even more trivial NSs traversal.
If the hierarchy is as following --

    hierarchy/
      pidns1234/
        pidns
        children/
          pidns3456/
            ...
          pidns5678/
            ...

-- then it is more simple to traverse the tree as child NSs are all
files in pidnsXXX/children/, not all files of the mask pidns[0-9]+.

> a) hierarchy dir:
>   use to show hierarchy infomation using dir and symlinks.
>   dirs are named as pidns($inum)
>   a symlink is created under pidns($inum), and linked to
>   that pid namespace.
> 
> b) refresh
>   trigger key.
>   We need to write sth to /proc/nspid/refresh,
>   then we could get hierarchy info
>   under /proc/pidns/hierarchy.
> 

-- 
Vasily
