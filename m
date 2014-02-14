Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBNHrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 02:47:15 -0500
Received: from www84.your-server.de ([213.133.104.84]:59395 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaBNHrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 02:47:12 -0500
Message-ID: <1392364081.1034.6.camel@wall-e.seibold.net>
Subject: Re: [PATCH v15 0/10] Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, ak@linux.intel.com,
        aarcange@redhat.com, john.stultz@linaro.org, luto@amacapital.net,
        xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Fri, 14 Feb 2014 08:48:01 +0100
In-Reply-To: <52FDBC16.10101@zytor.com>
References: <1392237483-6421-1-git-send-email-stefani@seibold.net>
	 <52FDBC16.10101@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 13.02.2014, 22:47 -0800 schrieb H. Peter Anvin:
> Hi,
> 
> I tried this patchset, but it fails to compile on i386 "make allyesconfig".
> 
> 	-hpa
> 

I tried "make allyseconfig" on my i386, but the resulting config will
always set CONFIG_X86_64=y, so it fails with

scripts/mod/empty.c:1:0: error: CPU you selected does not support x86-64
instruction set

Setting to CONFIG_X86_32 by hand will allow to compile but fails in
vclock_gettime.c, because CONFIG_PARAVIRT_CLOCK is not supported for by
a 32 bit VDSO.

PARAVIRT_CLOCK and getcpu is an other topic which is not addressed by
this patch set.

I will do a patch to fix this.

- Stefani

