Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3JHA1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:27:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46511 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3JHA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:26:59 -0400
Message-ID: <52535151.2000508@codeaurora.org>
Date: Mon, 07 Oct 2013 17:26:57 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>
CC: linux-arm-msm@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: Use of drivers/platform and matching include?
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <CAOesGMjJ6Uj0uGFJqtnWQyDW+tr6eLVWoHZ+B7uFna+L8N6E8Q@mail.gmail.com> <20131004114128.GL12758@n2100.arm.linux.org.uk> <20131004132209.GB23923@kroah.com> <CAOesGMjxwmr0Vo0Puc-nZntgXLy6D1PTohz=C+fFukP_Eu1iQg@mail.gmail.com> <20131005171323.GB5780@kroah.com>
In-Reply-To: <20131005171323.GB5780@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2013 10:13 AM, Greg Kroah-Hartman wrote:
> On Fri, Oct 04, 2013 at 09:48:41AM -0700, Olof Johansson wrote:
>> On Fri, Oct 4, 2013 at 6:22 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>> On Fri, Oct 04, 2013 at 12:41:28PM +0100, Russell King - ARM Linux wrote:
>>>> So, no, there will be no new drivers under arch/arm.  They must be in the
>>>> drivers subtree somewhere.
>>> I have no objection with this, and encourage it.
>> Ok, so these are some of the requirements as far as I see it:
>>
>> * No per-vendor driver dumping ground under drivers/* (i.e. no
>> drivers/platform/<soc vendor>/)
> Yes.

We agree that there is no need for a dump *all* drivers under 
arm/mach-foo in drivers/platform/foo/. The msm bus driver would be added 
under drivers/bus/. But, we still have some drivers which are quite SoC 
specific and not in the general category of the sub-directories present 
under drivers.
As Kumar mentioned earlier -

An example driver would be the means we utilize to communicate memory regions between various HW blocks on the SoC.  So a video/media core driver might need access to a header/functions from the memory region driver.

Would drivers/misc/qcom-* or drivers/misc/qcom/* be a reasonable place to add them ? and the headers could go into include/linux/qcom-*.h

<snip>

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

