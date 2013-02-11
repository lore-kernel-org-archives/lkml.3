Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3BKOxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:53:51 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:51750 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3BKOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130211141028.GJ4503@ZenIV.linux.org.uk>
References: <CAAYFAvoCi830rc-Y-8scRTLtB0MB1pNYdNq3JrwMr+8ohjkuZA@mail.gmail.com>
	<20130211141028.GJ4503@ZenIV.linux.org.uk>
Date: Mon, 11 Feb 2013 20:23:44 +0530
Message-ID: <CAAYFAvoAKEgTCrWRLU6wuLkm5cH8mS-xg-TU7_WfeKsxRWC16w@mail.gmail.com>
Subject: Re: query about create_mnt_ns
From: Rajat Sharma <fs.rajat@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks :)

On Mon, Feb 11, 2013 at 7:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Feb 11, 2013 at 05:44:29PM +0530, Rajat Sharma wrote:
>> Hi,
>>
>> I was looking at implementation of init_mount_tree() function and
>> found a discrepancy in list manipulation of mnt_namsespace and
>> vfsmount across kernel version 2.6.30. Up till kernel version
>> 2.6.30.x, vfsmount structure was added to the list headed by
>> mnt_namespace structure just allocated:
>>
>> list_add(&mnt->mnt_list, &ns->list);
>>
>> Beyond that with the introduction of function create_mnt_ns(), it does
>> reverse of previous behavior:
>>
>> list_add(&new_ns->list, &mnt->mnt_list);
>>
>> i.e. it is adding new mnt_namespace to the vfsmount list. Is this the
>> expected behavior? i.e. do we want to maintain list of namespaces per
>> mount? Please let me know if I am missing something here.
>
> The fact that if A and B are both empty, list_add(A, B) and list_add(B, A)
> will do exactly the same thing ;-)
