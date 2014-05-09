Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaEIHnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:43:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:5073 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaEIHnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1016,1389772800"; 
   d="scan'208";a="529020272"
Message-ID: <536C873D.8030405@intel.com>
Date: Fri, 09 May 2014 15:43:57 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: rjw@rjwysocki.net, lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Battery: Accelerate battery resume callback
References: <1399183626-13152-1-git-send-email-tianyu.lan@intel.com> <20140509073827.GA4965@xo-6d-61-c0.localdomain>
In-Reply-To: <20140509073827.GA4965@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年05月09日 15:38, Pavel Machek wrote:
> Hi!
> 
>> Most time of battery resume callback is spent on executing AML code
>> _BTP, _BIF and _BIF to get battery info, status and set alarm. These
>> AML methods may access EC operation regions several times and consumes
>> time.
>>
>> These operations are not necessary during devices resume and can run
>> during POST_SUSPEND/HIBERNATION event when all processes are thawed.
> 
> Does it mean that userspace will see pre-hibernation battery level for a while 
> after resume?

Hi Pavel:
	Thanks for your review. No, when user access the battery sysfs
interface, driver will read battery info and return new data.

> 
> 									Pavel
> 


-- 
Best regards
Tianyu Lan
