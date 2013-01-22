Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab3AVNyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 08:54:52 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49893 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab3AVNys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 08:54:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Borislav Petkov <bp@alien8.de>
Cc: =?ISO-8859-1?Q?Andr=E9?= Przywara <andre@andrep.de>,
        Leonid Isaev <lisaev@umail.iu.edu>, Tom Gundersen <teg@jklm.no>,
        cpufreq@vger.kernel.org, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/6] acpi-cpufreq and powernow-k8 fixes
Date: Tue, 22 Jan 2013 15:00:49 +0100
Message-ID: <2072518.dOpbznWpGj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358677470-17394-1-git-send-email-bp@alien8.de>
References: <1358677470-17394-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 20, 2013 11:24:24 AM Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Hi all,
> 
> here are a couple of patches fixing acpi-cpufreq and powernow-k8 loading
> sequence and handoff.
> 
> Patch 0001 should be in Rafael's tree already but I'm adding it here for
> the sake of completeness. Basically, we want to address all possible
> cases of powernow-k8 and acpi-cpufreq:
> 
> (M: module, Y: built-in)
> 
> powernow-k8		acpi-cpufreq
> M			M		- powernow-k8 requests acpi-cpufreq
> M			Y		- powernow-k8 sees already loaded acpi-cpufreq
> Y			M		- impossible after patch 0001
> Y			Y		- patches 2,3 fix that
> 
> Anyway, please take a look and let me know.
> 
> Thanks.
> 
> 
> 
> 
> Borislav Petkov (5):
>   powernow-k8: Add a kconfig dependency on acpi-cpufreq
>   cpufreq: Make acpi-cpufreq link first
>   cpufreq: Add a get_current_driver helper
>   powernow-k8: Cleanup module request
>   powernow-k8: Cleanup init function
> 
> Matthew Garrett (1):
>   acpi-cpufreq: Do not load on K8

Applied.

They are in linux-pm/bleeding-edge for now, I'll move them to linux-pm/linux-next
after build testing.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
