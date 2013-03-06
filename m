Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3CFCT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 21:19:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41747 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3CFCTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 21:19:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,791,1355126400"; 
   d="scan'208";a="27836299"
Message-ID: <5136A7CA.70308@codeaurora.org>
Date: Tue, 05 Mar 2013 18:19:54 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>, George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: %pa format specifier issues
References: <51369964.6040101@linux.vnet.ibm.com>
In-Reply-To: <51369964.6040101@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/13 17:18, Dave Hansen wrote:
> I went to go use the shiny new %pa specifier:
>
> void test_printk_pa(void)
> {
>         phys_addr_t p = 0x1234;
>         printk("p: %pa\n", p);
> }
>
> but gcc is spewing out warnings at me:
>
>> arch/x86/mm/physaddr.c: In function ‘test_printk_pa’:
>> arch/x86/mm/physaddr.c:95:2: warning: format ‘%p’ expects argument of type ‘void *’, but argument 2 has type ‘phys_addr_t’ [-Wformat]
> I assume that's because gcc doesn't know about '%pa', and just assumes
> it's a plain '%p'.  Should we be turning these warnings off somehow?
>
> Plus when I actually go to run it, vsnprintf() crashes the kernel, which
> usually happens if printk()'s format doesn't match the size of its
> arguments.
>
> Am I doing something really stupid here?
>
> This is using a 32-bit i386 kernel.
>

>From reading the patch I thought you had to pass the address via
reference. Otherwise you get the warning like you mention here, and then
probably an oops when the kernel tries to dereference 0x1234.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

