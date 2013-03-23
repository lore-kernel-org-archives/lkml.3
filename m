Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3CWEYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:24:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46242
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab3CWEYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:24:03 -0400
Date: Fri, 22 Mar 2013 22:23:45 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Tejun Heo <tj@kernel.org>, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v12 0/5] block layer runtime pm
Message-ID: <20130323042345.GR1628@kernel.dk>
References: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364010148-8584-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23 2013, Aaron Lu wrote:
> In August 2010, Jens and Alan discussed about "Runtime PM and the block
> layer". http://marc.info/?t=128259108400001&r=1&w=2
> And then Alan has given a detailed implementation guide:
> http://marc.info/?l=linux-scsi&m=133727953625963&w=2
> 
> To test:
> # ls -l /sys/block/sda
> /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
> 
> # echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
> # echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
> Then you'll see sda is suspended after 10secs idle.
> 
> [ 1767.680192] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [ 1767.680317] sd 2:0:0:0: [sda] Stopping disk
> 
> And if you do some IO, it will resume immediately.
> [ 1791.052438] sd 2:0:0:0: [sda] Starting disk
> 
> For test, I often set the autosuspend time to 1 second. If you are using
> a GUI, the 10 seconds delay may be too long that the disk can not enter
> runtime suspended state.
> 
> Note that sd's runtime suspend callback will dump some kernel messages
> and the syslog daemon will write kernel message to /var/log/messages,
> making the disk instantly resume after suspended. So for test, the
> syslog daemon should better be temporarily stopped.
> 
> A git repo for it, on top of block/for-next:
> https://github.com/aaronlu/linux.git blockpm
> 
> v12:
> - Split patch 1 into 2 patches, one introduces REQ_PM in block layer
>   and one uses that flag in SCSI layer, suggested by Jens Axboe.

Thanks Aaron, I've applied 1, and 3-4. I'll leave 2 and 5 for James to
pickup. James, if you want me to carry them, just let me know.

-- 
Jens Axboe

