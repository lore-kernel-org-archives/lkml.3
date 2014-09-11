Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaIKOkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:40:51 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59711 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbaIKOks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:40:48 -0400
Message-ID: <5411B46B.1080800@gmail.com>
Date: Thu, 11 Sep 2014 07:40:43 -0700
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: For review: user_namespace(7) man page
References: <53F5310A.5080503@gmail.com>	<87d2bhfxvc.fsf@x220.int.ebiederm.org> <540F07CD.3080708@gmail.com> <87oauookq2.fsf@x220.int.ebiederm.org>
In-Reply-To: <87oauookq2.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 08:51 AM, Eric W. Biederman wrote:
> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> 
>> On 08/30/2014 02:53 PM, Eric W. Biederman wrote:
>>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> [...]
>>
>>
>>>>        The initial user namespace has no parent namespace, but, for con‐
>>>>        sistency, the kernel provides dummy user  and  group  ID  mapping
>>>>        files  for  this namespace.  Looking at the uid_map file (gid_map
>>>>        is the same) from a shell in the initial namespace shows:
>>>>
>>>>            $ cat /proc/$$/uid_map
>>>>                     0          0 4294967295
>>>>
>>>>        This mapping tells us that the range starting at  user  ID  0  in
>>>>        this namespace maps to a range starting at 0 in the (nonexistent)
>>>>        parent namespace, and the length of  the  range  is  the  largest
>>>>        32-bit unsigned integer.
>>>
>>> Which deliberately leaves 4294967295 32bit (-1) unmapped.  (uid_t)-1 is
>>> used in several interfaces (like setreuid) as a way to specify no uid
>>> leaving it unmapped and unusuable guarantees that there will be no
>>> confusion when using those kernel methods.
>>
>> So, I worked that piece into the text to give:
>>
>>        This  mapping  tells us that the range starting at user ID 0 in
>>        this namespace maps to a range starting at 0 in  the  (nonexis‐
>>        tent)  parent  namespace,  and  the  length of the range is the
>>        largest 32-bit unsigned  integer.   (This  deliberately  leaves
>>        4294967295  (the  32-bit  signed  -1  value) unmapped.  This is
>>        deliberate: (uid_t) -1 is used  in  several  interfaces  (e.g.,
>>        setreuid(2))  as  a  way  to  specify  "no  user  ID".  Leaving
>>        setreuid(2)) unmapped and unusuable guarantees that there  will
>          ^^^^ (uid_t) -1 (not setreuid(2)
>>        be no confusion when using these interfaces.
>>
>> Okay?
> 
> Other than the typo fix above this looks good.

Ahhh -- thanks for catching that, Eric. Fixed now.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
