Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaE1UKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:10:40 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:37678 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaE1UKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:10:36 -0400
Date: Wed, 28 May 2014 21:10:21 +0100
From: Giedrius Rekasius <giedrius.rekasius@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] perf/x86/uncore: Remove unnecessary assignment to "box"
 in uncore_pci_remove(...)
Message-ID: <20140528200609.GA1901@vaio>
References: <1401268294-28634-1-git-send-email-giedrius.rekasius@gmail.com>
 <5385B764.6090301@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5385B764.6090301@bfs.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 12:16:04PM +0200, walter harms wrote:
> 
> 
> Am 28.05.2014 11:11, schrieb Giedrius Rekasius:
> > Local variable "box" gets assigned correct value when it is initialized.
> > There is no need to assign the same value again.
> > 
> > Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > index 65bbbea..8cbbb1b 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> > @@ -3817,7 +3817,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
> >  	struct intel_uncore_pmu *pmu;
> >  	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
> >  
> > -	box = pci_get_drvdata(pdev);
> >  	if (!box) {
> >  		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
> >  			if (extra_pci_dev[phys_id][i] == pdev) {
> 
> Just a remark,
> for readability it is better to remove the other one.

I could move the declaration itself closer to the if statement while
still keeping whole statement in one line.

On the other hand I'm not so sure if it makes any real difference to
have assignment right next to the if statement compared to a few lines
above it.

Regards,
Giedrius
