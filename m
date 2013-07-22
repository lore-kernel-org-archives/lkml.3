Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3GVPeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:34:10 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:61807 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab3GVPeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:34:09 -0400
Message-ID: <1374507247.15242.26.camel@x61.thuisdomein>
Subject: Re: 3.10.1 cpufreq suspend/resume regression still present in 3.10.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Kiko Piris <kernel@pirispons.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Mon, 22 Jul 2013 17:34:07 +0200
In-Reply-To: <20130722151653.GA7213@sacarino.pirispons.net>
References: <20130722151653.GA7213@sacarino.pirispons.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2013 15:34:07.0606 (UTC) FILETIME=[E7977960:01CE86F0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-22 at 17:16 +0200, Kiko Piris wrote:
> linux-3.10.1 introduced a regression in cpufreq breaking suspend/resume
> cycle for some people [1].

The upstream commit that probably will fix the regression that Kiko ran
into is aae760ed21cd690fe8a6db9f3a177ad55d7e12ab ("cpufreq: Revert
commit a66b2e to fix suspend/resume regression"). It's only part of
v3.11-rc2 and was committed with a
    Cc: 3.10+ <stable@vger.kernel.org>

tag. So I'd guess that fix will be part of a future v3.10.y (stable)
releases.

> There were also some other threads about it in lkml.
> 
> I see 3.10.2-stable was released some days ago. I couldn’t see anything
> about fixing this regression reported in the changelog.
> 
> And to be 110% certain, I compiled it and tried suspending/resuming;
> it’s still broken.
> 
> Is this going to be fixed in 3.10 stable branch?
> 
> Thank you very much in advance.

Note that I already suggested to Kiko to try that patch (see
https://lkml.org/lkml/2013/7/14/35 ). I don't know whether Kiko tried
it, as I never received a reply to my suggestion. So, for now, I can
only say that that patch will probably fix the issue.

> [1] first commit that bisect informed as introducing the regression:
> 
> | commit c02527487f0c8feb578c0394ad481a97f26d3bd2
> | Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> | Date:   Mon Jul 1 00:40:55 2013 +0200
> |
> |     cpufreq: Fix cpufreq regression after suspend/resume
> |
> |     commit f51e1eb63d9c28cec188337ee656a13be6980cfd upstream.
> 
> https://groups.google.com/forum/#!topic/linux.kernel/LUi1pFCxbSI


Paul Bolle

