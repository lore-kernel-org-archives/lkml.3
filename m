Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3BLXE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:04:28 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:62556 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3BLXE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:04:26 -0500
Message-ID: <511AC831.80704@gmail.com>
Date: Tue, 12 Feb 2013 23:54:41 +0100
From: Cyril Roelandt <tipecaml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        mugunthanvnm@ti.com, zonque@gmail.com, hotforest@gmail.com,
        Julia.Lawall@lip6.fr, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: remove redundant NULL check.
References: <1360706086-31506-1-git-send-email-tipecaml@gmail.com> <20130212.170650.89534546100043269.davem@davemloft.net>
In-Reply-To: <20130212.170650.89534546100043269.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 11:06 PM, David Miller wrote:
> From: Cyril Roelandt<tipecaml@gmail.com>
> Date: Tue, 12 Feb 2013 22:54:46 +0100
>
>> cpdma_chan_destroy() on a NULL pointer is a no-op, so the NULL check in
>> cpdma_ctlr_destroy() can safely be removed.
>>
>> Signed-off-by: Cyril Roelandt<tipecaml@gmail.com>
>   ...
>> @@ -450,8 +450,7 @@ int cpdma_ctlr_destroy(struct cpdma_ctlr *ctlr)
>>   		cpdma_ctlr_stop(ctlr);
>>
>>   	for (i = 0; i<  ARRAY_SIZE(ctlr->channels); i++) {
>> -		if (ctlr->channels[i])
>> -			cpdma_chan_destroy(ctlr->channels[i]);
>> +		cpdma_chan_destroy(ctlr->channels[i]);
>>   	}
>
> SInce this is now a single statement basic block, remove the
> surrounding braces.

Ok, I resent, though I forgot to add "v2".

Regards,
Cyril Roelandt.
