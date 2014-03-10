Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaCJK1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:27:37 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:54199 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbaCJK1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:27:36 -0400
Message-ID: <1394447253.2979.12.camel@x220>
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
From: Paul Bolle <pebolle@tiscali.nl>
To: Julian Wollrath <jwollrath@web.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Mar 2014 11:27:33 +0100
In-Reply-To: <20140310110410.5b2218f6@ilfaris>
References: <20140310110410.5b2218f6@ilfaris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2014 10:27:34.0411 (UTC) FILETIME=[59D0E5B0:01CF3C4B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 11:04 +0100, Julian Wollrath wrote:
> on a Thinkpad x121e (AMD E-450 APU) with version 3.13.5 and earlier of
> the kernel I get:
> [...]
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.001000] tsc: Detected 1646.619 MHz processor
> [    0.000004] Calibrating delay loop (skipped), value calculated using
> timer frequency.. 3293.23 BogoMIPS (lpj=1646619)
> [...]
> 
> 
> but starting with v3.14-rc1 the fast TSC calibration fails:
> [...]
> [    0.000000] tsc: Fast TSC calibration failed
> [    0.000000] tsc: PIT calibration matches HPET. 1 loops
> [    0.000000] tsc: Detected 1646.490 MHz processor
> [...]
> 
> If you need more information, please do not hesitate to ask.

I submitted a patch to downgrade the "Fast TSC calibration failed"
message to KERN_INFO level, see https://lkml.org/lkml/2012/9/26/131 .
That patch was basically ignored. I've carried it locally ever since.

So the error need not be v3.14-rc1 specific. But perhaps something
changed in v3.14-rc1 that makes it easier to trigger that error. I
haven't checked.

(I wrote some notes on this issue in
https://lkml.org/lkml/2012/9/24/221 , perhaps they might be of help.)


Paul Bolle

