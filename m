Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbbAUI7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:59:25 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:49148 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbAUI7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:59:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Jan 2015 09:59:10 +0100
From: Stefan Agner <stefan@agner.ch>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Salter <msalter@redhat.com>, Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2] ARM: early fixmap support for earlycon
In-Reply-To: <20150120234821.GN26493@n2100.arm.linux.org.uk>
References: <1421797064-2989-1-git-send-email-stefan@agner.ch>
 <20150120234821.GN26493@n2100.arm.linux.org.uk>
Message-ID: <111244e22ade6c1e3585cf03cb2f7653@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-21 00:48, Russell King - ARM Linux wrote:
> On Wed, Jan 21, 2015 at 12:37:44AM +0100, Stefan Agner wrote:
>> Add early fixmap support, initially to support permanent, fixed
>> mapping support for early console. A temporary, early pte is
>> created which is migrated to a permanent mapping in paging_init.
>> This is also needed since the attributs may change as the memory
>> types are initialized. The 3MiB range of fixmap spans two pte
>> tables, but currently only one pte is created for early fixmap
>> support.
> 
> I think this needs to be done more carefully - I think the entry(ies)
> should be removed, the TLBs flushed, and the new entry established.
> So:

I'm not experienced in mm development, hence please review critical.
 
> 
>> +static void __init early_fixmap_shutdown(void)
>> +{
>> +	int i;
>> +
>> +	pte_offset_fixmap = &pte_offset_late_fixmap;
>> +	pmd_clear(fixmap_pmd(fix_to_virt(__end_of_permanent_fixed_addresses - 1)));
> 
> I think you should flush tlbs here.

Even this shutdown function is still before preemption or SMP, hence
local_flush_tlb_kernel_page should be fine here?

--
Stefan
