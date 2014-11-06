Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaKFMqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:46:39 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:51651 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:46:36 -0500
MIME-Version: 1.0
In-Reply-To: <E0B33C12-EBD6-465C-813C-7FD8553A3CB8@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1414528433-9650-5-git-send-email-pantelis.antoniou@konsulko.com>
 <20141105200129.B4438C41C40@trevor.secretlab.ca> <E0B33C12-EBD6-465C-813C-7FD8553A3CB8@konsulko.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 6 Nov 2014 12:46:15 +0000
X-Google-Sender-Auth: Rr386xwgNM0-OjnoOJtqJBV07rM
Message-ID: <CACxGe6tvRJP3J=7ccmH-CtjwSaZVx23KnkcMb6zgzG-pOkanXA@mail.gmail.com>
Subject: Re: [PATCH 4/5] of: Add old prop argument on OF_RECONFIG_UPDATE_PROPERTY
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 8:08 PM, Pantelis Antoniou
<pantelis.antoniou@konsulko.com> wrote:
> Hi Grant,
>
>> On Nov 5, 2014, at 22:01 , Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> On Tue, 28 Oct 2014 22:33:52 +0200
>> , Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> wrote:
>>> The notifier now includes the old_prop argument when updating
>>> properties, propagate this API to changeset internals while
>>> also retaining the old behaviour of retrieving the old_property
>>> when NULL is passed.
>>>
>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>
>> I'm still fuzzy on the need for this patch. Is this just an optimization
>> so that the property doesn't get looked up twice? Or is there a reason
>> when the oldprop really needs to be passed in explicitly?
>>
>
> In the case of overlay's applying a property change the old property has
> been already retrieved. Passing it as an argument saves us a traversal of the
> property list.
>
> On the original series were removal was supported, the old property was required
> since you can't find the old property anymore on the node (it was on another list).
>
> When we go back to revisit the removal case, that API is useful.

Since we're not doing removal anymore, lets drop this patch.

g.
