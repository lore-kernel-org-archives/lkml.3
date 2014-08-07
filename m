Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaHGOXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbaHGOXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:23:06 -0400
Message-ID: <53E38BC3.40500@redhat.com>
Date: Thu, 07 Aug 2014 15:22:59 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rob Jones <rob.jones@codethink.co.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@lists.codethink.co.uk, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [Linux-kernel] [PATCH] seq_file: Allow private data to be supplied
 on seq_open
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>	<20140806160259.GR18016@ZenIV.linux.org.uk>	<53E254F1.30605@codethink.co.uk> <87sil9sa50.fsf@x220.int.ebiederm.org> <53E37810.1050109@codethink.co.uk> <53E37FDF.50102@redhat.com> <53E38889.3000603@codethink.co.uk> <53E38A3A.5060605@codethink.co.uk>
In-Reply-To: <53E38A3A.5060605@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/08/14 15:16, Rob Jones wrote:
>
>
> On 07/08/14 15:09, Rob Jones wrote:
>> Hi Steve,
>>
>> On 07/08/14 14:32, Steven Whitehouse wrote:
>>> Hi,
>>>
>>> On 07/08/14 13:58, Rob Jones wrote:
>>> [snip]
>>>>
>>>> On a related subject, Having looked at a few uses of seq_file, I must
>>>> say that some users seem to make assumptions about the internal
>>>> workings of the module. Dangerous behaviour as only some behaviours 
>>>> are
>>>> documented.
>>>>
>>>> e.g. The behaviour that "struct seq_file" pointer is stored in
>>>> file->private_data is documented and can therefore be relied upon but
>>>> the fact that the output buffer and its size are only defined at the
>>>> first output (and can therefore be pre-defined and pre-allocated by
>>>> user code) is not documented and could therefore change without 
>>>> warning.
>>>>
>>>> This second behaviour is assumed in, for example, module 
>>>> fs/gfs2/glock.c
>>>> which could, therefore, stop working properly without warning if the
>>>> internal behaviour was changed.
>>>>
>>> While it is undocumented, it is I understand, how this feature was
>>> intended to be used, so I think that it is safe to do this in the GFS2
>>> case. Here is a ref to the thread which explains how it landed up like
>>> that:
>>> https://www.redhat.com/archives/cluster-devel/2012-June/msg00000.html
>>
>> No criticism was intended of that particular piece of code, It has been
>> there for a couple of years and is, presumably, still working :-)
>>
>> It was just a general point about things needing to be written down. A
>> behaviour such as you were relying on can be a very positive thing but
>> it would be of much greater use if it was written down in the file docs.
>>
>> I completely missed seq_file_private() because I was looking at the
>
> Sorry, that should be seq_open_private()
>
> Why does one never see the mistake until *after* hitting send?
>
Always the way, unfortunately!

>> docs more than the code. If it had been written down in the docs it
>> would have saved me quite a bit of time, similarly, if the buffer
>> allocation behaviour was documented, changes to seq_file.c would not be
>> made that could break your code.
>>
>> God knows, I'm not a fan of unnecessary documentation but where it's
>> useful I'm all for it.
>>
Yes, very much agreed, and no doubt it would be useful in this case. I 
hoped that the earlier thread might be a useful starting point, since it 
explained some of the whys and wherefores,

Steve.

