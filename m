Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020AbaD2MYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:24:10 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56331 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982AbaD2MYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:24:09 -0400
Message-ID: <535F997B.3000500@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 17:52:19 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: avagin@openvz.org, roland@redhat.com, oleg@redhat.com,
        Linux PPC dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add new ptrace request macros on PowerPC
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <533BD922.4070009@linux.vnet.ibm.com>	<535F4E10.2020300@linux.vnet.ibm.com> <CAEjGV6yi5YY95tM-HY4akN4BGXGn4chA8_sCaqvWx3HPSu2V3w@mail.gmail.com> <535F5BDE.2030309@linux.vnet.ibm.com> <CAEjGV6y8MRiCfRBtWjNfrwKMccROEAJw2rPVc_u+r=tAo2EcHQ@mail.gmail.com>
In-Reply-To: <CAEjGV6y8MRiCfRBtWjNfrwKMccROEAJw2rPVc_u+r=tAo2EcHQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042912-1396-0000-0000-000004C202C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 01:52 PM, Michael Neuling wrote:
> That's not what that patch does. It shouldn't make any user visible changes
> to DSCR or PPR.

It may not when it runs uninterrupted but after the tracee process has stopped,
thread.dscr reflects the default DSCR value as mentioned before. This can be
proved by changing the "dscr_default" value in arch/powerpc/sysfs.c file.

> 
> Over syscall PPR and DSCR may change. Depending on your test case, that may
> be your problem.

I would guess when the tracee process stops for ptrace analysis, tm_reclaim or
tm_recheckpoint path might be crossed which is causing this dscr_default value
to go into thread_struct.

