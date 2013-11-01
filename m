Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3KACmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 22:42:33 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38945 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3KACmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 22:42:32 -0400
X-Spam-Score: -100.8
Message-ID: <527314D5.7090004@asianux.com>
Date: Fri, 01 Nov 2013 10:41:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
References: <5271C5E5.6080606@asianux.com> <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com> <20131031190608.GH13318@ZenIV.linux.org.uk> <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com> <20131031204558.GA30290@kroah.com>
In-Reply-To: <20131031204558.GA30290@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 04:45 AM, Greg KH wrote:
> On Thu, Oct 31, 2013 at 12:08:33PM -0700, Kees Cook wrote:
>> On Thu, Oct 31, 2013 at 12:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>> On Thu, Oct 31, 2013 at 09:53:59AM -0700, Kees Cook wrote:
>>>
>>>> If block (type sector_t) is unsigned, we shouldn't cast it signed.
>>>> This entire code path should be removed. What is BEFS's expected
>>>> maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
>>>> seems trivially in danger of wrapping.) I would also note that all the
>>>> format strings are wrong too (%ld instead of %lu).
>>>
>>> FWIW, this
>>>         res = befs_fblock2brun(sb, ds, block, &run);
>>>         if (res != BEFS_OK) {
>>>                 befs_error(sb,
>>>                            "<--- befs_get_block() for inode %lu, block "
>>>                            "%ld ERROR", inode->i_ino, block);
>>>                 return -EFBIG;
>>>         }
>>> also looks wrong - ioctl(..., FIBMAP, ...) shouldn't be able to spew
>>> printks on a valid fs and hitting it with block number greater than
>>> file length will, AFAICS, trigger that.
>>>
>>> I agree that this code needs fixing, but just making gcc STFU about the
>>> comparison would only serve to hide the problem.  Anybody familiar with
>>> befs or willing to learn it?
>>
>> Agreed. MAINTAINERS shows it as orphaned. Perhaps it should be moved
>> into staging?
> 
> Only if we want to delete the thing.  I'll be glad to take it there, and
> remove it in 2 releases and then if anyone complains, we can add it back
> easily.  Just let me know.
> 

Excuse me, I am not quite familiar with BEFS, I guess your meaning is:

  "if it is no further more discussion (e.g. within 1 week, no members reply), you will remove it (take it to "drivers/staging" sub-directory)".

If what I guess is correct, I support you (else, please let me know)


Thanks.
-- 
Chen Gang
