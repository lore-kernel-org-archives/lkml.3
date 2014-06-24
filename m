Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaFXINw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:13:52 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:37748 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaFXINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:13:49 -0400
Message-ID: <53A93304.9000604@nsn.com>
Date: Tue, 24 Jun 2014 10:12:52 +0200
From: Alexander Sverdlin <alexander.sverdlin@nsn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: ext Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Ioan Nicu <ioan.nicu.ext@nsn.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
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
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Subject: Re: [PATCH 5/6] OF: Utility helper functions for dynamic nodes
References: <1403430039-15085-1-git-send-email-pantelis.antoniou@konsulko.com> <1403430039-15085-6-git-send-email-pantelis.antoniou@konsulko.com> <53A85549.7040809@nsn.com> <6E91A461-4361-4A18-BE32-CECDD789C114@konsulko.com> <20140623183343.GA10389@heimdall> <78ACBAF6-A73E-4272-8D3A-258C4B10858C@konsulko.com>
In-Reply-To: <78ACBAF6-A73E-4272-8D3A-258C4B10858C@konsulko.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1507
X-purgate-ID: 151667::1403597574-00007A71-9D861A7B/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On 23/06/14 21:13, ext Pantelis Antoniou wrote:

[...]

>>> I don't know of any place in the kernel accessing the value if prop->length==0
>>>
>>
>> We have a simple use case. We have an overlay which adds an interrupt controller.
>> If you look in drivers/of/irq.c, in of_irq_parse_raw():
>>
>> [...]
>> 	/* Now start the actual "proper" walk of the interrupt tree */
>> 	while (ipar != NULL) {
>> 		/* Now check if cursor is an interrupt-controller and if it is
>> 		 * then we are done
>> 		 */
>> 		if (of_get_property(ipar, "interrupt-controller", NULL) !=
>> 				NULL) {
>> 			pr_debug(" -> got it !\n");
>> 			return 0;
>> 		}
>> [...]
>>
>> A node is identified as an interrupt controller if it has a zero-length property
>> called "interrupt-controller" but with a non-NULL value.
>>
>> My proposed fix for this was to remove the if () condition. propn->value will be
>> allocated with kmalloc(0) which returns ZERO_SIZE_PTR which is != NULL.
>>
> 
> If that's the case, the code in irq.c is wrong.
> 
> interrupt-controller is a bool property; the correct call to use is of_property_read_bool()
> which returns true or false when the value is defined.

No, it's not bool... It's an existence of a void property. 

> The use of of_get_property is a bug here. It is perfectly valid for a property to have a
> NULL value when length = 0.

of_find_property() would be really correct in this particular case...

-- 
Best regards,
Alexander Sverdlin.
