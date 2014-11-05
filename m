Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbaKEMD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:03:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47682 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaKEMDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:03:55 -0500
Date: Wed, 5 Nov 2014 13:03:51 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Oded Gabbay <oded.gabbay@amd.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141105120351.GH8354@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
 <20141027151327.GE9734@suse.de>
 <544E61A1.7090400@amd.com>
 <20141027083552.4af5753f@jbarnes-hsw>
 <5450B472.1020301@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5450B472.1020301@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oded, Jesse,

On Wed, Oct 29, 2014 at 11:33:38AM +0200, Oded Gabbay wrote:
> I tested our amdkfd driver with your patches applied (kernel 3.17.1).
> I run OpenCL tests, Aparapi/Sumatra (Java) and OpenMP
> 
> All tests passed and I didn't see any kernel error messages.
> 
> So:
> 
> Tested-by: Oded Gabbay <oded.gabbay@amd.com>

Thanks for testing Oded. Jesse, the patch looks good to me, except the
task accounting for the page-faults. I'd like to get rid of using
task_struct in the IOMMUv2 driver entirely if possible. Also it is not
really the CPU task causing the faults, but some non-CPU process.

So can you please remove that code and resend the patches with Oded's
Tested-by and Andrew Morton on Cc? I think these patches should go
through the -mm tree.

Thanks,

	Joerg

