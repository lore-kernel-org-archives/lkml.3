Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbaANBqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:46:19 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39676 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaANBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:46:15 -0500
Message-ID: <1389663614.1792.267.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory
 mapping is specified by user [v2]
From: Toshi Kani <toshi.kani@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Bodo Eggert <7eggert@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        dyoung@redhat.com, linux-acpi@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Mon, 13 Jan 2014 18:40:14 -0700
In-Reply-To: <52D49307.3040406@zytor.com>
References: <1389380698-19361-1-git-send-email-prarit@redhat.com>
			 <1389380698-19361-4-git-send-email-prarit@redhat.com>
			 <alpine.DEB.2.02.1401111624170.20677@be1.lrz>
		 <52D32962.5050908@redhat.com>
			 <CAHGf_=qWB81f8fdDdjaXXh1JoSDUsJmcEHwH+CEJ2E-5XWz6qA@mail.gmail.com>
			 <52D4793E.8070102@redhat.com>
	 <1389659632.1792.247.camel@misato.fc.hp.com>	 <52D48A9D.7000003@zytor.com>
	 <1389661746.1792.254.camel@misato.fc.hp.com> <52D49307.3040406@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 17:29 -0800, H. Peter Anvin wrote:
> On 01/13/2014 05:09 PM, Toshi Kani wrote:
> > 
> > In majority of the cases, memmap=exactmap is used for kdump and the
> > firmware info is sane.  So, I think we should keep NUMA enabled since it
> > could be useful when multiple CPUs are enabled for kdump.
> > 
> 
> Rather unlikely since all of the kdump memory is likely to sit in a
> single node.

Right, but CPUs are distributed into multiple nodes, which dump the 1st
kernel's memory.  So, these CPUs should dump their local memory ranges.

Thanks,
-Toshi

