Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab3JYGXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 02:23:50 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15831 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JYGXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 02:23:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 24 Oct 2013 23:23:35 -0700
Message-ID: <526A0E71.100@nvidia.com>
Date: Fri, 25 Oct 2013 15:23:45 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: Any news on Runtime Interpreted Power Sequences
References: <20131025112224.6e5265e6@notabene.brown>
In-Reply-To: <20131025112224.6e5265e6@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

On 10/25/2013 09:22 AM, NeilBrown wrote:
>   I'm wondering if there was any news on the Runtime Interpreted Power
> Sequences?
> The most recent news I can find is
>    https://lkml.org/lkml/2013/4/27/73
> where you say they might be ready for 3.11.  Clearly that didn't work
> (predictions being hard, especially about the future).
>
> I'm really keen to see them turning into a reality and I gather others are
> too. So ... can we hope?

A prerequisite of power sequences was to merge the gpiod interface, and 
this is finally happening. It took much longer than I wanted, sorry 
about that.

Logically speaking nothing should now stand in the way of a new version 
of the power sequences. Expected maybe my own skepticism about them.

The first version of the power seqs is mainly the result of my 
misunderstanding of the device tree. Reconsidering it now, if we strip 
the DT support away power seqs would just become a simplified way to 
describe how to power a device up and down. In other words, it would be 
another way to express what can be expressed with C code and would not 
bring any additional flexibility that DT-described power seqs would have 
(and I say this totally convinced now that power sequences in the device 
tree were a bad idea).

The advantage I could see is that using power sequences we could get rid 
of the cumbersome and mistake-prone error checking code which is 
basically the same for most devices. You would just need to describe 
what you want to activate, and in which order, and the power seqs 
framework would catch and report any error.

I'm not sure if this is a sufficient reason to introduce another 
framework into the kernel, but if this is deemed a good reason by more 
experienced people then I'm ok to give it a shot. If you have other 
motivations for this, please also state them so I can get the whole 
picture. Maybe I just need to be a little bit more motivated about this 
idea myself. :)

Thanks,
Alex.

