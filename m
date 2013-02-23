Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3BWXvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 18:51:21 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55804 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592Ab3BWXvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 18:51:20 -0500
Message-ID: <512955F7.1020309@wwwdotorg.org>
Date: Sat, 23 Feb 2013 16:51:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v5 1/3] mfd: syscon: Removed support for unloading
References: <1361596520-19332-1-git-send-email-shc_work@mail.ru> <512851E0.7000808@wwwdotorg.org> <1361597308.137178281@f2.mail.ru>
In-Reply-To: <1361597308.137178281@f2.mail.ru>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 10:28 PM, Alexander Shiyan wrote:
>> On 02/22/2013 10:15 PM, Alexander Shiyan wrote:
>>> The driver can be used in various subsystems and therefore should not
>>> be unloaded when it is defined in the kernel configuration, so remove
>>> support for unloading it.
>>
>> Why not fix the clients to module_get() at the appropriate times; then
>> you could still allow unloading, couldn't you?
> 
> I has explain this before.

If multiple people have asked this, perhaps it'd be a good idea to
include the answer in the commit description.

> Driver defined as "bool" and loaded via postcore_initcall.

Being defined as a "bool" sounds like a reasonable reason that no
remove() is required.

Being loaded via postcore_initcall() (a) should have absolutely no
influence over whether a remove() is required (an actual module could
just as well include a postcore_initcall function, which would get
executed at module load time), and (b) is wrong; initcall ordering
shouldn't be used to influence driver probe ordering.
