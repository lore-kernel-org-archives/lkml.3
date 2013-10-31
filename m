Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3JaTIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:08:36 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:46375 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3JaTId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:08:33 -0400
MIME-Version: 1.0
In-Reply-To: <20131031190608.GH13318@ZenIV.linux.org.uk>
References: <5271C5E5.6080606@asianux.com>
	<CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com>
	<20131031190608.GH13318@ZenIV.linux.org.uk>
Date: Thu, 31 Oct 2013 12:08:33 -0700
X-Google-Sender-Auth: Oeo6qjs8JbDmEGgG9bQCXVkQMMI
Message-ID: <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Oct 31, 2013 at 09:53:59AM -0700, Kees Cook wrote:
>
>> If block (type sector_t) is unsigned, we shouldn't cast it signed.
>> This entire code path should be removed. What is BEFS's expected
>> maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
>> seems trivially in danger of wrapping.) I would also note that all the
>> format strings are wrong too (%ld instead of %lu).
>
> FWIW, this
>         res = befs_fblock2brun(sb, ds, block, &run);
>         if (res != BEFS_OK) {
>                 befs_error(sb,
>                            "<--- befs_get_block() for inode %lu, block "
>                            "%ld ERROR", inode->i_ino, block);
>                 return -EFBIG;
>         }
> also looks wrong - ioctl(..., FIBMAP, ...) shouldn't be able to spew
> printks on a valid fs and hitting it with block number greater than
> file length will, AFAICS, trigger that.
>
> I agree that this code needs fixing, but just making gcc STFU about the
> comparison would only serve to hide the problem.  Anybody familiar with
> befs or willing to learn it?

Agreed. MAINTAINERS shows it as orphaned. Perhaps it should be moved
into staging?

-Kees

-- 
Kees Cook
Chrome OS Security
