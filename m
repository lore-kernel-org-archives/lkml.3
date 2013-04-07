Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161279Ab3DGAsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 20:48:12 -0400
Received: from mail-ia0-f176.google.com ([209.85.210.176]:57067 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161181Ab3DGAsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 20:48:11 -0400
Message-ID: <5160C244.6080807@gmail.com>
Date: Sun, 07 Apr 2013 08:48:04 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andrew Shewmaker <agshew@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        ric.masonn@gmail.com
Subject: Re: [PATCH v7 2/2] mm: replace hardcoded 3% with admin_reserve_pages
 knob
References: <20130325134247.GB1393@localhost.localdomain> <515CF884.8010103@gmail.com> <CAF-E8XFQFm9GrBnkax+TiByUPHxp=Ukp1LcuAWjYL0OeLE1Saw@mail.gmail.com>
In-Reply-To: <CAF-E8XFQFm9GrBnkax+TiByUPHxp=Ukp1LcuAWjYL0OeLE1Saw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
On 04/05/2013 11:02 PM, Andrew Shewmaker wrote:
> On Wed, Apr 3, 2013 at 9:50 PM, Simon Jeons <simon.jeons@gmail.com> wrote:
>>> FAQ
>>>
> ...
>>>    * How do you calculate a minimum useful reserve?
>>>
>>>      A user or the admin needs enough memory to login and perform
>>>      recovery operations, which includes, at a minimum:
>>>
>>>      sshd or login + bash (or some other shell) + top (or ps, kill, etc.)
>>>
>>>      For overcommit 'guess', we can sum resident set sizes (RSS).
>>>      On x86_64 this is about 8MB.
>>>
>>>      For overcommit 'never', we can take the max of their virtual sizes
>>> (VSZ)
>>>      and add the sum of their RSS.
>>>      On x86_64 this is about 128MB.
>>
>> 1.Why has this different between guess and never?
> The default, overcommit 'guess' mode, only needs a reserve for
> what the recovery programs will typically use. Overcommit 'never'
> mode will only successfully launch an app when it can fulfill all of
> its requested memory allocations--even if the app only uses a
> fraction of what it asks for.

VSZ has already cover RSS, is it? why account RSS again?

>
>> 2.You just test x86/x86_64, other platforms also will use memory overcommit,
>> did you test them?
> No, I haven't. Unfortunately, I don't currently have any other platforms to test
> with. I'll see what I can do.
>
> Thanks,
>
> Andrew

