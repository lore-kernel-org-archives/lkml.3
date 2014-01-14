Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaANAyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:54:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaANAy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:54:28 -0500
Message-ID: <52D48A9D.7000003@zytor.com>
Date: Mon, 13 Jan 2014 16:53:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Prarit Bhargava <prarit@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Bodo Eggert <7eggert@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        dyoung@redhat.com, linux-acpi@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory mapping
 is specified by user [v2]
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>	 <1389380698-19361-4-git-send-email-prarit@redhat.com>	 <alpine.DEB.2.02.1401111624170.20677@be1.lrz> <52D32962.5050908@redhat.com>	 <CAHGf_=qWB81f8fdDdjaXXh1JoSDUsJmcEHwH+CEJ2E-5XWz6qA@mail.gmail.com>	 <52D4793E.8070102@redhat.com> <1389659632.1792.247.camel@misato.fc.hp.com>
In-Reply-To: <1389659632.1792.247.camel@misato.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 04:33 PM, Toshi Kani wrote:
> 
> I do not think it makes sense.  You needed memmap=exactmap as a
> workaround because the kernel did not boot with the firmware's memory
> info.  So, it's broken, and you requested the kernel to ignore the
> firmware info.
> 
> Why do you think memory hotplug needs to be supported under such
> condition, which has to use the broken firmware info?
> 

Even more than memory hotplug: what do we do with NUMA?  Since we have
already told the kernel "the firmware is bogus" it would seem that any
NUMA optimizations would be a bit ... cantankerous at best, no?

	-hpa


