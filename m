Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbbAFQES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:04:18 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49229 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbbAFQEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:04:16 -0500
Message-ID: <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: TCP connection issues against Amazon S3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Erik Grinaker <erik@bengler.no>
Cc: linux-kernel@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>
Date: Tue, 06 Jan 2015 08:04:13 -0800
In-Reply-To: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 15:14 +0000, Erik Grinaker wrote:
> (CCing Yuchung, as his name comes up in the relevant commits)
> 
> After upgrading from Ubuntu 12.04.5 to 14.04.1 we have begun seeing
> intermittent TCP connection hangs for HTTP image requests against
> Amazon S3. 3-5% of requests will suddenly stall in the middle of the
> transfer before timing out. We see this problem across a range of
> servers, in several data centres and networks, all located in Norway.
> 
> A packet dump [1] shows repeated ACK retransmits for some of the
> requests. Using Ubuntu mainline kernels, we found the problem to have
> been introduced between 3.11.10 and 3.12.0, possibly in
> 0f7cc9a3c2bd89b15720dbf358e9b9e62af27126. The problem is also present
> in 3.18.1. Disabling tcp_window_scaling seems to solve it, but has
> obvious drawbacks for transfer speeds. Other sysctls do not seem to
> affect it.
> 
> I am not sure if this is fundamentally a kernel bug or a network
> issue, but we did not see this problem with older kernels.
> 
> [1] http://abstrakt.bengler.no/tcp-issues-s3.pcap.bz2--


CC netdev

This looks like the bug we fixed here :

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=39bb5e62867de82b269b07df900165029b928359

Could you post output of 'nstat' command ?


