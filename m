Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbaDWHZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:25:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:64010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756188AbaDWHZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,910,1389772800"; 
   d="scan'208";a="525389632"
Message-ID: <5357691E.5020007@intel.com>
Date: Wed, 23 Apr 2014 15:17:50 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: wsa@the-dreams.de, rjw@rjwysocki.net, awilliam@redhat.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Resend Patch 7/9] I2C/ACPI: Add i2c ACPI operation region support
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398147855-9868-8-git-send-email-tianyu.lan@intel.com> <20140422113638.GK30677@intel.com> <53571D11.3070808@intel.com> <20140423072839.GT30677@intel.com>
In-Reply-To: <20140423072839.GT30677@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年04月23日 15:28, Mika Westerberg wrote:
> On Wed, Apr 23, 2014 at 09:53:21AM +0800, Lan Tianyu wrote:
>> Hi Mika:
>> 	Thanks a lot for your review.
>>
>> On 2014年04月22日 19:36, Mika Westerberg wrote:
>>>>> +
>>>>> +	client.adapter = adapter;
>>>>> +	client.addr = sb->slave_address;
>>>>> +	client.flags = 0;
>>> I'm not sure if this is the correct way to use struct i2c_client
>>> (allocating it from stack and passing forward to functions that might
>>> expect a real i2c_client structure). It has ->dev and all.
>>
>> I check all i2c_smbus_xxx helper functions and they are simple wrappers
>> of i2c_smbus_xfer(). Only adapter, addr and flags of struct client are
>> used in these functions.
> 
> In that case I suppose it is OK to (ab)use the client structure like this.
> 
> I think you still want to initialize the whole structure (unused fields
> with zero) before passing it to the wrappers.
> 

Ok. I will do that.

-- 
Best regards
Tianyu Lan
