Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbaLJLB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:01:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44575 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaLJLB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:01:57 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-65-5488282241f8
Message-id: <54882821.2010106@samsung.com>
Date: Wed, 10 Dec 2014 12:01:53 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, lars@metafoo.de, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        l.czerwinski@samsung.com, kyungmin.park@samsung.com,
        k.kozlowski@samsung.com, padma.kvr@gmail.com
Subject: Re: [PATCH v2 0/2] dma: pl330: improve status checking
References: <1417767955-5480-1-git-send-email-r.baldyga@samsung.com>
 <20141209091609.GB16827@intel.com>
In-reply-to: <20141209091609.GB16827@intel.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xy7pKGh0hBu39QhbTp15gtFg99S+r
	xesXhhZnm96wW/yaNonNYsnk+awWl3fNYbNYe+Quu0X7sjmsFi/79rM4cHnsnHWX3WPxnpdM
	HkveHGL16NuyitHj8ya5ANYoLpuU1JzMstQifbsEroxDf68xFTxjr1h5VraBcQVbFyMnh4SA
	icTfg/OgbDGJC/fWA9lcHEICSxkl3rVPYYZwPjJKzNn1lBGkildAS+Ljul5mEJtFQFVi28bL
	YHE2AR2JLd8ngNmiAhESV9bMgaoXlPgx+R4LiC0CVL/lZwcjyFBmgZeMEntudIGtFhawl/i/
	ZTU7iC0kkCkxdfFnsDingL7ElmWdQMs4gBr0JO5f1AIJMwvIS2xe85Z5AqPALCQrZiFUzUJS
	tYCReRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSPh/2cG4+JjVIUYBDkYlHl5zxdYQIdbE
	suLK3EOMEhzMSiK8byQ7QoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwptz/c1DFKDznjJWCTs3d
	7MhdMw9bVTyo4P57aqvFSrEU5i8qE6Izll/+M+NelNbzlWJhsv8/VS5eY5e4XTXzlaCNmNyD
	gmx7A8Ebm849X/jvT5/zKTOJeldL5xOpF+617TDc/ZdxWe2qq3EXjJ8oyzGeuGbjrGguf0Kx
	56D1So/Db0si2OaJKLEUZyQaajEXFScCAL3yodNdAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/09/2014 10:16 AM, Vinod Koul wrote:
> On Fri, Dec 05, 2014 at 09:25:53AM +0100, Robert Baldyga wrote:
>> Hi,
>>
>> This series allows to check DMA transfer residue (number of bytes left
>> to send/receive) by modifying pl330_tx_status() function, when struct
>> dma_tx_state is filled with needed data. It also introduces DMA_PAUSE
>> feature, which allows to halt DMA transfer before termination and read
>> residue without risk of data loss.
>>
>> This features are needed for proper implementation of DMA transfers,
>> particulary for serial drivers when transfer sizes are unknown and
>> requests on DMA channels are terminated before transfer completion
>> very ofter (it's becouse we terminate then in timeout interrupt to
>> avoid latency which is usually undesirable).
> Applied, thanks
> 

I have found bug in my patches in series v2. There was double
pm_runtime_put() call. I have fixed it in v3, which is already sent to list.

Thanks,
Robert Baldyga
