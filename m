Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab3HNMSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:18:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41416 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab3HNMSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:18:14 -0400
Date: Wed, 14 Aug 2013 14:18:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130814121811.GC9158@pd.tnic>
References: <20130808163822.67e0828a@samsung.com>
 <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com>
 <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com>
 <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan>
 <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <520B603E.3040002@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 04:17:26PM +0530, Naveen N. Rao wrote:
> - One, the logging format for APEI data is a bit verbose and hard
> to parse. But, I suppose we could work with this if we make a few
> changes. Is it ok to change how the APEI data is made available
> through mc_event->driver_detail?

How?

> - Two, if ghes_edac is enabled, it prevents other edac drivers
> from being loaded. It looks like the assumption here is that if
> ghes/firmware first is enabled, then *all* memory errors are reported
> through ghes which is not true. We could have (a subset of) corrected
> errors reported through ghes, some through CMCI and uncorrected errors
> through MCE. So, if I'm not mistaken, if ghes_edac is enabled, we will
> only receive ghes error events through mc_event and not the others.

The idea is to have a single tracepoint reporting memory errors. Where
you call it from shouldn't matter. Now, we have to make sure that we
don't report the same event more than once over different paths.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
