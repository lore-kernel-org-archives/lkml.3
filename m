Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3DLWRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:17:41 -0400
Received: from www.sr71.net ([198.145.64.142]:33192 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3DLWRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:17:41 -0400
Message-ID: <51688803.8020401@sr71.net>
Date: Fri, 12 Apr 2013 15:17:39 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Simon Horman <horms@verge.net.au>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Cliff Wickman <cpw@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com>
In-Reply-To: <5168208B.7050107@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 07:56 AM, H. Peter Anvin wrote:
> On 04/12/2013 07:31 AM, Vivek Goyal wrote:
>>> I also have to admit that I don't see the difference between /dev/mem
>>> and /dev/oldmem, as the former allows access to memory ranges outside
>>> the ones used by the current kernel, which is what the oldmem device
>>> seems to be intended to od.

It varies from arch to arch of course.

But, /dev/mem has restrictions on it, like CONFIG_STRICT_DEVMEM or the
ARCH_HAS_VALID_PHYS_ADDR_RANGE.  There's a lot of stuff that depends on
it, *and* folks have tried to fix it up so that it's not _as_ blatant of
a way to completely screw your system.

/dev/mem also tries to be nice to arches that have restrictions like:

>                         /*
>                          * On ia64 if a page has been mapped somewhere as
>                          * uncached, then it must also be accessed uncached
>                          * by the kernel or data corruption may occur
>                          */

I think /dev/oldmem isn't so nice and could actually cause some real
problems if used on ia64 where the cached/uncached accesses are mixed.
