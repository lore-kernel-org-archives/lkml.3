Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbbA2BI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:08:56 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:64770 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396AbbA2BIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:08:54 -0500
Message-ID: <1422478839.3621.34.camel@x220>
Subject: Re: arm64: USB_ARCH_HAS_EHCI
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Walmsley <paul@pwsan.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 22:00:39 +0100
In-Reply-To: <alpine.DEB.2.02.1501281621330.19947@utopia.booyaka.com>
References: <1422351833.14015.20.camel@x220>
	  <alpine.DEB.2.02.1501272130470.19947@utopia.booyaka.com>
	 <1422438405.5666.16.camel@x220>
	 <alpine.DEB.2.02.1501281621330.19947@utopia.booyaka.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2015 21:00:39.0851 (UTC) FILETIME=[78BE0FB0:01D03B3D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, 2015-01-28 at 16:25 +0000, Paul Walmsley wrote:
> Is the Kconfig checker script you mentioned on Tuesday available in the 
> mainline tree?  I don't see anything obvious under the "Static Analysers" 
> section of the Makefile, but perhaps I'm overlooking it.

No, it's not.

In tree you'll find scripts/checkkconfigsymbols.py. That catches over
90% of the stuff my local script catches, in less than 10% of runtime.
It would certainly have caught your use of USB_ARCH_HAS_EHCI.

My local script is my third (or fourth) attempt at a script that checks
these kind of issues. I've used it on linux-next since for about 3/4 of
a year now. While doing that I ran into people that are planning into
adding similar, but far more advanced, functionality into one of the
bots that is checking linux. So I never bothered making my script
public. (I'm not sure what the status of those plan is now.)

In the mean time I'll keep on checking linux-next with my script. That
should also help to see what problems an actual bot could run into, for
the benefit of those people. Problems like:
- should it check each commit (I think it should only check releases);
- should it be a true bot (I think it needs a wetware frontend to
  filter out non-issues).

Hope this answers your question.


Paul Bolle


