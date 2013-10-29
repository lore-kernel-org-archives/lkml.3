Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3J2BJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:09:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30991 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3J2BJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:09:02 -0400
X-Spam-Score: -100.8
Message-ID: <526F0A71.4000504@asianux.com>
Date: Tue, 29 Oct 2013 09:08:01 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, noamc@ezchip.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: remove '__init' for first_lines_of_secondary()
References: <52673186.4050806@asianux.com> <526E6C6B.9020507@synopsys.com>
In-Reply-To: <526E6C6B.9020507@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 09:53 PM, Vineet Gupta wrote:
> On 10/23/2013 07:46 AM, Chen Gang wrote:
>> first_lines_of_secondary() is a '__init' function, but it may be called
>> by __cpu_up() by _cpu_up() by cpu_up() which is a normal export symbol
>> function. So recommend to remove '__init'.
>>
>> The related warning (with allmodconfig):
>>
>>     MODPOST vmlinux.o
>>   WARNING: vmlinux.o(.text+0x315c): Section mismatch in reference from the function __cpu_up() to the function .init.text:first_lines_of_secondary()
>>   The function __cpu_up() references
>>   the function __init first_lines_of_secondary().
>>   This is often because __cpu_up lacks a __init
>>   annotation or the annotation of first_lines_of_secondary is wrong.
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Applied for 3.13. But I'm planning to squash all the __init section annotation
> fixes into one patch. OK with you ?
> 

It is OK to me. They are all related with each other, although toolchain
reports several warnings (originally, I made them based on warning items).


Thanks.
-- 
Chen Gang
