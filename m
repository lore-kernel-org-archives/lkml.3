Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3JNRMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:12:38 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61500 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab3JNRMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:12:37 -0400
MIME-Version: 1.0
In-Reply-To: <20131014103616.GE4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
	<1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
	<20131011160208.GL5925@pd.tnic>
	<20131014045500.GC12189@gchen.bj.intel.com>
	<20131014103616.GE4009@pd.tnic>
Date: Mon, 14 Oct 2013 10:12:35 -0700
Message-ID: <CA+8MBbJ9P1GVf3SCh7LMY_LH+pxQg3GWkxKMzni1b1Wyx1o8NQ@mail.gmail.com>
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output format
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Chen Gong <gong.chen@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Lance Ortiz <lance.ortiz@hp.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 3:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Oct 14, 2013 at 12:55:00AM -0400, Chen Gong wrote:
>> Because most of data in CPER are empty or unimportant.
>
> It is not about whether it is important or not - the question is whether
> changing existing functionality which someone might rely upon is a
> problem here? Someone might be expecting exactly those messages to
> appear in dmesg.

Pulling in a couple more people who have been touching error reporting
code in the last year or so (Hi Lance, Naveen ... feel free to drag more
people to look at this thread).

I prodded Chen Gong in to make this change because our console messages
are way to verbose (and scary) for simple corrected errors.  There are 18
fields in the memory error section (as of UEFI 2.4 ... more are likely to be
added because there are issues that some of the 16-bit wide fields are too
small to handle increased internal values in modern DIMMs).  Whether you
print that one item per line, or a few very long lines - it is way
more information
than the average user will ever want or need to see.

> Btw, what is the real reason for this patch, to save yourself the output
> in dmesg? If so, you can disable this output when eMCA module has been
> loaded but leave it intact otherwise.

This is an excellent idea - if the full data is being logged via TRACE, then
we can drop to virtually nothing on the console (just have something similar
to the "Machine check events logged" message so that people will get a
tip that they might want to go dig into other logs).  Maybe something like:
    %d corrected memory errors\n", count
[rate limited]

But we'd have to make sure that the existing user(s) of this code also
have a TRACE path.

-Tony
