Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab3D2Q3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:29:11 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55072 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904Ab3D2Q3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:29:10 -0400
Date: Mon, 29 Apr 2013 18:29:07 +0200
From: Florian Westphal <fw@strlen.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Florian Westphal <fw@strlen.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk,
        adam radford <aradford@gmail.com>
Subject: Re: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Message-ID: <20130429162907.GH32324@breakpoint.cc>
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
> Florian> After update to 3.8 dmesg is spammed with: kernel: [
> Florian> 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41 kernel: [
> Florian> 280.272107] sd 8:0:0:0: [sda] Unhandled error code kernel: 
> 
> Interesting. It looks like the 3ware handles this at the driver level
> instead of passing the command through to the disk and letting it
> fail. That in turn means that the logic we have in place to disable WS
> when the disk does not support it does not get triggered.
> 
> The driver should really fill out the sense buffer in that case.
> 
> Could you please test the patch below?

Sure, I'll report back tomorrow.

Thanks for the quick response,
Florian
