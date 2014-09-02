Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaIBRVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:21:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42934 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaIBRVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:21:22 -0400
Message-ID: <5405FCBF.2050100@arm.com>
Date: Tue, 02 Sep 2014 18:22:07 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Herrmann <dh.herrmann@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] drivers: base: add cpu_device_create to support per-cpu
 devices
References: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com> <1408706963-23195-1-git-send-email-sudeep.holla@arm.com>
In-Reply-To: <1408706963-23195-1-git-send-email-sudeep.holla@arm.com>
X-OriginalArrivalTime: 02 Sep 2014 17:21:17.0915 (UTC) FILETIME=[4E7B02B0:01CFC6D2]
X-MC-Unique: 114090218212000501
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 22/08/14 12:29, Sudeep Holla wrote:
> From: Sudeep Holla <sudeep.holla@arm.com>
>
> This patch adds a new function to create per-cpu devices.
> This helps in:
> 1. reusing the device infrastructure to create any cpu related
>     attributes and corresponding sysfs instead of creating and
>     dealing with raw kobjects directly
> 2. retaining the legacy path(/sys/devices/system/cpu/..) to support
>     existing sysfs ABI
> 3. avoiding to create links in the bus directory pointing to the
>     device as there would be per-cpu instance of these devices with
>     the same name since dev->bus is not populated to cpu_sysbus on
>     purpose
>
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/base/cpu.c  | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/cpu.h |  4 ++++
>   2 files changed, 58 insertions(+)
>
> Hi Greg,
>
> Here is the alternate solution I could come up with instead of
> creating cpu class. cpu_device_create is very similar to
> device_create_groups_vargs w/o class support, but I could not
> reuse anything else to avoid creating similar function.
>
> Let me know your thoughts/suggestions on this.
>

Any feedback on this ? If ok, I will respin cacheinfo series removing
cpu class creation with this patch.

Regards,
Sudeep

