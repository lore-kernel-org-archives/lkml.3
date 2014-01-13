Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaAMOsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:48:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:34800 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbaAMOsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:48:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,653,1384329600"; 
   d="scan'208";a="464320477"
Message-ID: <52D3FCAA.7070004@linux.intel.com>
Date: Mon, 13 Jan 2014 06:48:10 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>
CC: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 1/4] x86, ptdump: Add the functionality to dump an arbitrary
 pagetable
References: <1389473370-1940-1-git-send-email-bp@alien8.de> <1389473370-1940-2-git-send-email-bp@alien8.de> <20140113053240.GA11237@dhcp-16-126.nay.redhat.com> <20140113101822.GA5388@pd.tnic> <20140113122320.GA1900@darkstar.nay.redhat.com>
In-Reply-To: <20140113122320.GA1900@darkstar.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/13/2014 4:23 AM, Dave Young wrote:
>>
>>> How about do not limit to only if (pgd) case, instead do something
>>> like below: set dump_to_dmesg as a module parameter
>>
>> X86_PTDUMP is not a module.
>
> Hmm, I just see the module macros in the code, since it's a bool Kconfig
> I think the dump_pagetables.c need a cleanup,
> remove the #include <linux/module.h> and below lines:
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Arjan van de Ven <arjan@linux.intel.com>");
> MODULE_DESCRIPTION("Kernel debugging helper that dumps pagetables");

personally I consider it good form to always have this kind of information in .c files,
regardless of the KConfig side of thing...

