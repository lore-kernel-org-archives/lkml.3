Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3GYIx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 04:53:59 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53514 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365Ab3GYIxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 04:53:55 -0400
Message-ID: <1374742433.29835.31.camel@x61.thuisdomein>
Subject: Re: compile x86_64 waring
From: Paul Bolle <pebolle@tiscali.nl>
To: Tom Rini <trini@ti.com>
Cc: Jianpeng Ma <majianpeng@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 10:53:53 +0200
In-Reply-To: <51F061CC.9080704@ti.com>
References: <201307051956052638321@gmail.com>
	 <1374699912.29835.8.camel@x61.thuisdomein> <51F061CC.9080704@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jul 2013 08:53:53.0769 (UTC) FILETIME=[7D77FD90:01CE8914]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 19:22 -0400, Tom Rini wrote:
> On 07/24/2013 05:05 PM, Paul Bolle wrote:
> > 3) So this looks like a false positive to me (but I'm not at all
> > familiar with, well, the section mismatch checks). Would there be a way
> > to silence this warning? Other than dropping __initdata from
> > numa_nodes_parsed, of course.
> 
> I suspect you have a real problem, in that either numa_nodes_parsed
> needs to not be __initdata (as it's being called by both __init and
> non-__init functions, and hence the problem), or the other caller(s) of
> numa_nodes_parsed need to also be __init.  Is this seen in top-of-tree
> Linus?

Won't v3.11-rc2 do?

> If so, I can take a peek took, if someone shoots me a config
> file.

The relevant config options should be CONFIG_NUMA and CONFIG_ACPI_NUMA
(both are bool, and set to 'y' in my .config).

But I've just pulled top-of-tree Linus, ie commit 07bc9dc1b0
("git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc'"). I'll
try to build that and I 'll send you my .config if this all is still
triggered.


Paul Bolle

