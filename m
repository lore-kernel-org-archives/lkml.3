Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaGKO7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:59:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaGKO7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:59:05 -0400
Message-ID: <53BFFBB0.7060709@redhat.com>
Date: Fri, 11 Jul 2014 16:58:56 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Jens Axboe <axboe@fb.com>, Ming Lei <ming.lei@canonical.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [Merge branch 'for] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000028
References: <53bbad38.bUEV+/Tm2WTBCfJH%fengguang.wu@intel.com> <53BBB30F.7020304@intel.com>
In-Reply-To: <53BBB30F.7020304@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/08/2014 10:59 AM, Aaron Lu wrote:
> The merge 49b3f10e2cf5c1c25d2ce33ab255cff8a8096ce6 seems to have only one
> commit: 254c4407cb84a6dec90336054615b0f0e996bb7c, so I added you guys in.
> Please take a look if this is a real problem, thanks.
> 
> 
> [ 1010.593031]  sda: unknown partition table
> [ 1010.598052] sd 2:0:0:0: [sda] Attached SCSI disk
> [ 1012.893125] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [ 1012.895934] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [ 1012.896336] IP: [<ffffffff813cf880>] blk_throtl_drain+0x30/0x150

I tried to revert my patch (commit 254c4407cb84a6dec90336054615b0f0e996bb7c)
but I'm still able to hit the very same kernel panic in linux-next, so I think
my patch is not the one to blame.

I was able to reproduce the error in a more easier way:
just execute the "reboot" command after the system boot is finished.

Regards,
Maurizio Lombardi
