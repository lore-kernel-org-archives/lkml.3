Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaBXVLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:11:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52329 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaBXVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:11:33 -0500
Message-ID: <530BB571.8080509@ti.com>
Date: Mon, 24 Feb 2014 16:11:13 -0500
From: Tom Rini <trini@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] checkpatch.pl: Add warning for new __packed additions
References: <1393274296-26179-1-git-send-email-trini@ti.com> <1393275606.11020.59.camel@joe-AO722>
In-Reply-To: <1393275606.11020.59.camel@joe-AO722>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 04:00 PM, Joe Perches wrote:
> On Mon, 2014-02-24 at 15:38 -0500, Tom Rini wrote:
>> While there are valid reasons to use __packed, often the answer is that
>> you should be doing something else here instead.
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -4010,6 +4010,11 @@ sub process {
>>  			WARN("PREFER_PACKED",
>>  			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
>>  		}
>> +# Check for new packed usage, warn to use care
>> +		if ($line =~ /\b(__attribute__\s*\(\s*\(.*\bpacked|__packed)\b/) {
>> +			WARN("NEW_PACKED",
>> +			     "Adding new packed members is to be done with care\n" . $herecurr);
>> +		}
> 
> Hi Tom.
> 
> This might be too noisy as it will warn on any use of __packed,
> including existing ones if checking using -f/--file.

Well, in my mind this is like typedef and some other things that can be
warned on in existing files.  I did a quick and lazy git grep and got
~1100 files in v3.14-rc1 out of ~36000 files.

> (there are some odd, probably broken ones in drivers/char/tpm/tpm_acpi.c)
> 
> How often is this actually a problem?

I think the first line answers the second one, honestly.  If one wants
to get pedantic about things and really investigate there's probably
some unneeded usages scattered about, and that's generally the type of
thing one wants to address when checking whole files, right?

> It'll warn on any use of packed not just packed members.
> 
> This may be better as
> 	"Using 'packed' can impact performance\n"
> and only tested when not in --file mode.

I can also make this change, sure, just point me off-list for an example
to crib from and test?

-- 
Tom
