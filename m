Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaDOIMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:12:00 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40266 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaDOIL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <534BF7FE.6050603@hitachi.com>
References: <1397472050-19947-1-git-send-email-nasa4836@gmail.com> <534BF7FE.6050603@hitachi.com>
From: Zhan Jianyu <nasa4836@gmail.com>
Date: Tue, 15 Apr 2014 16:11:14 +0800
Message-ID: <CAHz2CGV_WA_bMwYCg1QCyFpCv0PKgPhBQUf_pFQbNn-guLL+Ag@mail.gmail.com>
Subject: Re: [PATCH] kprobes: be more permissive when user specifies both
 symbol name and address
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 11:00 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> if (p->addr) {
>   if (p->symbol) {
>     sym = kallsyms_lookup(p->addr, ... &offs ...);
>     if (strcmp(sym,p->symbol) != 0 || offs != p->offset) {
>       pr_warning("Error! ...");
>       goto fail;
>     }
>   }
> } else if (p->symbol) {
>   kprobe_lookup_name(p->symbol_name, addr);
>   if (!addr)
>     goto fail;
> } else
>   goto fail;


Hmm, let's clasify all conditions.

1. Only symbol, check it, if not found, fail.
2. Only address, check it, if not found, fail.
3. Both, check address,
    3.1 not found, fail, because some symbols might have muplitple instances,
          we don't bother to check symbol name.
    3.2 found, check if symbol mismatch, if yes, fail.


Is this reasonable?  Next mail is a renewed patch following this priciple.


Regards,
Jianyu Zhan
