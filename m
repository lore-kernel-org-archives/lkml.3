Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaAKQfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 11:35:13 -0500
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:42926 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbaAKQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 11:35:06 -0500
X-Greylist: Passed host: 95.91.230.143
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-03.arcor-online.net E2CC7D8A78
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
X-Greylist: Passed host: 95.91.230.143
Date: Sat, 11 Jan 2014 16:35:00 +0000 (UTC)
From: 7eggert@gmx.de
To: Prarit Bhargava <prarit@redhat.com>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linn Crosetto <linn@hp.com>,
        Pekka Enberg <penberg@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>,
        kosaki.motohiro@gmail.com, dyoung@redhat.com,
        linux-acpi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] x86, e820 disable ACPI Memory Hotplug if memory
 mapping is specified by user [v2]
In-Reply-To: <1389380698-19361-4-git-send-email-prarit@redhat.com>
Message-ID: <alpine.DEB.2.02.1401111624170.20677@be1.lrz>
References: <1389380698-19361-1-git-send-email-prarit@redhat.com> <1389380698-19361-4-git-send-email-prarit@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jan 2014, Prarit Bhargava wrote:

> kdump uses memmap=exactmap and mem=X values to configure the memory
> mapping for the kdump kernel.  If memory is hotadded during the boot of
> the kdump kernel it is possible that the page tables for the new memory
> cause the kdump kernel to run out of memory.
> 
> Since the user has specified a specific mapping ACPI Memory Hotplug should be
> disabled in this case.

I'll ask just in case: Is it possible to want memory hotplug in spite of 
using memmap=exactmap or mem=X?
