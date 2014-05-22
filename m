Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaEVB1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:27:09 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40048 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEVB1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:27:06 -0400
Message-ID: <537D5264.7070301@gmail.com>
Date: Wed, 21 May 2014 18:27:00 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        David Daney <david.daney@cavium.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 2/3] of: Make of_find_node_by_path() handle /aliases
References: <1399993115-21552-1-git-send-email-grant.likely@linaro.org> <1399993115-21552-3-git-send-email-grant.likely@linaro.org> <537C15B1.3020006@gmail.com> <20140521160931.DD7F9C4198A@trevor.secretlab.ca>
In-Reply-To: <20140521160931.DD7F9C4198A@trevor.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2014 9:09 AM, Grant Likely wrote:
> On Tue, 20 May 2014 19:55:45 -0700, Frank Rowand <frowand.list@gmail.com> wrote:
>> On 5/13/2014 7:58 AM, Grant Likely wrote:
>>
>>> Make of_find_node_by_path() handle aliases as prefixes. To make this

< snip >

>>> ---
>>
>>>  drivers/of/base.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++----
>>
>>>  1 file changed, 56 insertions(+), 4 deletions(-)
>>
>>
>>
>> Was this patch created against a tree that has modifications to device tree
>>
>> locking?
>>   I get a hang due to deadlock when I apply it.  Patch to verify the
>> cause is below.
> 
> Ummm... I may have forgotten to enable CONFIG_LOCKDEP when testing. Try
> the following fix, and can you please pass me that brown paper bag.

Nononono, I need to keep the bag for my own future use :-)

The following fix looks good and boots successfully on the dragonboard.

-Frank

> 
> g.
> 
> commit 35e9c5ae6c3d0b5eb91579f397d8e1ecb95ee711
> Author: Grant Likely <grant.likely@linaro.org>
> Date:   Thu May 22 01:04:17 2014 +0900
> 
>     dt: Create unlocked version of for_each_child_of_node()
>     
>     When iterating over nodes, sometimes it needs to be done when the DT
>     lock is already held. This patch makes an unlocked version of the
>     for_each_child_of_node() macro.
>     
>     Signed-off-by: Grant Likely <grant.likely@linaro.org>

< snip >

