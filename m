Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaE1UnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:43:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:40270 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1UnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:43:10 -0400
Date: Wed, 28 May 2014 22:42:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: walter harms <wharms@bfs.de>
cc: Giedrius Rekasius <giedrius.rekasius@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] perf/x86/uncore: Remove unnecessary assignment to "box"
 in uncore_pci_remove(...)
In-Reply-To: <5385B764.6090301@bfs.de>
Message-ID: <alpine.DEB.2.10.1405282239190.3952@nanos>
References: <1401268294-28634-1-git-send-email-giedrius.rekasius@gmail.com> <5385B764.6090301@bfs.de>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, walter harms wrote:
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

I rather have stuff reshuffled a bit more:

static void uncore_pci_remove(struct pci_dev *pdev)
{
	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
	struct intel_uncore_box *box = pci_get_drvdata(pdev);
	struct intel_uncore_pmu *pmu;

	if (!box) {

That's less lines and entirely readable.

Thanks,

	tglx
