Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3EQSRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:17:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:64181 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3EQSRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:17:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAPPqfY3+e3tVQA_RKn0DhwModLienrgtFzsUrCCsUndbJfnHOg@mail.gmail.com>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<18379918.sbmR7uiKVn@vostro.rjw.lan>
	<CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
	<2048745.M7CAe2g1gj@vostro.rjw.lan>
	<CAPPqfY2hrd54viFHKErWk_8uRLHP9WK54G0inJtyUFJKKunDOg@mail.gmail.com>
	<CAPPqfY3+e3tVQA_RKn0DhwModLienrgtFzsUrCCsUndbJfnHOg@mail.gmail.com>
Date: Fri, 17 May 2013 20:17:40 +0200
Message-ID: <CAPPqfY2ba5M27omZBwe0h26Eutyd+2KkLXht6uLN5VdjEKT_Ug@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This performance penalty is still present in kernel 3.9.2. And
CONFIG_PM cannot be deactivated anymore.

I was able to make a working 3.9.2 (meaning with no penalty)  with
following config and patch :
CONFIG_PM=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_CPU_IDLE=y
CONFIG_ACPI=y
CONFIG_ACPI_PROCESSOR=y

Patch : https://gist.github.com/odoucet/5600630

I know this patch is not perfect because it is just equivalent to
rollback commit f51d67a64f32cd81ea8b67ca964fb7cf7e783b2e ;

I really want this to be fixed in kernel, so I would be glad to test
any patch / config file you want.


2013/2/12 Olivier Doucet <webmaster@ajeux.com>
>
> Hello,
>
> A quick update on my latest tests :
> I was able to compile a working 3.7.1 kernel (by 'working', I mean
> with no performance penalty). I'm sure 3.7.7 will be OK also (do you
> want me to test latest RC of 3.8 ?)
>
> I had to disable CONFIG_ACPI_PROCESSOR to disable power management.
> So now these two options are unset :
> CONFIG_CPU_IDLE
> CONFIG_ACPI_PROCESSOR
>
> I've posted the whole .config file here :
> https://gist.github.com/odoucet/4773390
>
> I'll be glad to test any patch that may help reactivate PM on my
> system (CPU Intel Xeon L5630)
>
> Olivier
