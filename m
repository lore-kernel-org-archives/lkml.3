Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3JVImV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:42:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3JVImT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:42:19 -0400
Date: Tue, 22 Oct 2013 10:42:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "joe@perches.com" <joe@perches.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "arozansk@redhat.com" <arozansk@redhat.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
 output format
Message-ID: <20131022084219.GC10268@nazgul.tnic>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-9-git-send-email-gong.chen@linux.intel.com>
 <52612311.2000303@linux.vnet.ibm.com>
 <20131019112658.GB16597@gchen.bj.intel.com>
 <526554D3.9050902@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31D45B22@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D45B22@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 05:14:05PM +0000, Luck, Tony wrote:
> Even if we recovered from a UC error (which is by no means a sure
> thing) ... I don't think the "requires no further action" message
> applies.
>
> Soft single bit errors are common (well, common-ish ... they should
> still be somewhat rare by most objective standard). Double bit errors
> are much rarer ... and are very unlikely to be the result of two
> single bit errors happening to be inside the same cache line. I'd
> recommend further investigation of the source of a UC error (even one
> that is "recovered" in software).

Btw, do we even need to make this distinction? I mean, do we even reach
this path on an error where we need to raise a #MC exception? In the
initial design we were called from machine_check_poll which is not the
exception path and now we're on the decode_chain which gets all errors.

Are we ready to handle all? And also, why do we even need to
differentiate the error types on reporting? I mean, if it is, say, a
contained UC error and we can start a recovery action from userspace
like killing the process, we probably want to have that same detailed
report too?

 [ This is purely hypothetical, of course, as we do the poisoning game
 and killing of processes from kernel space now but still... ]

Thanks.
