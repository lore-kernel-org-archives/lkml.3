Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3C1IxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 04:53:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:34365 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab3C1IxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 04:53:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,924,1355126400"; 
   d="scan'208";a="285681039"
Message-ID: <5154054B.6050706@intel.com>
Date: Thu, 28 Mar 2013 16:54:35 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@hansenpartnership.com>
CC: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v12 0/5] block layer runtime pm
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com> <20130323042345.GR1628@kernel.dk>
In-Reply-To: <20130323042345.GR1628@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2013 12:23 PM, Jens Axboe wrote:
> On Sat, Mar 23 2013, Aaron Lu wrote:
>> In August 2010, Jens and Alan discussed about "Runtime PM and the block
>> layer". http://marc.info/?t=128259108400001&r=1&w=2
>> And then Alan has given a detailed implementation guide:
>> http://marc.info/?l=linux-scsi&m=133727953625963&w=2
>>
>> To test:
>> # ls -l /sys/block/sda
>> /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
>>
>> # echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
>> # echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
>> Then you'll see sda is suspended after 10secs idle.
>>
>> [ 1767.680192] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>> [ 1767.680317] sd 2:0:0:0: [sda] Stopping disk
>>
>> And if you do some IO, it will resume immediately.
>> [ 1791.052438] sd 2:0:0:0: [sda] Starting disk
>>
>> For test, I often set the autosuspend time to 1 second. If you are using
>> a GUI, the 10 seconds delay may be too long that the disk can not enter
>> runtime suspended state.
>>
>> Note that sd's runtime suspend callback will dump some kernel messages
>> and the syslog daemon will write kernel message to /var/log/messages,
>> making the disk instantly resume after suspended. So for test, the
>> syslog daemon should better be temporarily stopped.
>>
>> A git repo for it, on top of block/for-next:
>> https://github.com/aaronlu/linux.git blockpm
>>
>> v12:
>> - Split patch 1 into 2 patches, one introduces REQ_PM in block layer
>>   and one uses that flag in SCSI layer, suggested by Jens Axboe.
> 
> Thanks Aaron, I've applied 1, and 3-4. I'll leave 2 and 5 for James to
> pickup. James, if you want me to carry them, just let me know.

Hi James,

May I know your opinion on the two SCSI patches in this series?

Thanks,
Aaron

