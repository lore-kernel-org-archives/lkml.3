Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaAZECg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 23:02:36 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:38184 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaAZECf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 23:02:35 -0500
Date: Sat, 25 Jan 2014 20:02:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
In-Reply-To: <52D7A8F0.70807@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com>
References: <52D7A8F0.70807@jp.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-1335816573-1390708951=:10325"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-1335816573-1390708951=:10325
Content-Type: TEXT/PLAIN; charset=ISO-2022-JP

On Thu, 16 Jan 2014, HATAYAMA Daisuke wrote:

> Hello,
> 
> This patch deals with the issue of handling boot_cpu_physical_apicid
> in boot process I avoided in disable_cpu_apicid patch because I
> cannot guess how long it needs to take for the review of this fix.
> 
> This patch is made on top of today's x86/apic branch of tip tree.
> Its commit hash is 5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
> 

This breaks with SGI 320/540:

arch/x86/platform/visws/visws_quirks.c: In function ‘MP_processor_info’:
arch/x86/platform/visws/visws_quirks.c:169:3: error: ‘bios_cpu_physical_apicid’ undeclared (first use in this function)
arch/x86/platform/visws/visws_quirks.c:169:3: note: each undeclared identifier is reported only once for each function it appears in

It makes it pretty apparent that you want a different name for the new 
variable, bios_bsp_physical_apicid is just too close to 
boot_cpu_physical_apicid that even the author of the patch missed a 
conversion.

(It's also really sad that we can't make it __initdata since it's only 
valid at boot because of the hotplug stuff.)
--531381512-1335816573-1390708951=:10325--
