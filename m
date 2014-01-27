Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaA0X6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 18:58:43 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:39226 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbaA0X6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 18:58:40 -0500
Date: Mon, 27 Jan 2014 15:58:37 -0800 (PST)
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
In-Reply-To: <52E5CA8D.7000602@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1401271555150.17114@chino.kir.corp.google.com>
References: <52D7A8F0.70807@jp.fujitsu.com> <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com> <52E5CA8D.7000602@jp.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, HATAYAMA Daisuke wrote:

> One idea is not to add bios_bsp_physical_apicid, just removing
> assignment to boot_cpu_physical_apicid from MP_processor_info().
> I guess currently no one uses apicid provided by MP table
> since boot_cpu_physical_apicid is finally initialized in
> init_apic_mappings().
> 

Yeah, following generic_processor_info() it looks like it can be dropped.
