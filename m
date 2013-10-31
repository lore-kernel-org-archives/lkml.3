Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3JaS5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 14:57:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53975 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550Ab3JaS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 14:57:34 -0400
Date: Thu, 31 Oct 2013 11:57:14 -0700
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 4/9] of/irq: Refactor interrupt-map parsing
Message-ID: <20131031185714.GA12646@quad.lixom.net>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <1381869563-16083-5-git-send-email-grant.likely@linaro.org>
 <CAOesGMj03kgJXttm80pHvPYeqg5hOaeOJAJ4DA8tf5LxqdArrQ@mail.gmail.com>
 <CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uE+KvycQq3XBavRcvprff6PhBaxX54W_Cb1cfuVpMXvQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 02:25:21PM -0700, Grant Likely wrote:
> (Sorry for HTML mail)
> 
> Can you put #define DEBUG at the top of drivers/of/irq.c and send me the
> log output from before and after the commit?

Here you go, quite verbose log below.

Looks like we're tripping the "no reg passed in" checks, not sure if related.



After:

[arndale         01:05] [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[arndale         01:05] [    0.000000] Preemptible hierarchical RCU implementation.
[arndale         01:05] [    0.000000] NR_IRQS:16 nr_irqs:16 16
[arndale         01:05] [    0.000000] of_irq_init: init arm,cortex-a9-gic @ c1569754, parent   (null)
[arndale         01:05] [    0.000000] of_irq_init: init samsung,exynos4210-combiner @ c1569608, parent c1569754
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=0
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000000...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=1
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000001...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=2
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000002...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=3
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000003...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=4
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000004...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=5
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000005...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=6
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000006...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=7
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000007...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=8
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000008...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=9
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000009...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=10
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000a...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=11
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000b...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=12
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000c...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=13
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000d...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=14
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000e...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=15
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000f...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=16
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000010...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=17
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000011...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=18
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000012...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=19
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000013...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=20
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000014...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=21
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000015...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=22
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000016...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=23
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000017...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=24
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000018...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=25
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000019...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=26
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001a...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=27
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001b...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=28
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001c...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=29
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001d...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=30
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001e...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=31
[arndale         01:05] [    0.000000]  intspec=0 intlen=96
[arndale         01:05] [    0.000000]  intsize=3 intlen=96
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001f...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] Exynos5250: clock setup completed, armclk=1000000000
[arndale         01:05] [    0.000000] Exynos: Audss: clock setup completed
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/timer, index=0
[arndale         01:05] [    0.000000]  intspec=1 intlen=12
[arndale         01:05] [    0.000000]  intsize=3 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000d...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> no reg passed in when needed !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/timer, index=1
[arndale         01:05] [    0.000000]  intspec=1 intlen=12
[arndale         01:05] [    0.000000]  intsize=3 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000e...],ointsize=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> no reg passed in when needed !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/timer, index=2
[arndale         01:05] [    0.000000]  intspec=1 intlen=12
[arndale         01:05] [    0.000000]  intsize=3 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000b...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> no reg passed in when needed !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/timer, index=3
[arndale         01:05] [    0.000000]  intspec=1 intlen=12
[arndale         01:05] [    0.000000]  intsize=3 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000a...],ointsize=3
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         01:05] [    0.000000]  -> addrsize=1
[arndale         01:05] [    0.000000]  -> no reg passed in when needed !
[arndale         01:05] [    0.000000] arch_timer: No interrupt available, giving up
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=0
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000000 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=0
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000000 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=1
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000001 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=2
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000002 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=3
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000003 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=4
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000004 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=5
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000005 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=6
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=4
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000004 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=5
[arndale         01:05] [    0.000000]  intspec=0 intlen=12
[arndale         01:05] [    0.000000]  intsize=2 intlen=12
[arndale         01:05] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000005 0x00000000...],ointsize=2
[arndale         01:05] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         01:05] [    0.000000]  -> addrsize=0
[arndale         01:05] [    0.000000]  -> match=1 (imaplen=30)
[arndale         01:05] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         01:05] [    0.000000]  -> imaplen=27
[arndale         01:05] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         01:05] [    0.000000]  -> got it !
[arndale         01:05] [    0.000000] genirq: Flags mismatch irq 347. 00015200 (mct_comp_irq) vs. 00014a00 (mct_tick0)
[arndale         01:05] [    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns, wraps every 4294967291ms
[arndale         01:05] [    0.000000] Console: colour dummy device 80x30
[arndale         01:05] [    0.000000] Calibrating delay loop... 
[arndale         01:05] got exception: timeout



Before:


Huh, before this change we end up using pre-calculated elay loop:


[arndale         00:58] [    0.000000] Preemptible hierarchical RCU implementation.
[arndale         00:58] [    0.000000] NR_IRQS:16 nr_irqs:16 16
[arndale         00:58] [    0.000000] of_irq_init: init arm,cortex-a9-gic @ c1569754, parent   (null)
[arndale         00:58] [    0.000000] of_irq_init: init samsung,exynos4210-combiner @ c1569608, parent c1569754
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=0
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000000...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=1
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000001...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=2
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000002...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=3
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000003...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=4
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000004...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=5
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000005...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=6
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000006...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=7
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000007...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=8
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000008...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=9
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000009...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=10
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000a...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=11
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000b...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=12
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000c...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=13
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000d...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=14
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000e...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=15
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000000f...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=16
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000010...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=17
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000011...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=18
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000012...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=19
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000013...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=20
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000014...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=21
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000015...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=22
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000016...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=23
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000017...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=24
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000018...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=25
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x00000019...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=26
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001a...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=27
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001b...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=28
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001c...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=29
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001d...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=30
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001e...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/interrupt-controller@10440000, index=31
[arndale         00:58] [    0.000000]  intspec=0 intlen=96
[arndale         00:58] [    0.000000]  intsize=3 intlen=96
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000000 0x0000001f...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] Exynos5250: clock setup completed, armclk=1000000000
[arndale         00:58] [    0.000000] Exynos: Audss: clock setup completed
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/timer, index=0
[arndale         00:58] [    0.000000]  intspec=1 intlen=12
[arndale         00:58] [    0.000000]  intsize=3 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000d...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/timer, index=1
[arndale         00:58] [    0.000000]  intspec=1 intlen=12
[arndale         00:58] [    0.000000]  intsize=3 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000e...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/timer, index=2
[arndale         00:58] [    0.000000]  intspec=1 intlen=12
[arndale         00:58] [    0.000000]  intsize=3 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000b...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/timer, index=3
[arndale         00:58] [    0.000000]  intspec=1 intlen=12
[arndale         00:58] [    0.000000]  intsize=3 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/interrupt-controller@10481000,intspec=[0x00000001 0x0000000a...],ointsize=3
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/interrupt-controller@10481000, size=3
[arndale         00:58] [    0.000000]  -> addrsize=1
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] Architected cp15 timer(s) running at 24.00MHz (phys).
[arndale         00:58] [    0.000000] Switching to timer-based delay loop
[arndale         00:58] [    0.000000] sched_clock: ARM arch timer >56 bits at 24000kHz, resolution 41ns
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=0
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000000 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=0
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000000 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=1
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000001 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=2
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000002 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=3
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000003 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=15)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=12
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10440000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=4
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000004 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=15)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=12
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=10)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=6
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10481000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=5
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000005 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=15)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=12
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=10)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=6
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=4)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=0
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10481000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=6
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=4
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000004 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=15)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=12
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=10)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=6
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10481000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] of_irq_parse_one: dev=/mct@101C0000, index=5
[arndale         00:58] [    0.000000]  intspec=0 intlen=12
[arndale         00:58] [    0.000000]  intsize=2 intlen=12
[arndale         00:58] [    0.000000] of_irq_parse_raw: par=/mct@101C0000/mct-map,intspec=[0x00000005 0x00000000...],ointsize=2
[arndale         00:58] [    0.000000] of_irq_parse_raw: ipar=/mct@101C0000/mct-map, size=2
[arndale         00:58] [    0.000000]  -> addrsize=0
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=30)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=27
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=25)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=22
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=20)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=17
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=15)
[arndale         00:58] [    0.000000]  -> newintsize=2, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=12
[arndale         00:58] [    0.000000]  -> match=0 (imaplen=10)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=6
[arndale         00:58] [    0.000000]  -> match=1 (imaplen=4)
[arndale         00:58] [    0.000000]  -> newintsize=3, newaddrsize=0
[arndale         00:58] [    0.000000]  -> imaplen=0
[arndale         00:58] [    0.000000]  -> new parent: /interrupt-controller@10481000
[arndale         00:58] [    0.000000]  -> got it !
[arndale         00:58] [    0.000000] sched_clock: 32 bits at 200 Hz, resolution 5000000ns, wraps every 4294967291ms
[arndale         00:58] [    0.000000] Console: colour dummy device 80x30
[arndale         00:58] [    0.012702] Calibrating delay loop (skipped), value calculated using timer frequency.. 48.00 BogoMIPS (lpj=120000)
[arndale         00:58] [    0.022934] pid_max: default: 32768 minimum: 301

