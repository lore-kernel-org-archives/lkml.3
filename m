Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaBXNuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:50:04 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42427 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaBXNuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:50:00 -0500
Message-ID: <530B4E05.4020900@schaman.hu>
Date: Mon, 24 Feb 2014 13:49:57 +0000
From: Zoltan Kiss <zoltan.kiss@schaman.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: wei.liu2@citrix.com, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v5 4/9] xen-netback: Change RX path for mapped
 SKB fragments
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>	 <1390253069-25507-5-git-send-email-zoltan.kiss@citrix.com> <1392745532.23084.65.camel@kazak.uk.xensource.com> <53093051.9040907@citrix.com>
In-Reply-To: <53093051.9040907@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/02/14 23:18, Zoltan Kiss wrote:
> On 18/02/14 17:45, Ian Campbell wrote:
>> On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
>>
>> Re the Subject: change how? Perhaps "handle foreign mapped pages on the
>> guest RX path" would be clearer.
> Ok, I'll do that.
>
>>
>>> RX path need to know if the SKB fragments are stored on pages from 
>>> another
>>> domain.
>> Does this not need to be done either before the mapping change or at the
>> same time? -- otherwise you have a window of a couple of commits where
>> things are broken, breaking bisectability.
> I can move this to the beginning, to keep bisectability. I've put it 
> here originally because none of these makes sense without the previous 
> patches.
Well, I gave it a close look: to move this to the beginning as a 
separate patch I would need to put move a lot of definitions from the 
first patch to here (ubuf_to_vif helper, xenvif_zerocopy_callback etc.). 
That would be the best from bisect point of view, but from patch review 
point of view even worse than now. So the only option I see is to merge 
this with the first 2 patches, so it will be even bigger. And based on 
that principle, patch #6 and #8 should be merged there as well, as they 
solve corner cases introduced by the grant mapping.
I don't know how much the bisecting requirements are written in stone. 
At this moment, all the separate patches compile, but after #2 there are 
new problems solved in #4, #6 and #8. If someone bisect in the middle of 
this range and run into these problems, they could quite easily figure 
out what went wrong looking at the adjacent patches. So I would 
recommend to keep this current order.
What's your opinion?

Zoli
