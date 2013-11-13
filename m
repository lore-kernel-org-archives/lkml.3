Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3KMAWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 19:22:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:62457 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab3KMAW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 19:22:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,688,1378882800"; 
   d="scan'208";a="432403011"
Message-ID: <5282C640.3030205@intel.com>
Date: Tue, 12 Nov 2013 16:22:24 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: shuah.kh@samsung.com
CC: akpm@linux-foundation.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384289478-9899-1-git-send-email-shuah.kh@samsung.com> <5282A7D5.7050406@intel.com> <5282A9C8.9050304@samsung.com>
In-Reply-To: <5282A9C8.9050304@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 02:20 PM, Shuah Khan wrote:
> On 11/12/2013 03:12 PM, Alexander Duyck wrote:
>> I think this might be overdoing the error checking by a bit.  I would
>> much rather have the DMA leaked error be visible than have it buried
>> under messages about the failure to check for DMA errors.  In my mind
>> the DMA buffer leak is much more serious than the failure to check for
>> mapping errors.
>>
>
> I agree DMA leak message is more important. Would you like to see just
> one message if mapping errors are found? Instead of printing the
> entire stacktrace like it does now, it could just do warn.
>
> -- Shuah
>
>

I think only one message would be preferred.  If nothing else you might
update the function so that it only dumps the DMA mapping error check on
the first one found and then goes quiet after that.  There is no point
in displaying the same error message multiple times since that is likely
what we would see.

Thanks,

Alex
