Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbaCKBJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 21:09:08 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64876 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaCKBJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 21:09:05 -0400
Message-ID: <531E622A.5010200@gmail.com>
Date: Tue, 11 Mar 2014 09:08:58 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com> <531B3178.8000804@infradead.org> <531B8F2C.8080302@gmail.com> <531B9281.1080500@infradead.org> <531C8269.4010105@gmail.com> <531C95BE.1070306@infradead.org>
In-Reply-To: <531C95BE.1070306@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2014 12:24 AM, Randy Dunlap wrote:
> On 03/09/2014 08:02 AM, Chen Gang wrote:
>> On 03/09/2014 05:58 AM, Randy Dunlap wrote:
>>> On 03/08/2014 01:44 PM, Chen Gang wrote:
[...]
>>
>> Can we say that the 'select' priority is higher or equal than 'depends
>> on'?  If we really can say so, we need change our gpio driver.
> 
> what driver is "our gpio driver"?
> 

Only point to GPIO_DWAPB driver.

For me, if its full source code are in our upstream kernel, we need
treat it as "our source code". So when we find an issue about it, we can
also treat it as our issue.


> Documentation/kbuild/kconfig-language.txt does not talk about priorities
> of depends or select.
> 

OK, thanks, I will/should read it completely.


>> Else ('depends on' priority is higher than 'select')
>>
>>  - some architectures can choose whether support IRQ_DOMAIN.
>>
>>  - if IRQ_DOMAIN enabled, our gpio driver can be used, and then select
>>    GENERIC_IRQ_CHIP (need not consider about it selects IRQ_DOMAIN).
>>
>>  - else (IRQ_DOMAIN_disabled), we can not use our gpio driver, and also
>>    can not select GENERIC_IRQ_CHIP (need not consider about it selects
>>    IRQ_DOMAIN, either).
>>
>> Excuse me, I am not quite familiar with Kconfig grammar, can any members
>> give a confirmation for it (whether 'select' priority is higher or equal
>> than 'depends on').
> 
> Sorry, I don't really understand the problem that you are trying to solve.
> Maybe you could back up and explain the underlying problem... ?
>

If the fix patch applied (don't depend on IRQ_DOMAIN), I guess, if one
architecture don't support IRQ_DOMAIN, GPIO_DWAPB may still be enabled
and then let IRQ_DOMAIN enable too.



Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
