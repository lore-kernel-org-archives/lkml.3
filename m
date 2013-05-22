Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3EVKNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:13:30 -0400
Received: from multi.imgtec.com ([194.200.65.239]:49448 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab3EVKN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:13:26 -0400
Message-ID: <519C9A3D.1010902@imgtec.com>
Date: Wed, 22 May 2013 11:13:17 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/5] clk: add support for clock reparent on set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-4-git-send-email-james.hogan@imgtec.com> <519B01DF.1080700@codeaurora.org>
In-Reply-To: <519B01DF.1080700@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_22_11_13_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/13 06:10, Saravana Kannan wrote:
> On 05/20/2013 06:28 AM, James Hogan wrote:
>> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
>> index dd7adff..8138c94 100644
>> --- a/include/linux/clk-private.h
>> +++ b/include/linux/clk-private.h
>> @@ -33,8 +33,11 @@ struct clk {
>>       const char        **parent_names;
>>       struct clk        **parents;
>>       u8            num_parents;
>> +    u8            new_parent_index;
> 
> Why do you need this? Given the new_parent, can't the specific clock
> implementation just look it up when set_rate() is called? Wouldn't that
> be the only time you would actually need the index?
>
> If it's just for optimization of some error cases, I think we should
> drop this to keep the code simpler. One less state to keep track of when
> reading, writing or reviewing the clock framework.

clk_change_rate cannot currently return an error condition so I had
assumed it was better to check that the requested parent clock has a
valid parent index prior to starting to change any clock rates or firing
off any notifications.

Cheers
James

