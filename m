Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaCEN6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 08:58:14 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:58481 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbaCEN6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 08:58:12 -0500
Message-ID: <53172D6A.9050900@epfl.ch>
Date: Wed, 05 Mar 2014 14:58:02 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] checkpatch: fix spurious vendor compatible warnings
References: <1393604742-14317-1-git-send-email-florian.vaussard@epfl.ch>	 <1393604742-14317-3-git-send-email-florian.vaussard@epfl.ch>	 <1393621571.10280.49.camel@joe-AO722> <53145D21.4080101@epfl.ch> <1393869097.13719.88.camel@joe-AO722>
In-Reply-To: <1393869097.13719.88.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/03/2014 06:51 PM, Joe Perches wrote:
> On Mon, 2014-03-03 at 11:44 +0100, Florian Vaussard wrote:
>> Looking at the current documentation, the list of these generic
>> placeholders is pretty short:
>>
>> $ git grep ',<.*>-' Documentation/devicetree/bindings/ | \
>>   grep -P -o ',<.*?>-' | grep -P -o '<.*>' | sort | uniq
>>
>> <board>
>> <chip>
>> <chip name>
>> <mcu-chip>
>> <processor>
>> <soc>
>> <SOC>
>> <soc-family>
>>
>> so '[a-zA-Z0-9-]+' seems more reasonable indeed.
> 
> The <mcu-chip> use seems as if it's 2 wildcards
> 
> 	fsl,<mcu-chip>-<board>
> 
> I'm not sure that could work with the current
> checkpatch code.
> 

I don't think it is desirable to make it work with the current
checkpatch code, as it is not enough constrained. For example, it allows
any compatible "fsl,foo-bar" to match, which opens the door for abuse.
We should have at least one fixed pattern.

> There's a space in "<chip name>" that should
> probably be replaced by "<chip-name>" or just
> "<chip>" for consistency.
> 

Sure, some cleaning could be necessary. I will see what I can do.

>> $compat2 =~ s/\,[a-zA-Z0-9]*\-/<\.\*>\-/g;
> 
> hand-escaped, not necessary if using "\Q$compat2\E"
> 

I wasn't aware of this, thanks.

> Anyway, if either you or Rob think it appropriate to
> submit a patch for either of the things I mentioned
> in the first place:
> 
>> o Look for ".compatible = "foo" strings in .c and .h files
>> o Improve the vendor name match in vendor-prefix.txt by only
>>   matching the exact vendor name at the beginning of lines.
> 
> or any of the stuff above here, please do.
> 

As you already sent a patch for these, I will include it in the v3 of
this series.

I see another problem: with the current regexp patterns, we have
enforced the use of a limited character set. But if one uses an exotic
character (even a simple space ' '), no warning will be produced at all.
We may check that we have at least one matching test, and throw a
warning otherwise. But this opens the question of enforcing the
characters used in compatible strings, where there is no strict
guideline AFAIK.

Regards,
Florian
