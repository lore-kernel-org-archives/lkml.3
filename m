Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3JGXrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:47:04 -0400
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:50969 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751613Ab3JGXrA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:47:00 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: applesmc oops in 3.10/3.11
From: Chris Murphy <bugzilla@colorremedies.com>
In-Reply-To: <525346D3.30500@roeck-us.net>
Date: Mon, 7 Oct 2013 17:46:55 -0600
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Josh Boyer <jwboyer@fedoraproject.org>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <6918F624-B267-4DB5-95A2-7E09448CA3E4@colorremedies.com>
References: <20130927175926.GA6267@roeck-us.net> <B6E9FB4C-665C-454E-9DEB-B95B85C1D0E0@colorremedies.com> <524615B1.6000106@roeck-us.net> <4FFB3671-DDB4-40F7-BA5D-C9AA9391BDA9@colorremedies.com> <524A4384.4040403@roeck-us.net> <20131002035156.GA566@roeck-us.net> <20131002095339.GA2716@polaris.bitmath.org> <524C1FE1.4050207@roeck-us.net> <20131002163418.GA4557@polaris.bitmath.org> <20131002164718.GA7392@roeck-us.net> <20131002172410.GA381@polaris.bitmath.org> <525346D3.30500@roeck-us.net>
To: Guenter Roeck <linux@roeck-us.net>
X-Mailer: Apple Mail (2.1510)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - slmp-550-94.slc.westdc.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - colorremedies.com
X-Get-Message-Sender-Via: slmp-550-94.slc.westdc.net: authenticated_id: whatever@colorremedies.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2013, at 5:42 PM, Guenter Roeck <linux@roeck-us.net> wrote:

> On 10/02/2013 10:24 AM, Henrik Rydberg wrote:
> 
>>> From 4451da32414080bd0563ee9e061f19bf90463cc5 Mon Sep 17 00:00:00 2001
>> From: Henrik Rydberg <rydberg@euromail.se>
>> Date: Wed, 2 Oct 2013 19:15:03 +0200
>> Subject: [PATCH] applesmc remedy take 2
>> 
>> Conjectured problem: there are remnant bytes ready on the data line
>> which corrupts the read after a failure.
>> 
>> Remedy: assuming bit0 is the read valid line, try to flush it before
>> starting a new command.
>> 
>> Tests by Chris suggests reading the status is enough for the problem
>> to go away, which is consistent with a change in the SMC interface,
>> where the number of bytes to read is no longer specified, but found
>> out by reading until end of data.
>> 
>> Tested on a MacBookAir3,1, but the original problem has not been
>> reproduced.
> 
> So, what should we do with this patch ? Apply it ?

So far I'm getting nothing on the original machine. As of today it's applied as the last patch on 3.12.0-0.rc4.git0.1.fc20.x86_64. Unfortunately at the moment I'm a bit too dense to figure out how to get a new kernel applied to an existing live package so I can try this on a USB stick. While maybe unrelated, the oops was occurring at least 4x as often booted from USB stick media than HDD.

Chris