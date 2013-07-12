Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3GLXq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:46:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42502 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab3GLXqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:46:24 -0400
Message-ID: <51E09530.8030300@zytor.com>
Date: Fri, 12 Jul 2013 16:45:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0aWFuIFPDvG5rZW5iZXJn?= 
	<christian.suenkenberg@student.kit.edu>
CC: Jonas Heinrich <onny@project-insanity.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
References: <20130218155439.GA902@onny> <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com> <20130223131856.GA682@onny> <51293A8B.5060107@zytor.com> <20130320143257.GA473@onny> <20130501170118.GB488@onny> <518151DD.106@zytor.com> <51DDC972.3010005@student.kit.edu> <51DDF4DF.4000902@zytor.com> <51E092FC.1030200@student.kit.edu>
In-Reply-To: <51E092FC.1030200@student.kit.edu>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 04:36 PM, Christian Sünkenberg wrote:
> 
> Jonas tried your patch and it fixes suspend/resume on his T43, although
> IMHO the safest approach would be to just add an exception for
> Vendor==Intel && Family==6 && Model==13, or more generally Vendor==Intel
> && !supports_long_mode, as the same erratum also warns about wrmsr
> possibly not triggering a GP either.
> Anyways, at least on this specific MSR with the Pentium M Jonas tested,
> it behaved correctly on every try, so I'd say your patch does the trick,
> thank you very much!
> 

Using vendor matches is not really a great way to deal with things that
can better be handled analytically.

If WRMSR doesn't fault, it is not a problem...

> As a side note, I found a similar erratum #33 in "Pentium® Processor
> Specification Update" for Intel P54C (Family 5, Model 2), which would,
> supposed there are P54C systems with ACPI sleep/resume support, result
> in MSR 0 (P5_MC_ADDR) to be saved and restored instead of nonexistent EFER.

Doesn't really matter, as we'd only read that one after an #MC.

	-hpa


