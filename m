Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417AbaBXVwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:52:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54995 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaBXVwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:52:36 -0500
Message-ID: <530BBF10.6050601@ti.com>
Date: Mon, 24 Feb 2014 16:52:16 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Josh Triplett <josh@joshtriplett.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com>  <1393275606.11020.59.camel@joe-AO722> <530BB571.8080509@ti.com> <1393277304.11020.64.camel@joe-AO722>
In-Reply-To: <1393277304.11020.64.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 04:28 PM, Joe Perches wrote:
> On Mon, 2014-02-24 at 16:11 -0500, Tom Rini wrote:
>> On 02/24/2014 04:00 PM, Joe Perches wrote:
>>> On Mon, 2014-02-24 at 15:38 -0500, Tom Rini wrote:
>>>> While there are valid reasons to use __packed, often the answer is that
>>>> you should be doing something else here instead.
> []
>>> How often is this actually a problem?
>>
>> I think the first line answers the second one, honestly.  If one wants
>> to get pedantic about things and really investigate there's probably
>> some unneeded usages scattered about, and that's generally the type of
>> thing one wants to address when checking whole files, right?
> 
> Maybe not.
> 
> That entirely depends on the correct and necessary uses of
> packed vs the incorrect usage rates.
> 
> I think almost all packed uses are correct and there might
> be a lot of patches submitted to remove them by over-zealous
> advocates of checkpatch -f.

To try and also answer Josh's feedback as well, I've been lead to
believe that most cases now people should be using regmap instead, which
just leaves the case of having to match on-disk formats or similar cases
I believe as the things that must stay __packed.

>>> This may be better as
>>> 	"Using 'packed' can impact performance\n"
>>> and only tested when not in --file mode.
>>
>> I can also make this change, sure, just point me off-list for an example
>> to crib from and test?
> 
> Look at the FSF mailing address test as an example:
> 
> 			my $msg_type = \&ERROR;
> 			$msg_type = \&CHK if ($file);
> 			&{$msg_type}("FSF_MAILING_ADDRESS",

OK, thanks, I'll make something happen, and drop it to a CHK too.

-- 
Tom
