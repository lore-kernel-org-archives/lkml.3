Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3CFBSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 20:18:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51407 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab3CFBSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 20:18:36 -0500
Message-ID: <51369964.6040101@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 17:18:28 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Rob Landley <rob@landley.net>, George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: %pa format specifier issues
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030601-7182-0000-0000-000005A880CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I went to go use the shiny new %pa specifier:

void test_printk_pa(void)
{
        phys_addr_t p = 0x1234;
        printk("p: %pa\n", p);
}

but gcc is spewing out warnings at me:

> arch/x86/mm/physaddr.c: In function ‘test_printk_pa’:
> arch/x86/mm/physaddr.c:95:2: warning: format ‘%p’ expects argument of type ‘void *’, but argument 2 has type ‘phys_addr_t’ [-Wformat]

I assume that's because gcc doesn't know about '%pa', and just assumes
it's a plain '%p'.  Should we be turning these warnings off somehow?

Plus when I actually go to run it, vsnprintf() crashes the kernel, which
usually happens if printk()'s format doesn't match the size of its
arguments.

Am I doing something really stupid here?

This is using a 32-bit i386 kernel.

