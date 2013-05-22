Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3EVJIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:08:46 -0400
Received: from gatzka.org ([85.214.228.118]:39523 "EHLO mail.gatzka.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3EVJIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:08:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 May 2013 11:08:43 +0200
From: Stephan Gatzka <stephan.gatzka@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, peter@hurleysoftware.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: function call =?UTF-8?Q?fw=5Fiso=5Fresource=5Fmange=28=2E=2E?=
 =?UTF-8?Q?=29=20=28core-iso=2Ec=29=20does=20not=20return?=
Reply-To: stephan.gatzka@gmail.com
Mail-Reply-To: stephan.gatzka@gmail.com
In-Reply-To: <20130521222817.3626b59d@stein>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <20130521222817.3626b59d@stein>
Message-ID: <24da2e78e684e560c5aa034cebd3e26b@gatzka.org>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Wait a minute --- I seem to be reading of Xenomai RT extensions for the
> first time in this thread.  Has the problem been reproduced on a 
> mainline
> kernel too?  (Mainline plus Ralf's firewire upper layer driver maybe, 
> but
> without any other 3rd party stuff please.  Actually the issue should be
> reproducible even without an upper layer driver performing
> fw_iso_resource_manage in fw_workqueue context, shouldn't it?)

Unfortunately it's not that easy. While I agree that it should be 
reproducible just with mainline stuff, we have to force our system into 
the situation that it "thinks" it's under memory pressure to hand over 
the work to the rescuer thread. It looks that a simple printk from a 
different driver might lead to that situation on our system.

As a first fix, I would say we have at least bring bus_reset_work() 
running on its own workqueue because otherwise we cannot guarantee 
progress of bus_reset_work under memory pressure.


> There is quite a bit going on in firewire-ohci's and firewire-core's 
> parts
> of self-ID-complete event handling.  But I suspect that stuff like that 
> is
> still not in the league for which CPU_INTENSIVE was intended for
> (cryptography etc.).

Some advice from Tejun would be great here...


