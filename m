Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab3KAOVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:21:20 -0400
Received: from 8bytes.org ([85.214.48.195]:38403 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab3KAOVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:21:19 -0400
Date: Fri, 1 Nov 2013 15:21:15 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: VT-d and x2apic: broken resume after suspend to ram
Message-ID: <20131101142115.GK17455@8bytes.org>
References: <CA+MoWDqoBxuFhBsf_rVBT1C8=mwj02hXgPfuWnjY4yeVa-84cA@mail.gmail.com>
 <20131101130702.GA3348@8bytes.org>
 <CA+MoWDoDTFarOLUHgNmUFksRvV-R+7jufUwLbsS8ecaO+_m2kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDoDTFarOLUHgNmUFksRvV-R+7jufUwLbsS8ecaO+_m2kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Nov  1 15:21:17 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5273b8dd20864815789901
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 02:21:07PM +0100, Peter Senna Tschudin wrote:
> On Fri, Nov 1, 2013 at 2:07 PM, Joerg Roedel <joro@8bytes.org> wrote:
> > Which kernels have you tried? Does it happen with all of them or is
> > there a kernel-version where this started?
> 
> I'm using 3.11.6-200.fc19.x86_64. I always had VT-d enabled, and
> suspend / resume never worked on Linux. I did not know that disabling
> VT-d could be a workaround to the resume issue until yesterday.
> 
> Does this have anything in common to:
> https://bugzilla.redhat.com/show_bug.cgi?id=752613

This is probably not related. As far as I can see this issue was about
boot problem with discrete graphics while your problem is related to
suspend/resume.

The next thing I would try on your machine is to get some kernel debug
messages from resume. This might be hard to get, since your notebook
has probably no serial port. But you can try to boot with
no_console_suspend on the kernel cmdline and see if it gives you any
output on resume.

Maybe some of the VT-d guys can take a look too?


	Joerg

