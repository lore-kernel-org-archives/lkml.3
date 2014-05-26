Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaEZSH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:07:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:15982 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaEZSH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545140612"
Message-ID: <538382FA.8070601@intel.com>
Date: Tue, 27 May 2014 02:07:54 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [staging: r8192ee] WARNING: CPU: 0 PID: 1 at net/mac80211/rate.c:43
 ieee80211_rate_control_register()
References: <538355D5.7010006@intel.com> <538374E4.7010401@lwfinger.net>
In-Reply-To: <538374E4.7010401@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 01:07 AM, Larry Finger wrote:
> On 05/26/2014 09:55 AM, Jet Chen wrote:
> 
> Jet,
> 
>> 0day kernel testing robot got the below dmesg and the first bad commit is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git staging-next
>> commit 0629f3b8c33899140b48d5897259eab8ebae78ca
>> Author:     Larry Finger <Larry.Finger@lwfinger.net>
>> AuthorDate: Wed May 21 16:25:36 2014 -0500
>> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Fri May 23 11:33:56 2014 +0900
>>
>>      staging: r8192ee: Turn on build of the new driver
>>          In addition, this commit contains a TODO file for this driver
>>          Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The splat comes from the driver trying to register a rate-control algorithm that 
> is already registered. That could happen because a driver is calling the 
> registration routine twice, or because more than one driver is using the same 
> routine name. As I think there is code to prevent the former, and I have never 
> seen that splat here, I suspect that more than one driver has used the name. On 
> my real hardware, I can only have one of these devices in the machine at a time.
> 
> Is if possible to test the attached patch to see if it fixes the problem? If 
> not, could you get a listing of the loaded modules at the time of the splat? If 
> this is not the fix, I will try to duplicate it here.
> 
> Thanks,
> 
> Larry
> 

That patch fixes the problem.

Tested-by: Jet Chen <jet.chen@intel.com>

Thanks,
Jet
