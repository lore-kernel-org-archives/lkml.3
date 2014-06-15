Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaFODgr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:36:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39781 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaFODgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:36:45 -0400
Message-ID: <539D14CA.1060105@gmail.com>
Date: Sat, 14 Jun 2014 20:36:42 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] OF: fix of_find_node_by_path() assumption that of_allnodes
 is root
References: <539A91E2.7000606@gmail.com> <CAL_JsqJ+f0CjwGnqTzXjMOAvbDOf0O3BZgcQwrzaWBy9Gwiw8A@mail.gmail.com> <CACxGe6sG+h7j9Npd-xR4-E13i=_p8OtbisgJv1PUzf981nGHUw@mail.gmail.com> <CACxGe6tv8H8yUYCs9N959T3KKDUDiDqJQ1LRfO5RJE3bxw5r5A@mail.gmail.com>
In-Reply-To: <CACxGe6tv8H8yUYCs9N959T3KKDUDiDqJQ1LRfO5RJE3bxw5r5A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/2014 8:00 AM, Grant Likely wrote:
> On Fri, Jun 13, 2014 at 4:06 PM, Grant Likely <grant.likely@linaro.org> wrote:
>> On Fri, Jun 13, 2014 at 2:52 PM, Rob Herring <robherring2@gmail.com> wrote:
>>> On Fri, Jun 13, 2014 at 12:53 AM, Frank Rowand <frowand.list@gmail.com> wrote:
>>>> From: Frank Rowand <frank.rowand@sonymobile.com>
>>>>
>>>> Pantelis Antoniou reports that of_find_node_by_path() is borked because
>>>> of_allnodes is not guaranteed to contain the root of the tree after using
>>>> any of the dynamic update functions because some other nodes ends up as
>>>> of_allnodes.
>>>>
>>>> Fixes: c22e650e66b8 of: Make of_find_node_by_path() handle /aliases
>>>
>>> Is it not possible to do a fix in of_find_node_by_path instead? I just
>>> wonder if this could have any other unintended side-effects on
>>> of_attach_node's behavior.
>>
>> Given that I'm going to replace the custom list with list_head which
>> makes this problem go away, I think this solution is fine.
>>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
> 
> That said, the following might be better because it would guarantee
> that children always appear after parents...

< snip >

I agree, I like that better.  Patch respun, v2 will be sent as a reply
to this email.

Pantelis, can you test v2 please?

Thanks,

Frank

