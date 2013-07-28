Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3G1PJI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 11:09:08 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:36104 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab3G1PJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 11:09:06 -0400
Message-ID: <51F5340A.1090901@metafoo.de>
Date: Sun, 28 Jul 2013 17:08:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] dma: pl330: Fix cyclic transfers
References: <1374567890-27593-1-git-send-email-lars@metafoo.de> <20130728134546.GE1986@intel.com>
In-Reply-To: <20130728134546.GE1986@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2013 03:45 PM, Vinod Koul wrote:
> On Tue, Jul 23, 2013 at 10:24:50AM +0200, Lars-Peter Clausen wrote:
>> Allocate a descriptor for each period of a cyclic transfer, not just the first.
>> Also since the callback needs to be called for each finished period make sure to
>> initialize the callback and callback_param fields of each descriptor in a cyclic
>> transfer.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Applied thanks
>

Thanks.

> Btw the switch moved should have return error for default case when direction is
> not slave, but thats not in context of this as you moved that code

Checking inside the loop makes the error handling more complicated since at 
that point the descriptor is already allocated and needs to be freed again. So 
we check this right at the beginning (Using is_slave_direction), so we'll never 
get to the loop if the direction is not OK. The default statement is mainly 
there to keep the compiler happy.

- Lars


