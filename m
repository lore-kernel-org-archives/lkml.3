Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaDAPdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:33:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbaDAPdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:33:23 -0400
Message-ID: <533ADC3A.6090800@oracle.com>
Date: Tue, 01 Apr 2014 11:33:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: liblockdep soname versioning
References: <CA+5PVA67oBeHUiPXj0viNgrX+uDnJ9LsZSPXF1cLt_D511KKtA@mail.gmail.com>	<533ABCCB.4090502@oracle.com> <CA+5PVA7eiCX_DHqkFx8t86naqs6o=rVcm0Ok5E2Pw9kXhSD_jg@mail.gmail.com> <533AC08F.6020909@oracle.com>
In-Reply-To: <533AC08F.6020909@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 09:35 AM, Sasha Levin wrote:
> On 04/01/2014 09:28 AM, Josh Boyer wrote:
>> On Tue, Apr 1, 2014 at 9:19 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> On 04/01/2014 08:56 AM, Josh Boyer wrote:
>>>>
>>>> Hi Sasha,
>>>>
>>>> We've had a request [1] to package up liblockdep in Fedora.  Looking
>>>> things over, I noticed the library isn't actually versioned at all and
>>>> instead just builds a plain .so file.  That's likely fine during
>>>> development of it, but if distros are to ship it for broader use then
>>>> it would be a good idea to specify the soname and use a versioned .so.
>>>>
>>>> The makefile already has LIBLOCKDEP_VERSION defined.  Would it be
>>>> possible to use this as the soname and version number?  Then
>>>> liblockdep.so could be the normal symlink to the versioned .so
>>>> (liblockdep.so.0.0.1 in this case).
>>>>
>>>> Thanks.
>>>>
>>>> josh
>>>>
>>>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1082763
>>>>
>>>
>>> Sure! I never expected it to live outside the kernel tree as a separate
>>> package, but I'm happy to accommodate for that.
>>>
>>> I think that I'll just match the version number with the kernel version
>>> since what mostly matters is what you have in kernel/lockdep.c, so for
>>> example, right now we'll have 'liblockdep.so.3.15.0'. Sounds good?
>>
>> The only concern I would have is that it would require applications
>> linking to it to rebuild with every kernel release even if nothing
>> else changed.  Maybe nothing changing is going to be rare enough that
>> in practice people will need to rebuild anyway.  Either way, it's
>> better to be explicit rather than break users silently, so it sounds
>> good to me.
>
> I don't think we ever had a kernel version without changes to lockdep :)
>
> Since lockdep isn't an ABI either, no one promises me it'll work the same
> way between versions either, so I'm kinda happy about just forcing rebuilds.

Hi Josh,

Could you please confirm that the below is what you'd expect it to be:

sasha@lappy:~/linux/tools/lib/lockdep$ make
   CC FPIC            common.o
   CC FPIC            lockdep.o
   CC FPIC            preload.o
   CC FPIC            rbtree.o
   BUILD STATIC LIB   liblockdep.a
   BUILD SHARED LIB   liblockdep.so.3.14.0

sasha@lappy:~/linux/tools/lib/lockdep$ ls -al liblockdep.so
lrwxrwxrwx 1 sasha sasha 20 Apr  1 11:31 liblockdep.so -> liblockdep.so.3.14.0

sasha@lappy:~/linux/tools/lib/lockdep$ readelf -d liblockdep.so  | grep SONAME
  0x000000000000000e (SONAME)             Library soname: ["liblockdep.so.3.14.0"]

Thanks,
Sasha


