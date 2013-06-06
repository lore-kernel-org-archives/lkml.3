Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3FFQRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:17:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34772 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3FFQRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:17:36 -0400
Message-ID: <51B0B61C.2000008@wwwdotorg.org>
Date: Thu, 06 Jun 2013 10:17:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Alex Courbot <acourbot@nvidia.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>, "gnurou@gmail.org" <gnurou@gmail.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] simplefb: add support for a8b8g8r8 pixel format
References: <1370503259-16618-1-git-send-email-acourbot@nvidia.com> <3356BC4D-EEF6-4FCA-9310-5B0727EBF288@jcrosoft.com> <51B0446A.4090305@nvidia.com> <29610936-BB03-4844-888B-56E1C8E5DF4A@jcrosoft.com> <51B047FD.4020400@nvidia.com> <20130606145059.GU19468@game.jcrosoft.org>
In-Reply-To: <20130606145059.GU19468@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 08:50 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 17:27 Thu 06 Jun     , Alex Courbot wrote:
>> On 06/06/2013 05:24 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>
>>> On Jun 6, 2013, at 10:12 AM, Alex Courbot <acourbot@nvidia.com> wrote:
>>>
>>>> On 06/06/2013 04:59 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
>>>>>
>>>>> On Jun 6, 2013, at 9:20 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
...
>>>>>> static struct simplefb_format simplefb_formats[] = {
>>>>>> 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
>>>>>> +	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {31, 8} },
>>>>>
>>>>> why don't you parse the string?

Jean-Christophe, I'm afraid I can't tell exactly what you're arguing for.

Here, you want code added to parse the string ...

This has already been rejected as being over-engineered, and more than
this simple driver needs. Even if it were shared code, the only
practical use of such a parsing function would be to support this
driver, since presumably any other HW-specific driver already knows
exactly which format the FB is in, and hence wouldn't need to share this
code.

>>>>> so you will a real generic bindings
>>>>
>>>> Tried that already, got NACKed: https://lkml.org/lkml/2013/5/27/330
>>>>
>>>> The list of modes of this driver should not grow too big. Even in terms of footprint I'd say the list should remain smaller than the parsing code.
>>>>
>>>> What we can discuss though is whether we want to keep this a8b8g8r8 syntax or switch to something more standard, say "rgba8888".
>>>
>>> I'm going to be very honest I do not like the simplefb driver from the beginning
>>> but I do found it useful. And as said in it's name it need to be *SIMPLE*
>>>
>>> Then a huge list of compatible no way
>>> otherwise we drop this from the simplefb and make it a generic helper
>>>
>>> I do not want to see format parser in every drivers this need to handle at video framework level

... yet here you appear to be arguing against using a format parser, or
including a format parser ...

Note that a lookup table isn't any kind of shared parser; it's just a
very tiny and simple table of static data. It seems quite unlikely that
this could be a maintenance issue, even if over time a few more entries
get added to the table.

>>> If I see that we start to increase again and again the simplefb I will not accept
>>> to merge the code as we must keep it simple
>>
>> In that case it's probably better to maintain a "simple" list of
>> supported modes, which is what this patch does.
> 
> so get out it of the simplefb other drivers can use it

... yet here you appear to want to move the list of modes into some
central location ...

I don't think that's useful for the reason I mentioned above: presumably
any other HW-specific driver already knows exactly which format the FB
is in, and hence wouldn't need to share this code/table.

Why don't we simply take this patch to extend this table, and then *if*
any other FB driver needs to parse a format from DT, we can move the
code(table) to a common location at that time. That will be a trivial
change, and one this patch does nothing to make any harder. Making the
code/table common before then seems like over-engineering.
