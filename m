Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3H1NLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:11:21 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:50709 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3H1NLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:11:18 -0400
Message-ID: <521DF6F2.9090200@xs4all.nl>
Date: Wed, 28 Aug 2013 15:11:14 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: weird keyboard issue (ps/2 port?) 3.9.x/3.10.x?
References: <20130827174156.GA19152@rhlx01.hs-esslingen.de>
In-Reply-To: <20130827174156.GA19152@rhlx01.hs-esslingen.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-27 19:41, Andreas Mohr wrote:
>> What could this be?
>> Is it really a software issue?
>> If so: how could I help fix this?
> 
> Perhaps watching the output of some input event tools could help
> gather some clues to eventually get it nailed down?

Sure.
First my input:

When I run this small script to fix the irq issue, I see that also the
stream of ^@^@^@ stops (or at least appears to do so), when those ^@^@^@
were active:

service motion stop
rmmod pwc
echo 0000:00:13.0 >/sys/bus/pci/drivers/ohci_hcd/unbind
echo 0000:00:13.0 >/sys/bus/pci/drivers/ohci_hcd/bind
modprobe pwc
service motion start

> Some candidates:
> 
> evtest - utility to monitor Linux input device events
> input-utils - utilities for the input layer of the Linux kernel
> xinput - Runtime configuration and test of XInput devices

I'll look into these!

> And what do /proc/interrupts counts say? Does PS/2 (i8042) generate events?

Currently it does. But I must see what happens when all is quiet, and
the problem reappears, right?

