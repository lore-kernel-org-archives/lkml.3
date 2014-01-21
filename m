Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404AbaAUWTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:19:38 -0500
Received: from mail.windriver.com ([147.11.1.11]:64930 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaAUWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:19:34 -0500
Message-ID: <52DEF26B.80404@windriver.com>
Date: Tue, 21 Jan 2014 17:19:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 20/73] arm: use subsys_initcall in non-modular pl320 IPC
 code
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-21-git-send-email-paul.gortmaker@windriver.com> <4922482.oeJaTIvZxl@wuerfel>
In-Reply-To: <4922482.oeJaTIvZxl@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-21 04:44 PM, Arnd Bergmann wrote:
> On Tuesday 21 January 2014 16:22:23 Paul Gortmaker wrote:
>>
>> Note that direct use of __initcall is discouraged, vs. one
>> of the priority categorized subgroups.  As __initcall gets
>> mapped onto device_initcall, our use of subsys_initcall (which
>> seems to make sense for netfilter code) will thus change this
>> registration from level 6-device to level 4-subsys (i.e. slightly
>> earlier).  However no impact of that small difference is expected.
> 
> This doesn't have anything to do with netfilter. The only user
> of this driver at the moment is the highbank cpufreq driver, but
> that could change.

Thanks -- cut and paste error from an earlier, similar changeset.
Will "s/netfilter/IPC/" 

Paul.
--
> 
> 	Arnd
> 
