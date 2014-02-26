Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaBZXeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:34:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56121 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751700AbaBZXeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:34:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tj@kernel.org, jolsa@redhat.com, oleg@redhat.com, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ACPI/Processor: Rework processor throttling with work_on_cpu()
Date: Thu, 27 Feb 2014 00:49:24 +0100
Message-ID: <1578601.f4RF6O7QVQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <530DF035.2090703@intel.com>
References: <1393419786-5275-1-git-send-email-tianyu.lan@intel.com> <9984522.UXi6hmLF20@vostro.rjw.lan> <530DF035.2090703@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 26, 2014 09:46:29 PM Lan Tianyu wrote:
> On 02/26/2014 09:30 PM, Rafael J. Wysocki wrote:
> > On Wednesday, February 26, 2014 09:03:05 PM Lan Tianyu wrote:
> >> acpi_processor_set_throttling() uses set_cpus_allowed_ptr() to make
> >> sure struct acpi_processor->acpi_processor_set_throttling() callback
> >> run on associated cpu. But the function maybe called in a worker which
> >> has been bound to a cpu. The patch is to replace set_cpus_allowed_ptr()
> >> with work_on_cpu().
> >>
> >> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> >
> > OK
> >
> > I suppose we need this in -stable?
> 
> Yes.
> 
> >
> > Which series of -stable should it go to?  All of them or just recent?
> 
> I think it should be all of them.

OK, queued up as a fix for 3.14, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
