Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3FXJls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:41:48 -0400
Received: from science.horizon.com ([71.41.210.146]:43130 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325Ab3FXJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:41:46 -0400
Date: 24 Jun 2013 05:41:45 -0400
Message-ID: <20130624094145.2576.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: gaofeng@cn.fujitsu.com, linux@horizon.com
Subject: Re: v3.10-rc7 oops soon after boot
Cc: bp@alien8.de, kaber@trash.net, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, pablo@netfilter.org
In-Reply-To: <51C80D6F.6070907@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please try the patch below,
> I think this bug is introduced by me :(
> 
> Thanks!

Well, you changed it, but it still crashes.

It's now at del_timer+0x9/0x58, with the code being:

3f 00 55 53 48 89 fb 48 83 ec 10 <48> 83 3f 00 48 c7 47

The backtrace is
 <IRQ>
 ? ulog_send+0x21/0x76
 ? ulog_timer+0x2d/0x39
 ? ulog_send+0x76/0x76
 ? call_timer_fn.isra
 ? run_timer_softirq
 ? __do_softirq
 ? irq_exit
 ? do_IRQ
 ? common_interrupt
 <EOI>

(To give a faster response, I just transcribed a few key
sections.  Is that enough of a clue, or do you need more?)
