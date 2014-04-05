Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbaDECfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 22:35:08 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33944 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaDECfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 22:35:07 -0400
Message-ID: <533F6BD7.4000301@gmail.com>
Date: Fri, 04 Apr 2014 20:35:03 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bad DMA from Marvell 9230
References: <1395903457.5569.89.camel@pasglop> <20140327151915.GF18503@htj.dyndns.org>
In-Reply-To: <20140327151915.GF18503@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/03/14 09:19 AM, Tejun Heo wrote:
> On Thu, Mar 27, 2014 at 05:57:37PM +1100, Benjamin Herrenschmidt wrote:
>> I've contacted Marvell, but I was wondering if anybody here had already
>> experienced something similar or has an idea of what else the chip
>> might be doing wrong so we can try to find a workaround ?
>
> No idea.  First time to hear such problem. :(
>

There are other Marvell controllers that do DMA requests from the wrong 
PCI function ID and cause IOMMU issues, so it seems like testing on such 
systems (or just validating the DMA transactions done by the controller 
by some other means) isn't something that Marvell likes to do. 
Presumably reading from address 0 is normally fine without an IOMMU, so 
this problem wouldn't be noticed otherwise.
