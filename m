Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab3D3Hgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:36:49 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57663 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab3D3Hgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:36:48 -0400
Date: Tue, 30 Apr 2013 09:36:44 +0200
From: Florian Westphal <fw@strlen.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Florian Westphal <fw@strlen.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        adam radford <aradford@gmail.com>
Subject: Re: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Message-ID: <20130430073644.GI32324@breakpoint.cc>
References: <20130429152639.GG32324@breakpoint.cc>
 <yq1obcxpb76.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1obcxpb76.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen <martin.petersen@oracle.com> wrote:
> >>>>> "Florian" == Florian Westphal <fw@strlen.de> writes:
> 
> Florian> After update to 3.8 dmesg is spammed with: kernel: [
> Florian> 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41 kernel: [
> Florian> 280.272107] sd 8:0:0:0: [sda] Unhandled error code kernel: 
> 
> Could you please test the patch below?

Works. Only one WRITE_SAME error at boot, max_write_same_blocks in sysfs
is 0, which wasn't the case before.

> The second question is what it is that's issuing these zeroouts at boot?
> Which filesystem are you using? What's your DM/MD config?

ext4, no DM/MD is used.  I guess the zeroouts are from postgres, but i'm
not sure.

> 3w-xxxx: Create sense buffer for unsupported commands
> 
> Make the driver return appropriate sense data when an unsupported
> operation is queued. This will cause the SCSI layer to stop issuing the
> offending command.
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> CC: adam radford <aradford@gmail.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Tested-by: Florian Westphal <fw@strlen.de>

Thanks again.
