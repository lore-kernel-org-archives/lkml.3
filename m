Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbaEQNNo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:13:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:1078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660AbaEQNNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,859,1392192000"; 
   d="scan'208";a="540675690"
Message-ID: <5377607F.9010800@intel.com>
Date: Sat, 17 May 2014 21:13:35 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: rjw@rjwysocki.net, mika.westerberg@linux.intel.com, awilliam@redhat.com,
        lenb@kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch V2 5/9] I2C: Add smbus quick read/write helper function
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-1-git-send-email-tianyu.lan@intel.com> <1398695268-28645-6-git-send-email-tianyu.lan@intel.com> <20140517094120.GA2602@katana>
In-Reply-To: <20140517094120.GA2602@katana>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 05:41 PM, Wolfram Sang wrote:
> On Mon, Apr 28, 2014 at 10:27:44PM +0800, Lan Tianyu wrote:
>> Add i2c_smbus_quick_write/read() helper function. These will be used
>> in the implementation of i2c ACPI address space handler.
>>
>> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>
> We had such a function once but removed because of no users. Please
> check 67c2e66571c383404a5acd08189194da660da942 what it takes to bring
> them back. Especially missing are documentation updates...
>
>> +s32 i2c_smbus_quick_write(const struct i2c_client *client)
>
> ... and I like the original function much better.
>
> 1) It is named *_write_quick which follows other function name patterns
> 2) It uses a parameter for the r/w bit. Make sense to me, since this bit
> is the information we send to the device. quick_read doesn't make sense
> to me. We don't receive a bit from the device.
>

Hi Wolfram:
	Great thanks for your review. Ok. I will follow commit 67c2e665 to bring 
i2c_smbus_write_quick(struct i2c_client *client, u8 value) back.

BTW, how about i2c_probe_func_quick_read()? Should we replace it with the 
original i2c_smbus_write_quick()?

	

