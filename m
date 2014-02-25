Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBYWrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:47:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49925 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaBYWra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:47:30 -0500
Message-ID: <530D1D6F.1050603@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 14:47:11 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Olof Johansson <olof@lixom.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Wang Dongsheng <dongsheng.wang@freescale.com>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc: warn users of smt-snooze-delay that the API
 isn't there anymore
References: <1393028074-26797-1-git-send-email-cody@linux.vnet.ibm.com> <530C21E6.5020106@linux.vnet.ibm.com>
In-Reply-To: <530C21E6.5020106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022522-3532-0000-0000-000006041385
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 08:53 PM, Madhavan Srinivasan wrote:
> On Saturday 22 February 2014 05:44 AM, Cody P Schafer wrote:
>> /sys/devices/system/cpu/cpu*/smt-snooze-delay was converted into a NOP
>> in commit 3fa8cad82b94d0bed002571bd246f2299ffc876b, and now does
>> nothing. Add a pr_warn() to convince any users that they should stop
>> using it.
>>
>> The commit message from the removing commit notes that this
>> functionality should move into the cpuidle driver, essentially by
>
> Would prefer to cleanup the code since the functionality is moved,
> instead of adding to it.

We'd still want users of the interface to use an attribute wired up 
under the cpuidle/ dir, so a warning (to update their software) is still 
needed. As deepthi has noted, cpuidle right now doesn't support changing 
this on a per-cpu basis, so a "cleanup" isn't a simple matter.

