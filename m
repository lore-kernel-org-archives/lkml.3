Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3DTHZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:25:50 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:61517 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754272Ab3DTHZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:25:49 -0400
Message-ID: <51724393.1060608@metafoo.de>
Date: Sat, 20 Apr 2013 09:28:19 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dma:of: Use a mutex to protect the of_dma_list
References: <1366364534-3298-1-git-send-email-lars@metafoo.de> <1366364534-3298-2-git-send-email-lars@metafoo.de> <5171C8F6.6010702@ti.com>
In-Reply-To: <5171C8F6.6010702@ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2013 12:45 AM, Jon Hunter wrote:
[...]
>> @@ -219,15 +183,15 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
>>  		if (of_dma_match_channel(np, name, i, &dma_spec))
>>  			continue;
>>  
>> -		ofdma = of_dma_get_controller(&dma_spec);
>> +		mutex_lock(&of_dma_lock);
>> +		ofdma = of_dma_find_controller(&dma_spec);
>>  
>> -		if (ofdma) {
>> +		if (ofdma)
>>  			chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
> 
> I think that there is a problem here. For controllers using the
> of_dma_simple_xlate(), this will call dma_request_channel() which also
> uses a mutex.

That would only be a problem if it'd use the same mutex. Holding two mutexes at
the same time is not a problem per se.

- Lars
