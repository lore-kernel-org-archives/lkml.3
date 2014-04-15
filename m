Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaDOI1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:27:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45064 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaDOI1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:27:13 -0400
Message-ID: <534CED5B.2090100@hitachi.com>
Date: Tue, 15 Apr 2014 17:27:07 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Zhan Jianyu <nasa4836@gmail.com>
Cc: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] kprobes: be more permissive when user specifies both
 symbol name and address
References: <1397472050-19947-1-git-send-email-nasa4836@gmail.com> <534BF7FE.6050603@hitachi.com> <CAHz2CGV_WA_bMwYCg1QCyFpCv0PKgPhBQUf_pFQbNn-guLL+Ag@mail.gmail.com>
In-Reply-To: <CAHz2CGV_WA_bMwYCg1QCyFpCv0PKgPhBQUf_pFQbNn-guLL+Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 17:11), Zhan Jianyu wrote:
> On Mon, Apr 14, 2014 at 11:00 PM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> if (p->addr) {
>>   if (p->symbol) {
>>     sym = kallsyms_lookup(p->addr, ... &offs ...);
>>     if (strcmp(sym,p->symbol) != 0 || offs != p->offset) {
>>       pr_warning("Error! ...");
>>       goto fail;
>>     }
>>   }
>> } else if (p->symbol) {
>>   kprobe_lookup_name(p->symbol_name, addr);
>>   if (!addr)
>>     goto fail;
>> } else
>>   goto fail;
> 
> 
> Hmm, let's clasify all conditions.
> 
> 1. Only symbol, check it, if not found, fail.
> 2. Only address, check it, if not found, fail.
> 3. Both, check address,
>     3.1 not found, fail, because some symbols might have muplitple instances,
>           we don't bother to check symbol name.
>     3.2 found, check if symbol mismatch, if yes, fail.

  Plus, if the p->offset and offs are different, fail too.

> Is this reasonable?  Next mail is a renewed patch following this priciple.

OK, let me see. :)

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


