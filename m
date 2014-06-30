Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaF3QcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:32:01 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaF3Qb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:31:59 -0400
Message-ID: <53B190FE.80208@infradead.org>
Date: Mon, 30 Jun 2014 09:31:58 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kernel-doc: handle object-like macros
References: <1403525732-7653-1-git-send-email-horia.geanta@freescale.com> <53AF7F63.9080807@infradead.org> <53B16B46.7060101@freescale.com>
In-Reply-To: <53B16B46.7060101@freescale.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/14 06:51, Horia Geantă wrote:
> On 6/29/2014 5:52 AM, Randy Dunlap wrote:
>> On 06/23/14 05:15, Horia Geanta wrote:
>>> Object-like macros are different than function-like macros:
>>> https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros.html
>>> https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html
>>>
>>> They are not parsed correctly, generating invalid intermediate
>>> files (xmls) for cases like:
>>>      #define BIT_MASK    (0xFF << BIT_SHIFT)
>>> where "OxFF <<" is considered to be parameter type.
>>>
>>> When parsing, we can differentiate beween these two types of macros by
> 
>                                      between.
> 
>>> checking whether there is at least one whitespace b/w "#define" and
>>> first opening paranthesis.
>>
>>                  parenthesis.
> 
> Thanks, I'll fix both typos in v2.
> 
>>
>> Where did you see a problem?  I tested the patch and all of the
>> Documentation/DocBook/*.xml files are the same without or with the patch.
>>
> 
> Indeed, right now there is no kernel-doc for "object-like" macros in Docbook.
> 
> I am preparing documentation for not-yet-upstreamed code in drivers/crypto/caam and I thought it would be useful to use kernel-doc for some of the #defines.

OK, thanks for the explanation.  I am applying your patch.

> Doc would look like this (no @param list, no "Return" section, only a description):
> 
> /**
>  * DEFAULT_SEC_ERA - the default value for the SEC era in case the user
>  * provides an unsupported value.
>  */
> #define DEFAULT_SEC_ERA 6


-- 
~Randy
