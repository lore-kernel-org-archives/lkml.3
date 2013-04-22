Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3DVBSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:18:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60127 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3DVBSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:18:50 -0400
Message-ID: <51748FEF.7050703@ti.com>
Date: Sun, 21 Apr 2013 20:18:39 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <5171C8F6.6010702@ti.com> <51724393.1060608@metafoo.de> <201304201238.08908.arnd@arndb.de>
In-Reply-To: <201304201238.08908.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.1.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/20/2013 05:38 AM, Arnd Bergmann wrote:
> On Saturday 20 April 2013, Lars-Peter Clausen wrote:
>> On 04/20/2013 12:45 AM, Jon Hunter wrote:
>>> I think that there is a problem here. For controllers using the
>>> of_dma_simple_xlate(), this will call dma_request_channel() which also
>>> uses a mutex.
>>
>> That would only be a problem if it'd use the same mutex. Holding two mutexes at
>> the same time is not a problem per se.
>>
> 
> I guess Jon originlly tried it with a spinlock as the outer lock, which indeed
> does not work, but the new version does not have this problem.

Yes the spinlock was a problem and hence for the put/get functions. Ok
so that's fine then.

Cheers
Jon
