Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3FDWZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:25:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3FDWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:25:54 -0400
Message-ID: <51AE6964.1090002@oracle.com>
Date: Tue, 04 Jun 2013 17:25:40 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: jfs-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jfs: Convert jfs_error to jfs_sb_err
References: <76a131f2845ec3f75dd80be6808e513ae3ea4255.1370323137.git.joe@perches.com>  <51AE0F37.3020104@oracle.com> <1370363289.2385.41.camel@joe-AO722>
In-Reply-To: <1370363289.2385.41.camel@joe-AO722>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 11:28 AM, Joe Perches wrote:
> On Tue, 2013-06-04 at 11:00 -0500, Dave Kleikamp wrote:
>> I generally like this cleanup except for one thing.
>>
>> On 06/04/2013 12:22 AM, Joe Perches wrote:
>>> Use a more current logging style.
>>>
>>> Rename function jfs_error to jfs_sb_err.
>>
>> Why the rename? If you're going to rename it, the new name should be
>> more descriptive, such as jfs_report_and_handle_error(), but I don't
>> like that because it's too long. jfs_error() is similiar to ext4_error()
>> or btrfs_error(). I don't understand the name change.
> 
> Pick a name.  I don't much care what it is really.

I'm just going to stick with jfs_error, since I'm not convinced changing
the name has any benefit.

> This one takes a super_block * and emits a logging message
> so I chose jfs_sb_err to try to describe the sb * bit.
> 
> I like the _err suffix is a bit better than the
> _error suffix as it's a bit more name consistent
> with other kernel logging mechanisms like dev_err,
> pr_err, etc, but if you want to remain consistent
> with other fs/,,, fine by me.

It's more than a logging mechanism. It will also make the file-system
read-only, or panic (or do nothing else) depending on the errors= mount
option.

> I think the other fs _error names are sub-optimal.

They perform a similar function, so I'm going to leave it as is. Even if
the names are imperfect, it's good to have some similarities in the
names of the functions between file systems.

> These functions are a bit overloaded too when
> CONFIG_PRINTK is not enabled.  The format and args
> still exist in code and I believe can not be
> optimized away by the compiler
> 
> I think using macro or an in-place expansion to
> separate the 2 parts of the reporting and then the
> handling of of the error would be better as it
> would allow smaller embedded use.

I can hold off on this a little while if you want to explore that idea
as an alternate.

>>> Add __printf format and argument verification.
>>
>> good
> 
> I submitted a patch a few years ago to do that too.
> Dunno what happened to it,

I might have put it off and then forgot about it. I don't remember it
specifically.

> 
>>> Remove embedded function names from formats.
>>> Add %pf, __builtin_return_address(0) to jfs_sb_err.
>>
>> I like this.
> 
> It also reduces stack needs a bit by removing that
> 256 byte temp buffer.

