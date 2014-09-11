Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaIKECc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:02:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32868 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbaIKEC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:02:29 -0400
Message-ID: <54111E99.9010408@zytor.com>
Date: Wed, 10 Sep 2014 21:01:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, linux-kernel@vger.kernel.org
CC: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>, x86@kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com> <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 07:31 AM, Andrey Ryabinin wrote:
> This patch add arch specific code for kernel address sanitizer.
> 
> 16TB of virtual addressed used for shadow memory.
> It's located in range [0xffff800000000000 - 0xffff900000000000]
> Therefore PAGE_OFFSET has to be changed from 0xffff880000000000
> to 0xffff900000000000.

NAK on this.

0xffff880000000000 is the lowest usable address because we have agreed
to leave 0xffff800000000000-0xffff880000000000 for the hypervisor or
other non-OS uses.

Bumping PAGE_OFFSET seems needlessly messy, why not just designate a
zone higher up in memory?

	-hpa

