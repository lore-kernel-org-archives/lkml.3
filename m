Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3HZIuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:50:44 -0400
Received: from goliath.siemens.de ([192.35.17.28]:16632 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3HZIun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:50:43 -0400
Message-ID: <521B16B9.4000203@siemens.com>
Date: Mon, 26 Aug 2013 10:50:01 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghua.yu@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        H Peter Anvin <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-32: Early microcode loading stumbles over disabled DYNAMIC_FTRACE
References: <5217908E.2040702@siemens.com> <20130823201751.GA16046@pd.tnic>
In-Reply-To: <20130823201751.GA16046@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-23 22:17, Borislav Petkov wrote:
> On Fri, Aug 23, 2013 at 06:40:46PM +0200, Jan Kiszka wrote:
>> Below some hunks to get it working again - at least in the absence of
>> any microcode in the initrd. Marking all involved functions as __init
>> is another option (as __init implies notrace). But I bet there is more
>> hidden. I see e.g. a pr_warn() in find_cpio_init that should trigger
>> the issue as well if we hit the error it reports (btw. printing at
>> this point of the boot should not work anyway, should it?).
> 
> I guess we can do early_printk there instead as x86_64_start_kernel()
> does it but I'm not sure for the 32-bit case where we call
> load_ucode_bsp/ap before we've even enabled paging.

early_printk doesn't seem to work as well on 32-bit until paging was
enabled.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
