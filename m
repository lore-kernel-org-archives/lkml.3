Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab3HTUB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 16:01:26 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40613 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3HTUBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 16:01:25 -0400
Message-ID: <5213CB19.6000905@gmail.com>
Date: Tue, 20 Aug 2013 22:01:29 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Rob Herring <rob.herring@calxeda.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 05/17] ARM: highbank: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-6-git-send-email-sebastian.hesselbarth@gmail.com> <5213BF91.3030300@calxeda.com>
In-Reply-To: <5213BF91.3030300@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 09:12 PM, Rob Herring wrote:
> On 08/19/2013 09:04 PM, Sebastian Hesselbarth wrote:
>> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
>> remove custom .init_time hooks. Highbank clock provider need a reference
>> to system registers, as a workaround current clk driver maps those
>> independent of arch code now.
>>
>> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>> ---
>> Notes:
>> - I suggest to consolidate the four single clock providers into a single
>>    provider with one node if possible.
>
> And how do you suggest doing that while maintaining the DT ABI?

Rob,

I am aware of ABI status of the DT bindings and the discussion about
deprecating/cleanup of what went in in the past. Maybe "suggest" is a
little bit too strong and should have been "would be nice to have".

But looking at clk-highbank, all providers depend on the same register.
If you'd introduce e.g. a new "calxeda,core-clocks" that sets up the
four providers and also CLK_OF_DECLARE the same init with one out of
the  four existing compatibles shouldn't that maintain backwards
compatibility?

Anyway, I was just puting the note above to raise some comment on it.
You actually gave a good one to leave it as is.

>> ---
>>   arch/arm/mach-highbank/highbank.c |   23 +++++++----------------
>>   drivers/clk/clk-highbank.c        |   10 +++++++---
>>   2 files changed, 14 insertions(+), 19 deletions(-)
>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Ok, I keep that in mind until all other issues are resolved.

Thanks,
   Sebastian

