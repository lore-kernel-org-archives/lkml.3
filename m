Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaE1KQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:16:22 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:8910 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaE1KQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:16:21 -0400
Message-ID: <5385B764.6090301@bfs.de>
Date: Wed, 28 May 2014 12:16:04 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Giedrius Rekasius <giedrius.rekasius@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] perf/x86/uncore: Remove unnecessary assignment to "box"
 in uncore_pci_remove(...)
References: <1401268294-28634-1-git-send-email-giedrius.rekasius@gmail.com>
In-Reply-To: <1401268294-28634-1-git-send-email-giedrius.rekasius@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 28.05.2014 11:11, schrieb Giedrius Rekasius:
> Local variable "box" gets assigned correct value when it is initialized.
> There is no need to assign the same value again.
> 
> Signed-off-by: Giedrius Rekasius <giedrius.rekasius@gmail.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel_uncore.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index 65bbbea..8cbbb1b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3817,7 +3817,6 @@ static void uncore_pci_remove(struct pci_dev *pdev)
>  	struct intel_uncore_pmu *pmu;
>  	int i, cpu, phys_id = pcibus_to_physid[pdev->bus->number];
>  
> -	box = pci_get_drvdata(pdev);
>  	if (!box) {
>  		for (i = 0; i < UNCORE_EXTRA_PCI_DEV_MAX; i++) {
>  			if (extra_pci_dev[phys_id][i] == pdev) {

Just a remark,
for readability it is better to remove the other one.

re,
 wh
