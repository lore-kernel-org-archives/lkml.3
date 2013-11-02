Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3KBNwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:52:36 -0400
Received: from intranet.asianux.com ([58.214.24.6]:13513 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3KBNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:48:23 -0400
X-Spam-Score: -100.9
Message-ID: <52750237.5060409@asianux.com>
Date: Sat, 02 Nov 2013 21:46:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/befs/linuxvfs.c: need signed cast for variable 'block'
References: <5271C5E5.6080606@asianux.com> <CAGXu5jLMU0+VkJ6N3NTKbEtL+9FwF2gMOTU86-GH6SSXQ0rc0w@mail.gmail.com> <20131031190608.GH13318@ZenIV.linux.org.uk> <CAGXu5jJkXj975rbpJo8pTLakPLLpVVse+ecxwQ7Ds2x-ARAOxQ@mail.gmail.com> <20131031204558.GA30290@kroah.com> <527314D5.7090004@asianux.com>
In-Reply-To: <527314D5.7090004@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 10:41 AM, Chen Gang wrote:
> On 11/01/2013 04:45 AM, Greg KH wrote:
>> On Thu, Oct 31, 2013 at 12:08:33PM -0700, Kees Cook wrote:
>>> On Thu, Oct 31, 2013 at 12:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>> On Thu, Oct 31, 2013 at 09:53:59AM -0700, Kees Cook wrote:
>>>>
>>>>> If block (type sector_t) is unsigned, we shouldn't cast it signed.
>>>>> This entire code path should be removed. What is BEFS's expected
>>>>> maximum block size? (Looks like even befs_blocknr_t is u64, so nothing
>>>>> seems trivially in danger of wrapping.) I would also note that all the
>>>>> format strings are wrong too (%ld instead of %lu).
>>>>
>>>> FWIW, this
>>>>         res = befs_fblock2brun(sb, ds, block, &run);
>>>>         if (res != BEFS_OK) {
>>>>                 befs_error(sb,
>>>>                            "<--- befs_get_block() for inode %lu, block "
>>>>                            "%ld ERROR", inode->i_ino, block);
>>>>                 return -EFBIG;
>>>>         }
>>>> also looks wrong - ioctl(..., FIBMAP, ...) shouldn't be able to spew
>>>> printks on a valid fs and hitting it with block number greater than
>>>> file length will, AFAICS, trigger that.
>>>>
>>>> I agree that this code needs fixing, but just making gcc STFU about the
>>>> comparison would only serve to hide the problem.  Anybody familiar with
>>>> befs or willing to learn it?
>>>
>>> Agreed. MAINTAINERS shows it as orphaned. Perhaps it should be moved
>>> into staging?
>>
>> Only if we want to delete the thing.  I'll be glad to take it there, and
>> remove it in 2 releases and then if anyone complains, we can add it back
>> easily.  Just let me know.
>>
> 
> Excuse me, I am not quite familiar with BEFS, I guess your meaning is:
> 
>   "if it is no further more discussion (e.g. within 1 week, no members reply), you will remove it (take it to "drivers/staging" sub-directory)".
> 

Oh, for me, it is not suitable to move a file system sub-directory to
"drivers/*/" sub-directory. And I can not find any sub-directory like
'staging' under "fs" sub-directory, either.

Do we have any sub-directory like "staging" in "fs" sub-directory? if
no, do we have to create it or have to use another ways instead of?


After reference the "drivers/staging" explanation (list below), we know
it is only for drivers (not fs).

menuconfig STAGING
        bool "Staging drivers"
        default n
        ---help---
          This option allows you to select a number of drivers that are
          not of the "normal" Linux kernel quality level.  These drivers
          are placed here in order to get a wider audience to make use of
          them.  Please note that these drivers are under heavy
          development, may or may not work, and may contain userspace
          interfaces that most likely will be changed in the near
          future.

          Using any of these drivers will taint your kernel which might
          affect support options from both the community, and various
          commercial support organizations.

          If you wish to work on these drivers, to help improve them, or
          to report problems you have with them, please see the
          driver_name.README file in the drivers/staging/ directory to
          see what needs to be worked on, and who to contact.

          If in doubt, say N here.


Thanks.

> If what I guess is correct, I support you (else, please let me know)
> 
> 
> Thanks.
> 

-- 
Chen Gang
