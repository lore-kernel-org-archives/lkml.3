Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab3JHPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:48:17 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40831 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3JHPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:48:16 -0400
Date: Tue, 8 Oct 2013 08:48:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Murphy <bugzilla@colorremedies.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20131008154809.GB18402@roeck-us.net>
References: <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com>
 <524A4384.4040403@roeck-us.net>
 <20131002035156.GA566@roeck-us.net>
 <20131002095339.GA2716@polaris.bitmath.org>
 <524C1FE1.4050207@roeck-us.net>
 <20131002163418.GA4557@polaris.bitmath.org>
 <20131002164718.GA7392@roeck-us.net>
 <20131002172410.GA381@polaris.bitmath.org>
 <525346D3.30500@roeck-us.net>
 <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 05:46:55PM -0600, Chris Murphy wrote:
> 
> On Oct 7, 2013, at 5:42 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > On 10/02/2013 10:24 AM, Henrik Rydberg wrote:
> > 
> >>> From 4451da32414080bd0563ee9e061f19bf90463cc5 Mon Sep 17 00:00:00 2001
> >> From: Henrik Rydberg <rydberg@euromail.se>
> >> Date: Wed, 2 Oct 2013 19:15:03 +0200
> >> Subject: [PATCH] applesmc remedy take 2
> >> 
> >> Conjectured problem: there are remnant bytes ready on the data line
> >> which corrupts the read after a failure.
> >> 
> >> Remedy: assuming bit0 is the read valid line, try to flush it before
> >> starting a new command.
> >> 
> >> Tests by Chris suggests reading the status is enough for the problem
> >> to go away, which is consistent with a change in the SMC interface,
> >> where the number of bytes to read is no longer specified, but found
> >> out by reading until end of data.
> >> 
> >> Tested on a MacBookAir3,1, but the original problem has not been
> >> reproduced.
> > 
> > So, what should we do with this patch ? Apply it ?
> 
> So far I'm getting nothing on the original machine. As of today it's applied as the last patch on 3.12.0-0.rc4.git0.1.fc20.x86_64. Unfortunately at the moment I'm a bit too dense to figure out how to get a new kernel applied to an existing live package so I can try this on a USB stick. While maybe unrelated, the oops was occurring at least 4x as often booted from USB stick media than HDD.
> 

Seems to me we should apply it.

Henrik,

what do you think ? Did you have time for additional testing ?
If you think we should apply it, please send me a signed patch.

Thanks,
Guenter
