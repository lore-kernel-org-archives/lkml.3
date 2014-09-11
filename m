Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaIKGPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 02:15:06 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40204 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIKGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 02:15:03 -0400
Message-ID: <54113DDD.1030804@linux.vnet.ibm.com>
Date: Thu, 11 Sep 2014 11:44:53 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
CC: mikey@neuling.org, james.hogan@imgtec.com, avagin@openvz.org,
        Paul.Clothier@imgtec.com, palves@redhat.com, oleg@redhat.com,
        dhowells@redhat.com, davej@redhat.com, davem@davemloft.net,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Sam Bobroff <sam.bobroff@au1.ibm.com>
Subject: Re: [PATCH V3 0/3] Add new PowerPC specific ELF core notes
References: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1400858138-3939-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091106-8878-0000-0000-000000DF0CF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:45 PM, Anshuman Khandual wrote:
> 	This patch series adds five new ELF core note sections which can be
> used with existing ptrace request PTRACE_GETREGSET/SETREGSET for accessing
> various transactional memory and miscellaneous register sets on PowerPC
> platform. Please find a test program exploiting these new ELF core note
> types on a POWER8 system.
> 
> RFC: https://lkml.org/lkml/2014/4/1/292
> V1:  https://lkml.org/lkml/2014/4/2/43
> V2:  https://lkml.org/lkml/2014/5/5/88
> 
> Changes in V3
> =============
> (1) Added two new error paths in every TM related get/set functions when regset
>     support is not present on the system (ENODEV) or when the process does not
>     have any transaction active (ENODATA) in the context
> 
> (2) Installed the active hooks for all the newly added regset core note types
> 
> Changes in V2
> =============
> (1) Removed all the power specific ptrace requests corresponding to new NT_PPC_*
>     elf core note types. Now all the register sets can be accessed from ptrace
>     through PTRACE_GETREGSET/PTRACE_SETREGSET using the individual NT_PPC* core
>     note type instead
> (2) Fixed couple of attribute values for REGSET_TM_CGPR register set
> (3) Renamed flush_tmreg_to_thread as flush_tmregs_to_thread
> (4) Fixed 32 bit checkpointed GPR support
> (5) Changed commit messages accordingly
> 
> Outstanding Issues
> ==================
> (1) Running DSCR register value inside a transaction does not seem to be saved
>     at thread.dscr when the process stops for ptrace examination.

Hey Sam and Suka,

Thanks for reviewing this patch series. I was busy with some other work
for last couple of months. Went through your comments, will get back to
this patch series in some time and work on the comments.

Thanks again.

Regards
Anshuman

