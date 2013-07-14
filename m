Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3GNNcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 09:32:16 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:58914 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252Ab3GNNcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 09:32:15 -0400
Message-ID: <1373808733.1370.48.camel@x61.thuisdomein>
Subject: Re: linux 3.10.1 (stable) regression
From: Paul Bolle <pebolle@tiscali.nl>
To: Kiko Piris <kernel@pirispons.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        srivatsa.bhat@linux.vnet.ibm.com
Date: Sun, 14 Jul 2013 15:32:13 +0200
In-Reply-To: <20130714131704.GA7000@sacarino.pirispons.net>
References: <20130714131704.GA7000@sacarino.pirispons.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Jul 2013 13:32:13.0941 (UTC) FILETIME=[8D00C250:01CE8096]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-14 at 15:17 +0200, Kiko Piris wrote:
> since updating stable kernel to 3.10.1 my ThinkPad X1 won’t wake up from
> suspend (with echo -n "mem" > /sys/power/state).
> 
> As 3.10.0 suspends and resumes ok; I bisected, it and it tells me that
> the cuplprit is the following commit:
> 
> | commit c02527487f0c8feb578c0394ad481a97f26d3bd2
> | Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> | Date:   Mon Jul 1 00:40:55 2013 +0200
> | 
> |     cpufreq: Fix cpufreq regression after suspend/resume
> |     
> |     commit f51e1eb63d9c28cec188337ee656a13be6980cfd upstream.
> 
> When I press Fn key to resume the laptop, it does not wake up at all:
> bluetooth led lights up, but the power button continues to glow slowly
> as if it was still suspended (then I have to press power button for a
> couple of seconds to power it off).
> 
> I’ve attached my config at the bottom in case it could be relevant.
> Please, let me know if I can provide any additional information or make
> any test to help.

My suggestion would be to try this follow up patch:
    https://lkml.org/lkml/2013/7/11/661

That second patch resolved the (less severe) resume issue I had (in
v3.10 and v3.10.1). It completes the revert, to the pre-v3.10 situation,
that commit f51e1eb63d started.


Paul Bolle

