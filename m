Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaAPRZh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:25:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56646 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaAPRZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:25:35 -0500
Message-ID: <52D8160B.7090205@wwwdotorg.org>
Date: Thu, 16 Jan 2014 10:25:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Phil Carmody <phil.carmody@partner.samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] i2c: Re-instate body of i2c_parent_is_i2c_adapter()
References: <1389648544-4201-1-git-send-email-swarren@wwwdotorg.org> <20140114161254.GA6442@katana>
In-Reply-To: <20140114161254.GA6442@katana>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 09:12 AM, Wolfram Sang wrote:
> On Mon, Jan 13, 2014 at 02:29:04PM -0700, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The body of i2c_parent_is_i2c_adapter() is currently guarded by
>> CONFIG_I2C_MUX instead.
> 
> This paragraph sounds strange to me. I'll update it a little. After that
> I'll go looking for a brown paper bag...
> 
>> Among potentially other problems, this resulted in i2c_lock_adapter()
>> only locking I2C mux child adapters, and not the parent adapter. In
>> turn, this could allow inter-mingling of mux child selection and I2C
>> transactions, which could result in I2C transactions being directed to
>> the wrong I2C bus, and possibly even switching between busses in the
>> middle of a transaction.
>>
>> One concrete issue caused by this bug was corrupted HDMI EDID reads
>> during boot on the NVIDIA Tegra Seaboard system, although this only
>> became apparent in recent linux-next, when the boot timing was changed
>> just enough to trigger the race condition.
>>
>> Fixes: 3923172b3d70 ("i2c: reduce parent checking to a NOOP in non-I2C_MUX case")
>> Cc: Phil Carmody <phil.carmody@partner.samsung.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> Applied to for-current, thanks for catching this one!

I do see this in for-current, but it looks like that branch isn't part
of linux-next. Should it be, or perhaps for-current should be merged
into for-next?
