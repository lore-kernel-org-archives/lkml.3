Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbaFIVuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:50:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37283 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaFIVuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:50:44 -0400
Message-ID: <53962C32.2040003@codeaurora.org>
Date: Mon, 09 Jun 2014 14:50:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: Check for missing NULL terminators in
 of_device_id tables
References: <1401213858-31950-1-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1406031208380.2036@localhost6.localdomain6> <538E09C1.30200@codeaurora.org> <alpine.DEB.2.02.1406032013150.2009@localhost6.localdomain6> <538E119D.8010304@codeaurora.org> <alpine.DEB.2.02.1406032022540.2009@localhost6.localdomain6> <53962B54.8030909@suse.cz>
In-Reply-To: <53962B54.8030909@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/14 14:47, Michal Marek wrote:
> Dne 3.6.2014 20:25, Julia Lawall napsal(a):
>> From: Stephen Boyd <sboyd@codeaurora.org>
>>
>> Failure to terminate an of_device_id table can lead to confusing
>> failures depending on where the compiler places the array. Add a
>> check to make sure these tables are terminated. Thanks to Mitchel
>> Humpherys for coming up with the pattern initially.
>>
>> Cc: Mitchel Humpherys <mitchelh@codeaurora.org>
>> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
>> Cc: Gilles Muller <Gilles.Muller@lip6.fr>
>> Cc: Nicolas Palix <nicolas.palix@imag.fr>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
>> Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>
>>
>> ---
>>
>> v3: Removed unneeded rule bad_of_table.  Placed * in context rule on the 
>> closing brace; putting it on the field caused all fields to be marked.
>>
>> v4: corrected authorship
>>
>>  scripts/coccinelle/misc/of_table.cocci |   62 +++++++++++++++++++++++++++++++++
>>  1 file changed, 62 insertions(+)
> Applied to kbuild.git#misc, thanks. BTW, what is so special about of
> device drivers? Shouldn't we check for missing sentinels in all kinds of
> device tables?
>

Yes the rule should probably be expanded to cover more tables. I guess
this is just more noticeable because a driver may match some device that
it isn't supposed to match and start writing random bits to registers it
shouldn't be, causing the system to hang.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

