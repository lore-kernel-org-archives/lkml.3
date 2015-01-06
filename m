Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbbAFSdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:33:09 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:50655 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbAFSdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:33:07 -0500
Message-ID: <1420569175.5947.4.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: TCP connection issues against Amazon S3
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Erik Grinaker <erik@bengler.no>
Cc: linux-kernel@vger.kernel.org, Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>
Date: Tue, 06 Jan 2015 10:32:55 -0800
In-Reply-To: <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no>
	 <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com>
	 <D5C36777-4461-4B8D-B6C4-38B4276F42DC@bengler.no>
	 <1420564837.32621.30.camel@edumazet-glaptop2.roam.corp.google.com>
	 <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 18:17 +0000, Erik Grinaker wrote:

> Yes, pcap was taken on receiver (195.159.221.106).
> 
> > If the sender is broken, changing the kernel on receiver wont help.
> > 
> > BTW not using sack (on 54.231.132.98) is terrible for performance in
> > lossy environments.
> 
> It may well be that the sender is broken; however, the sender is
> Amazon S3, so I do not have any control over it. And in any case, the
> problem goes away with 3.11.10 on receiver, but persists with 3.12.0
> (or later) on receiver, so there must be some change in 3.12.0 which
> has caused this to trigger.

In fact I saw nothing obviously wrong in pcap (but I have not done a
full analysis)

It might simply be an application bug, triggering a timeout too soon.

A kernel change can be good, but by changing timings a bit, trigger
application bugs.


