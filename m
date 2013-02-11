Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab3BKOKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:10:30 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44084 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab3BKOK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:10:29 -0500
Date: Mon, 11 Feb 2013 14:10:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rajat Sharma <fs.rajat@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: query about create_mnt_ns
Message-ID: <20130211141028.GJ4503@ZenIV.linux.org.uk>
References: <CAAYFAvoCi830rc-Y-8scRTLtB0MB1pNYdNq3JrwMr+8ohjkuZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYFAvoCi830rc-Y-8scRTLtB0MB1pNYdNq3JrwMr+8ohjkuZA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:44:29PM +0530, Rajat Sharma wrote:
> Hi,
> 
> I was looking at implementation of init_mount_tree() function and
> found a discrepancy in list manipulation of mnt_namsespace and
> vfsmount across kernel version 2.6.30. Up till kernel version
> 2.6.30.x, vfsmount structure was added to the list headed by
> mnt_namespace structure just allocated:
> 
> list_add(&mnt->mnt_list, &ns->list);
> 
> Beyond that with the introduction of function create_mnt_ns(), it does
> reverse of previous behavior:
> 
> list_add(&new_ns->list, &mnt->mnt_list);
> 
> i.e. it is adding new mnt_namespace to the vfsmount list. Is this the
> expected behavior? i.e. do we want to maintain list of namespaces per
> mount? Please let me know if I am missing something here.

The fact that if A and B are both empty, list_add(A, B) and list_add(B, A)
will do exactly the same thing ;-)
