Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbaKUQxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:53:50 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37932 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749AbaKUQxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <CC185E77-95F6-4E4B-B431-59C9A9775453@antoniou-consulting.com>
References: <1414572037-11306-1-git-send-email-pantelis.antoniou@konsulko.com>
 <20141029101420.GT18557@sirena.org.uk> <6A3753C0-251A-4645-AD96-CB1D6521175F@antoniou-consulting.com>
 <20141029122204.GG18557@sirena.org.uk> <20141121153329.C4DDDC40D85@trevor.secretlab.ca>
 <CC185E77-95F6-4E4B-B431-59C9A9775453@antoniou-consulting.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 21 Nov 2014 16:53:26 +0000
X-Google-Sender-Auth: bQi8icCF_mZr6lN9yjYn9pAAIc8
Message-ID: <CACxGe6uwjzYs73bOCpij-dFHfJBfjj7f6T-eRivs7EdQaShAbg@mail.gmail.com>
Subject: Re: [PATCH] of: spi: Export single device registration method and
 accessors (v2)
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Mark Brown <broonie@kernel.org>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 3:44 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> Hi Grant,
>
>> On Nov 21, 2014, at 17:33 , Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> On Wed, 29 Oct 2014 12:22:04 +0000
>> , Mark Brown <broonie@kernel.org>
>> wrote:
>>> On Wed, Oct 29, 2014 at 01:48:06PM +0200, Pantelis Antoniou wrote:
>>>>> On Oct 29, 2014, at 12:14 , Mark Brown <broonie@kernel.org> wrote:
>>>
>>>>> This feels like there is an abstraction problem somewhere, whatever code
>>>>> is supposed to use this is going to need to be taught about each
>>>>> individual bus which is going to be tedious, I would expect that we'd
>>>>> have something like the bus being able to provide a callback which will
>>>>> get invoked whenever a new node appears on the parent node for the bus.
>>>
>>>> Thereâ EURO (tm)s a whole patchset that does exactly this.
>>>> Look at "OF: spi: Add OF notifier handlerâ EURO  and youâ EURO (tm)ll where this is used.
>>>
>>> I deleted that unread I'm afraid; one of the reasons that you should use
>>> subject lines matching the styles for the subsystems is that it's one of
>>> the things people use to filter out things that actually need attention,
>>> if things are busy things that at first glance don't look terribly
>>> relevant (like changes to the OF core in this case) are likely to get
>>> looked at less urgently or just skipped.
>>>
>>> A quick glance suggests that this is adding code inside the SPI core so
>>> it's still not explaining why anything is being exported, can you
>>> clarify please?
>>
>> I have the same question. This doesn't look like it should be exporting
>> symbols.
>>
>> Also, the way the patch is written causes a lot of code changes to get
>> interleaved in the diff. It would be better to split into two patches;
>> one that creates the new of_register_spi_device(), and a separate patch
>> to add the other new functions. It would be certainly easier to review
>> that way.
>>
>
> The diff does make a mess of things; it's not that complex of a patch.
>
> Your wish shall be granted. I'll respin this over the weekend.

I've fixed it in my tree by moving the match functions into the second
patch. The diffs are much easier to read now. I'll post the new
versions to the list shortly, but if you can test that would be
fantastic.

g.

>
>>>
>>>>> SubmittingPatches says.  Please also try to keep your CC list sane,
>>>>> CCing random people just means that you're increasing the volume of mail
>>>>> they have to process.  I'm surprised kernel.org accepts so many CCs.
>>>
>>>>> I have to say I don't recall ever seeing v1...
>>>
>>>> All of them are in the CC list for a reason.
>>>
>>> This is a single, standalone SPI patch - you didn't send it as part of a
>>> series (which is the only reason I read it).
>>
>> Yes, this is part of the OF overlay series. It should have at least been
>> marked as [PATCH 7/8] and that it replaced the previous, buggy, patch 7.
>>
>> g.
>>
>
> Regards
>
> -- Pantelis
>
