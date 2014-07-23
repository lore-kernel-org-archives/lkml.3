Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaGWEG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:06:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59959 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbaGWEG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:06:57 -0400
Message-ID: <53CF34B8.6000602@ti.com>
Date: Wed, 23 Jul 2014 09:36:16 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>, <paul@pwsan.com>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <j-keerthy@ti.com>,
        <rogerq@ti.com>
Subject: Re: [PATCH 0/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific
 ocp interface lists
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com> <53CE952D.6040705@ti.com>
In-Reply-To: <53CE952D.6040705@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nishanth,
On Tuesday 22 July 2014 10:15 PM, Nishanth Menon wrote:
> On 07/16/2014 03:36 AM, Lokesh Vutla wrote:
>> This series add seperate ocp interface lists that are specific to dra74x
>> and dra72x, and moving USB OTG SS4 to dra74x only since its not present
>> in dra72x. Without this USB OTG SS4 hwmod gives an abort on dra72x.
>>
>> Adding support for soc_is_dra74x() and soc_is_dra72x() in order to differentiate
>> between dra74x and dra72x and pass the respective ocp interface lists.
>>
>> Verified on dra74x evm and dra72x evm using 3.16-rc5 based mainline kernel.
>>
>> Before:
>> dra74x : http://paste.ubuntu.com/7802364/ 
>> dra72x : http://paste.ubuntu.com/7802334/ (Kernel panic)
>>
>> After-
>> dra74x : http://paste.ubuntu.com/7802340/
>> dra72x : http://paste.ubuntu.com/7802338/ (booted)
>>
>> Rajendra Nayak (2):
>>   ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x()
>>     varients
>>   ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
>>
>>  arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
>>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
>>  arch/arm/mach-omap2/soc.h                 |    7 +++++++
>>  3 files changed, 30 insertions(+), 2 deletions(-)
>>
> Tested-by: Nishanth Menon <nm@ti.com>
Thanks..
> 
> BUT, I suggest a follow up series to do exactly the same (moving stuff
> that are not common from dra7.dtsi to dra72x.dtsi and 74x.dtsi) as
> well to ensure that dts indicates exactly the same information (only
> the applicable IPs are present in dts).
The separation of dra72x.dtsi and dra74x.dtsi is already happened and the patch is
already present in mainline[1].
Looks like usb_otg_ss4 is still present in dra7.dtsi, but this should go into dra74x.dtsi.
I ll take it up.

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=38b248db60e32734417534b57f9ab687c445113a

Thanks and regards,
Lokesh

> 

