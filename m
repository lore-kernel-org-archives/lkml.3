Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbbAPS0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:26:04 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:63451 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbAPS0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:26:02 -0500
Message-ID: <54B957B5.8000202@gmail.com>
Date: Fri, 16 Jan 2015 19:25:57 +0100
From: Piotr Karbowski <piotr.karbowski@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] rename() from outside of the target dir breaks /proc exe
 symlink.
References: <549EEEEA.1050306@gmail.com> <20141227181412.GG22149@ZenIV.linux.org.uk> <54A329C1.9030704@gmail.com>
In-Reply-To: <54A329C1.9030704@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 11:40 PM, Piotr Karbowski wrote:
> Hi Al,
>
> On 12/27/2014 07:14 PM, Al Viro wrote:
>> That's because it never _had_ worked.  Note that opening the damn thing
>> will give the right file - it does not work by traversing the result of
>> readlink(2).  readlink(2) output on those is not promised to be useful
>> in all cases; often enough it is, but it won't work on cross-directory
>> renames, it can't be used to tell a filename that really ends with "
>> (deleted)"
>> from a removed file, etc.  Moreover, it only very recently became
>> usable for
>> victim names with the last component longer than 40 characters if you
>> did an
>> overwriting rename.
>>
>> What are you trying to use it for?
>
> I am using it to track the origin of running processes. I am working
> with continuous integration of a Linux embedded software. The tests goes
> in Linux containers, multiple instances of binary with the same name in
> a single container/namespace, all with cwd symlink pointing to / which
> looks from outside virtually the same, the binaries are modified at
> runtime by coping, modifing and replacing for another execution of the
> same binary (using patchelf to add additional NEEDED to header or change
> rpath or dynamic loader and such).
>
> In my very usecase, the exe symlink is essential.

*Friendly bump*

Can anything be done about it or is there any other mechanism that I 
could use to get origin of the running binary?

-- Piotr.

