Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaEWLNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:13:36 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:47318 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEWLNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:13:35 -0400
Message-ID: <537F2D53.5020408@mentor.com>
Date: Fri, 23 May 2014 12:13:23 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        =?UTF-8?B?J0Jqw7hybiBNb3JrJw==?= <bjorn@mork.no>
CC: "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "kamal@canonical.com" <kamal@canonical.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>, "fw@strlen.de" <fw@strlen.de>
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com>	<1400792295.5367.174.camel@edumazet-glaptop2.roam.corp.google.com>	<063D6719AE5E284EB5DD2968C1650D6D1724C490@AcuExch.aculab.com> <87r43k4yhe.fsf@nemi.mork.no> <063D6719AE5E284EB5DD2968C1650D6D1724C7A1@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1724C7A1@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 23 May 2014 11:13:25.0378 (UTC) FILETIME=[0416A620:01CF7678]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/14 11:45, David Laight wrote:
> From: Bjørn Mork [mailto:bjorn@mork.no]
>> David Laight <David.Laight@ACULAB.COM> writes:
> ...
>>> Note that some of the usb ethernet drivers allocate large skb then
>>> lie about the truesize.
>>
>> Hmm, which drivers are these?
> 
> $ grep truesize linux/drivers/net/usb/*
> 
> asix_88179_178a, smsc95xx, sr9700.
> 
> 	David
> 


What are the side effects of changing the truesize, if the original
uncloned skb has the full truesize then isn't the potential memory usage
still counted for the avoidance of OOM?

I suppose if the uncloned skb is deleted you would then have a problem
so a chain of URB's would be the safest solution.

Jim
