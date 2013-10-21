Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3JUTAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:00:53 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:65465 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3JUTAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAGG-pUTVh06YcpkW06jp-nB1YaqOtm3GYgEXeLS7iF33RG5AsA@mail.gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
	<1380411144-9236-8-git-send-email-geyslan@gmail.com>
	<CAFkjPTmg26H0RGdHmR2u-wuJF=Jhd4PbbG1hVrBucuWyZDgNAw@mail.gmail.com>
	<CAGG-pUTVh06YcpkW06jp-nB1YaqOtm3GYgEXeLS7iF33RG5AsA@mail.gmail.com>
Date: Mon, 21 Oct 2013 17:00:51 -0200
Message-ID: <CAGG-pUQc8Y+2osgj1M1DeaEBVVpRm_9vF8TELbi4ScfopZHnPQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: proper use of the 'name' variable
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: rminnich@sandia.gov, Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/21 Geyslan Gregório Bem <geyslan@gmail.com>:
> 2013/10/20 Eric Van Hensbergen <ericvh@gmail.com>:
>> I reckon we should probably just get rid of name if its not being used.  I
>> doubt the indirection is going to hurt anything here.
>>
>>      -eric
>>
>
> Eric, you're right. Once that there's not assignment to name, the
> cycles are the same.
> I'll get rid of name var.
>

New patch sent.
[PATCH] 9p: remove useless 'name' variable and assignment

>>
>>
>> On Sat, Sep 28, 2013 at 6:32 PM, Geyslan G. Bem <geyslan@gmail.com> wrote:
>>>
>>> The 'name' variable was assigned but never used. Hence puts its
>>> assignment to the top and makes proper use of its value.
>>>
>>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>>> ---
>>>  fs/9p/vfs_inode_dotl.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
>>> index 6803758..86b6944 100644
>>> --- a/fs/9p/vfs_inode_dotl.c
>>> +++ b/fs/9p/vfs_inode_dotl.c
>>> @@ -772,8 +772,10 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct
>>> inode *dir,
>>>         struct p9_fid *dfid, *oldfid;
>>>         struct v9fs_session_info *v9ses;
>>>
>>> +       name = (char *) dentry->d_name.name;
>>> +
>>>         p9_debug(P9_DEBUG_VFS, "dir ino: %lu, old_name: %s, new_name:
>>> %s\n",
>>> -                dir->i_ino, old_dentry->d_name.name,
>>> dentry->d_name.name);
>>> +                dir->i_ino, old_dentry->d_name.name, name);
>>>
>>>         v9ses = v9fs_inode2v9ses(dir);
>>>         dir_dentry = dentry->d_parent;
>>> @@ -785,9 +787,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct
>>> inode *dir,
>>>         if (IS_ERR(oldfid))
>>>                 return PTR_ERR(oldfid);
>>>
>>> -       name = (char *) dentry->d_name.name;
>>> -
>>> -       err = p9_client_link(dfid, oldfid, (char *)dentry->d_name.name);
>>> +       err = p9_client_link(dfid, oldfid, name);
>>>
>>>         if (err < 0) {
>>>                 p9_debug(P9_DEBUG_VFS, "p9_client_link failed %d\n", err);
>>> --
>>> 1.8.4
>>>
>>
