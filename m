Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKEVvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:51:00 -0500
Received: from gproxy3-pub.mail.unifiedlayer.com ([69.89.30.42]:41473 "HELO
	gproxy3-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750936AbaKEVu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:50:59 -0500
X-Authority-Analysis: v=2.1 cv=W5+rC3mk c=1 sm=1 tr=0
 a=9W6Fsu4pMcyimqnCr1W0/w==:117 a=9W6Fsu4pMcyimqnCr1W0/w==:17 a=cNaOj0WVAAAA:8
 a=f5113yIGAAAA:8 a=kj9zAlcOel0A:10 a=TBVoxVdAAAAA:8 a=GhZ5P8ky69gA:10
 a=noBwr2J6l1kA:10 a=zd2uoN0lAAAA:8 a=NmoPtlSWfphNI2az8gMA:9 a=CjuIK1q_8ugA:10
Date: Wed, 5 Nov 2014 13:51:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <jroedel@suse.de>
Cc: Oded Gabbay <oded.gabbay@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: export find_extend_vma and handle_mm_fault for
 driver use
Message-ID: <20141105135109.39ea54fe@jbarnes-hsw>
In-Reply-To: <20141105120351.GH8354@suse.de>
References: <1414179271-7621-1-git-send-email-jbarnes@virtuousgeek.org>
	<20141027151327.GE9734@suse.de>
	<544E61A1.7090400@amd.com>
	<20141027083552.4af5753f@jbarnes-hsw>
	<5450B472.1020301@amd.com>
	<20141105120351.GH8354@suse.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 13:03:51 +0100
Joerg Roedel <jroedel@suse.de> wrote:

> Hi Oded, Jesse,
> 
> On Wed, Oct 29, 2014 at 11:33:38AM +0200, Oded Gabbay wrote:
> > I tested our amdkfd driver with your patches applied (kernel 3.17.1).
> > I run OpenCL tests, Aparapi/Sumatra (Java) and OpenMP
> > 
> > All tests passed and I didn't see any kernel error messages.
> > 
> > So:
> > 
> > Tested-by: Oded Gabbay <oded.gabbay@amd.com>
> 
> Thanks for testing Oded. Jesse, the patch looks good to me, except the
> task accounting for the page-faults. I'd like to get rid of using
> task_struct in the IOMMUv2 driver entirely if possible. Also it is not
> really the CPU task causing the faults, but some non-CPU process.

Hm, but the CPU task initiates the activity on the GPU, so we should
account for it somewhere, right?  I guess I had been thinking of the
"task" as spanning the CPUs and GPUs and other devices in the system,
rather than just representing the CPU activity.

> So can you please remove that code and resend the patches with Oded's
> Tested-by and Andrew Morton on Cc? I think these patches should go
> through the -mm tree.

Sure, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
