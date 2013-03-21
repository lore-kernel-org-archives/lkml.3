Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3CUVwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:52:49 -0400
Received: from mout.web.de ([212.227.17.12]:61918 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab3CUVwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:52:47 -0400
Message-ID: <514B811E.2040209@web.de>
Date: Thu, 21 Mar 2013 22:52:30 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-mm@kvack.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, michael@amarulasolutions.com
Subject: Re: [PATCH] USB: EHCI: fix for leaking isochronous data
References: <Pine.LNX.4.44L0.1303171320560.26486-100000@netrider.rowland.org> <514B3DBB.3060302@web.de> <20130321173324.GY13280@titan.lakedaemon.net> <201303211910.31473.arnd@arndb.de>
In-Reply-To: <201303211910.31473.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:JXEoe7exgfKJIuddMzOnqNZFoXne2C/gx8r2Dq7DeGR
 lNuwzDC6+6z2rWic/DdQj/MmfSM7Wcm65MuU0ARB06AKX3on3l
 SNp805T2JIDwlloBK0lPgoMSMchvjxeVKLN5AdSCMwYJyBpX8x
 AQRy+ZWEKYYdDUxGuinHANJ2oXJVessq0VyjqJouUpkRA60IEg
 ePNzOeyieL+OwZF/LCAUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.03.2013 20:10, Arnd Bergmann wrote:
> On Thursday 21 March 2013, Jason Cooper wrote:
>> On Thu, Mar 21, 2013 at 06:04:59PM +0100, Soeren Moch wrote:
>
>>>
>>> Now I found out what is going on here:
>>>
>>> In itd_urb_transaction() we allocate 9 iTDs for each URB with
>>> number_of_packets == 64 in my case. The iTDs are added to
>>> sched->td_list. For a frame-aligned scheduling we need 8 iTDs, the
>>> 9th one is released back to the front of the streams free_list in
>>> iso_sched_free(). This iTD was cleared after allocation and has a
>>> frame number of 0 now. So for each allocation when now_frame == 0 we
>>> allocate from the dma_pool, not from the free_list. The attached
>>> patch invalidates the frame number in each iTD before it is sent to
>>> the scheduler. This fixes the problem without the need to iterate
>>> over a iTD list.
>>>
>>> Signed-off-by: Soeren Moch <smoch@web.de>
>>
>> Wow!  Great work Soeren!  Talk about a long road to a small fix.  Thanks
>> for keeping after it.
>
> +1
>
> I hardly understand half of the description above, but that much sounds
> plausible. Is this a bug fix that should get backported to stable kernels?
>
> 	Arnd
>
I think this patch should go to stable kernels, too. But I'm not an 
expert here...

   Soeren
