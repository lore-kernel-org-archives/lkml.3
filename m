Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3D3WaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:30:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51756 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783Ab3D3WaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:30:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/paravirt] x86-64, gdt: Store/ load GDT for ACPI S3 or hibernate/resume path is not needed.
Date: Wed, 01 May 2013 00:38:17 +0200
Message-ID: <2307239.2tnNighu20@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130430212542.GA19753@phenom.dumpdata.com>
References: <1365194544-14648-2-git-send-email-konrad.wilk@oracle.com> <4054620.GA2vTd0F6g@vostro.rjw.lan> <20130430212542.GA19753@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 05:25:42 PM Konrad Rzeszutek Wilk wrote:
> > > After the 'restore_registers' it returns and we end up called
> > > restore_processor_state() - where we reload the GDT. The reload of
> > > the GDT is not needed as bootup kernel has already loaded the GDT which
> > > is at the same physical location as the the restored kernel.
> > 
> > I'm not sure if this particular statement is actually correct.  It is correct
> > on 32-bit, but here it is not necessary for the bootup kernel to be the same
> > as the image one.  Different kernel version may be used for that even (at
> > least theoretically).  So the question is, and I'm quite unsure about the
> > answer, if the GDT of from the bootup kernel is really *guaranteed* to be
> > at the same location (given that those kernels may be really different).
> 
> A bit of testing with different bootup kernel provided me with this error:
> PM: Image mismatch: version

This implies that you tested on an architechture without
CONFIG_ARCH_HIBERNATION_HEADER.

> which after a bit of digging pointed me to 'check_image_kernel'. The criteria
> there imply that the different kernel versions or releases cannot be used with
> hibernation.

Only if CONFIG_ARCH_HIBERNATION_HEADER is unset, which is not the case for
CONFIG_X86_64.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
