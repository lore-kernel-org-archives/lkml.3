Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab3HONvL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:51:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58891 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951Ab3HONvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:51:08 -0400
Date: Thu, 15 Aug 2013 15:51:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815135106.GG27616@pd.tnic>
References: <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com>
 <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan>
 <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com>
 <20130814211504.393cf138@concha.lan>
 <20130815100132.GC27616@pd.tnic>
 <20130815103421.178a5224@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130815103421.178a5224@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 10:34:21AM -0300, Mauro Carvalho Chehab wrote:
> Yes, but the thing is that it is not safe to use the hardware driver
> if the BIOS is also reading the hardware error registers directly, as,
> on several hardware, a read cause the error data to be cleaned on such
> register.

Here's the deal:

* We parse some APEI table and disable those MCA banks which the BIOS
wants to handle first.

* When the BIOS decides to report an error from that handling, it does
so over another BIOS table.

* Now you have two possibilities:

** On systems without an edac driver or where it doesn't make sense to
have the ghes_edac driver, we call trace_mc_event() straight from APEI
code (this is what we're currently discussung).

** On other systems, where we need ghes_edac, we *don't* use the
trace_mc_event() tracepoint in the APEI code but let it come from
ghes_edac with additional information collected by edac.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
