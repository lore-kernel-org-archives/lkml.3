Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3KESPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 13:15:21 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:44110 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753955Ab3KESPR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 13:15:17 -0500
Subject: Re: [PATCH 3/5] OF: export of_property_notify
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20131105181246.GK7028@beef>
Date: Tue, 5 Nov 2013 20:15:05 +0200
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AD1BC6B6-1DD1-47CC-BBE1-F5C258CD4E63@antoniou-consulting.com>
References: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com> <1383673816-29293-4-git-send-email-panto@antoniou-consulting.com> <20131105181246.GK7028@beef>
To: Matt Porter <matt.porter@linaro.org>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Nov 5, 2013, at 8:12 PM, Matt Porter wrote:

> On Tue, Nov 05, 2013 at 07:50:14PM +0200, Pantelis Antoniou wrote:
>> of_property_notify can be utilized by other users too, export it.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> drivers/of/base.c  |  8 +-------
>> include/linux/of.h | 11 +++++++++++
>> 2 files changed, 12 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/of/base.c b/drivers/of/base.c
>> index ca10916..0ffc5a9 100644
>> --- a/drivers/of/base.c
>> +++ b/drivers/of/base.c
>> @@ -1424,7 +1424,7 @@ int of_count_phandle_with_args(const struct device_node *np, const char *list_na
>> EXPORT_SYMBOL(of_count_phandle_with_args);
>> 
>> #if defined(CONFIG_OF_DYNAMIC)
>> -static int of_property_notify(int action, struct device_node *np,
>> +int of_property_notify(int action, struct device_node *np,
>> 			      struct property *prop)
>> {
>> 	struct of_prop_reconfig pr;
>> @@ -1433,12 +1433,6 @@ static int of_property_notify(int action, struct device_node *np,
>> 	pr.prop = prop;
>> 	return of_reconfig_notify(action, &pr);
>> }
>> -#else
>> -static int of_property_notify(int action, struct device_node *np,
>> -			      struct property *prop)
>> -{
>> -	return 0;
>> -}
>> #endif
> 
> EXPORT_SYMBOL[_GPL]?
> 

Duh, good catch.

Will fix on next revision.

> -Matt

Regards

-- Pantelis

