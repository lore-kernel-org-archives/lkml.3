Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934831Ab3DOF5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 01:57:15 -0400
Received: from www.sr71.net ([198.145.64.142]:47580 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788Ab3DOF5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 01:57:14 -0400
Message-ID: <516B9714.80007@sr71.net>
Date: Sun, 14 Apr 2013 22:58:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cliff Wickman <cpw@sgi.com>, Simon Horman <horms@verge.net.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Renninger <trenn@suse.de>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 5/5] kexec: X86: Pass memory ranges via e820 table instead
 of memmap= boot parameter
References: <1365683207-42425-1-git-send-email-trenn@suse.de> <1365683207-42425-6-git-send-email-trenn@suse.de> <CAE9FiQXnZzVC7dtvXWrqz=jYAGH053R8Vw1qkrMd2F+hAaMxdQ@mail.gmail.com> <5166D18A.7090800@zytor.com> <20130412143104.GA4301@redhat.com> <5168208B.7050107@zytor.com> <51688803.8020401@sr71.net> <516B87A6.9080708@jp.fujitsu.com>
In-Reply-To: <516B87A6.9080708@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2013 09:52 PM, HATAYAMA Daisuke wrote:
> This sounds like there's no such issue on x86 cache mechanism. Is it
> correct? If so, what is the difference between ia64 and x86 cache
> mechanisms?

I'm just going by the code comments:

drivers/char/mem.c
>                 /*
>                  * On ia64 if a page has been mapped somewhere as uncached, then
>                  * it must also be accessed uncached by the kernel or data
>                  * corruption may occur.
>                  */

