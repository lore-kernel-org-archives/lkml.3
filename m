Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaBQVKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:10:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:49081 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaBQVKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:10:52 -0500
Message-ID: <53027AD5.7060808@oracle.com>
Date: Mon, 17 Feb 2014 22:10:45 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: inotify cookie regression/info leak in latest mainline
References: <52FFDE9A.2030109@oracle.com> <20140217125954.GD3686@quack.suse.cz>
In-Reply-To: <20140217125954.GD3686@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 01:59 PM, Jan Kara wrote:
>    Hello,
>
> On Sat 15-02-14 22:39:38, Vegard Nossum wrote:
>> It would seem that
>>
>> commit 7053aee26a3548ebaba046ae2e52396ccf56ac6c
>> Author: Jan Kara <jack@suse.cz>
>> Date:   Tue Jan 21 15:48:14 2014 -0800
>>
>>      fsnotify: do not share events between notification groups
>>
>> introduced a bug where the cookie field of struct inotify_event
>> never gets initialised. In particular, it used to be initialised
>> when send_to_group() called fsnotify_create_event(), but that no
>> longer happens, and the 'cookie' parameter of send_to_group() never
>> gets used.
>>
>> The problem manifests itself in copy_event_to_user() where the
>> cookie field is copied to userspace without being initialised.
>>
>> I tested this with a simple userspace program, I seem to get mostly
>> 0xffff8800 in the cookie field for non-move events (which should
>> always have 0 here).
>    That's a really embarassing bug. I've extented LTP inotify tests to
> verify the cookie value is sane (so far the tests completely ignored the
> value which is why I didn't notice the breakage).
>
> Attached patch fixes the problem for me. I'll send it to Linus tomorrow.
> Thanks for spotting the problem!

That seems to fix it for me too, thanks for the quick fix!


Vegard
