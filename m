Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaANMCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:02:47 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:47704 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaANMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:02:45 -0500
Message-ID: <52D52761.1000303@codethink.co.uk>
Date: Tue, 14 Jan 2014 12:02:41 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@lists.codethink.co.uk, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] power: clock_ops.c: check return of clk_enable()
 in pm_clk_resume()
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk> <1389445540-21426-2-git-send-email-ben.dooks@codethink.co.uk> <1438385.ppqm7XWTt3@vostro.rjw.lan>
In-Reply-To: <1438385.ppqm7XWTt3@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/14 19:55, Rafael J. Wysocki wrote:
> On Saturday, January 11, 2014 01:05:39 PM Ben Dooks wrote:

>> @@ -262,8 +263,9 @@ int pm_clk_resume(struct device *dev)
>>
>>   	list_for_each_entry(ce, &psd->clock_list, node) {
>>   		if (ce->status < PCE_STATUS_ERROR) {
>> -			clk_enable(ce->clk);
>> -			ce->status = PCE_STATUS_ENABLED;
>> +			ret = clk_enable(ce->clk);
>> +			if (ret == 0)
>
> Can you please use if (!ret) here?
>
> And analogously in patch [3/3]?

I will fix and re-send today, thanks.


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
