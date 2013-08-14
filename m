Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab3HNTqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:46:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53905 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab3HNTqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:46:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, bhelgaas@google.com,
        "Mitchell\, Lisa \(MCLinux in Fort Collins\)" <lisa.mitchell@hp.com>
References: <5200BFB3.2050202@jp.fujitsu.com> <520A10A3.5080303@hp.com>
	<520B4A22.2030800@hp.com>
Date: Wed, 14 Aug 2013 12:45:54 -0700
In-Reply-To: <520B4A22.2030800@hp.com> (Jingbai Ma's message of "Wed, 14 Aug
	2013 17:13:06 +0800")
Message-ID: <87ob90839p.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+U6pP8Zw/qTa2IKDg36y/mp1Z9laNcNSw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4304]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jingbai Ma <jingbai.ma@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue after unsetting BSP flag
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jingbai Ma <jingbai.ma@hp.com> writes:

> I found a side effect of unsetting BSP flag.
> It affected system rebooting, once the BSP flags been removed, and issue
> reboot command, system will hang after message:
> Restarting system.
> And have to do a hardware reset to recover it.
>
> I have reproduced this problem on the following systems:
> HP EliteBook 6930p
> HP Compaq DC7700
> HP ProLiant DL980 (4 sockets, 40 cores)
>
> I have an idea: To avoid such kind of issue, we can unset BSP flag in
> the first kernel during crash processing, and restore it in the second
> kernel in the APs initializing.

The premise was clearing BSP would not be an issue.  If we could
reliably count on unsetting the BSP during crash processing we could
just switch to the BSP and be done totally avoid this problem.

Given that there are reald world issues with clearing the BSP flag,
I believe the alternate suggestion was to simply never attempt to start
the bootstrap processor during processor bring up.

If as normal we are running on the bootstrap processor everything will
work the same, but if we are in the kdump scenario we will be short one
core.  Being short one core seems like a reasonable tradeoff between
reliability and performance.

Eric

