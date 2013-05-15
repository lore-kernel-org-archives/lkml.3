Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab3EOUs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:48:57 -0400
Received: from mail3.vodafone.ie ([213.233.128.45]:42083 "EHLO
	mail3.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab3EOUs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:48:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIDAPPzk1FtTvCU/2dsb2JhbAANNBqDPkSCeL0ZAwGBE4MTAQEBAwEjDwE/BxALDQEKAgIFIQICDwJGBgEMAQcBAYgCDQUzqhBykVKBJo0ZXweCQoETA5hchReFXogx
Message-ID: <5193F4B5.500@draigBrady.com>
Date: Wed, 15 May 2013 21:48:53 +0100
From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>, linux-api@vger.kernel.org,
        Alexander Viro <aviro@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: RFC: allow empty symlink targets
References: <1358427833-3847-1-git-send-email-P@draigBrady.com> <50F8252C.2060404@draigBrady.com> <519381D8.5080206@draigBrady.com> <51939E49.1040209@redhat.com>
In-Reply-To: <51939E49.1040209@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 03:40 PM, Eric Blake wrote:
> On 05/15/2013 06:38 AM, Pádraig Brady wrote:
>> On 01/17/2013 04:22 PM, Pádraig Brady wrote:
>>> On 01/17/2013 01:03 PM, Pádraig Brady wrote:
>>>> The discussion leading to this is at http://bugs.gnu.org/13447
>>>> In summary other systems allow an empty target for a symlink,
>>>> and POSIX specifies that it should be allowed?
>>>
>>> In relation to this, Eric Blake said:
>>>
>>>> In today's Austin Group meeting, I was tasked to open a new bug that
>>>> would state specifically how the empty symlink is resolved; the intent
>>>> is to allow both Solaris behavior (current directory) and BSD behavior
>>>> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kernel
>>>> has a bug for rejecting the creation of an empty symlink, but once that
>>>> bug is fixed, then Linux can choose either Solaris or BSD behavior for
>>>> how to resolve such a symlink.
>>>>
>>>> It will probably be a bug report similar to this one, which regarded how
>>>> to handle a symlink containing just slashes:
>>>> http://austingroupbugs.net/view.php?id=541
>>
>> Following up from http://austingroupbugs.net/view.php?id=649
>> It seems POSIX will now allow the current Linux behavior of returning ENOENT,
> 
> Huh?  Linux currently doesn't allow the creation of an empty symlink.
> That link mentions the current BSD behavior of returning ENOENT when
> resolving such a symlink (that is, what stat() does when chasing through
> an empty symlink, provided such a symlink is first created).

Ah OK. The standards are hard enough to interpret,
never mind the comments discussing the standards :)
Not helping was that symlink() returns ENOENT in this case too.

>> or the Solaris behavior of allowing empty symlink targets.
> 
> The point made in that bug report is that Linux is buggy for not
> allowing symlink() to create an empty symlink in the first place; once
> you allow the creation of an empty symlink, then how to handle such a
> symlink in stat() is up to you whether to copy Solaris' or BSD's example.

OK cool, that make more sense to me.

Adding in a couple more recipients to garner interest...

thanks,
Pádraig.
