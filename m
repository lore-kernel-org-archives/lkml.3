Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3H3Of2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:35:28 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752822Ab3H3Of0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:35:26 -0400
Message-ID: <5220ADA6.5050708@nod.at>
Date: Fri, 30 Aug 2013 16:35:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org
Subject: Acceptance of proprietary kernel modules
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

over the last  months I've reviewed lot's of Linux based products, mostly networking related
devices like firewalls, WiFi access points, DSL routers, IPMI, etc...
The vast majority of them had proprietary kernel modules loaded.
I'm not talking about single self contained device drivers. In the wild you'll find whole kernel
subsystems such as complete firewalling stacks, deep packet inspection, IPsec implementations, anti virus scanners, network introduction detection systems (yes, in kernel!),
protocol implementations like MPLS, in-kernel VNC servers, and so on as proprietary kernel modules.

Of course, all of them use EXPORT_SYMBOL() symbols only, but nobody can tell me that
these modules are self contained and not a derived work of the kernel.
One vendor even applied a patch on the kernel which did a s/EXPORT_SYMBOL_GPL/ EXPORT_SYMBOL/g on a few files, but that's a different story.
Reading the disassembly of said modules showed that most of them are clearly designed to run only on Linux. (e.g. every single function references a random Linux kernel symbol).
It's not like NVIDIA's GPU driver which clearly is designed to work on many operating systems and Linux is one of that.
I have the feeling that such doubtful modules are no longer isolated cases, they are the common case.

This leads me to one question.
Have we reached a state where proprietary kernel modules are just accepted and nobody cares?

Thanks,
//richard

P.s: My goal is not to start a GPL-violator witch-hunt.
