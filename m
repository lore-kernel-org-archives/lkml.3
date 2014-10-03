Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbaJCXXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:23:36 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:46709 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJCXXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:23:30 -0400
Message-ID: <542F2FE3.60507@roeck-us.net>
Date: Fri, 03 Oct 2014 16:23:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "atull@opensource.altera.com" <atull@opensource.altera.com>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "delicious.quinoa@gmail.com" <delicious.quinoa@gmail.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com> <1412275071-6417-2-git-send-email-atull@opensource.altera.com> <20141003122736.GH26643@leverpostej> <542EDCDB.6040406@roeck-us.net> <20141003231334.GA4609@sirena.org.uk>
In-Reply-To: <20141003231334.GA4609@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.542F2FF1.0019,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 04:13 PM, Mark Brown wrote:
> On Fri, Oct 03, 2014 at 10:28:59AM -0700, Guenter Roeck wrote:
>> On 10/03/2014 05:27 AM, Mark Rutland wrote:
>
>>>> +Optional properties:
>>>> + Name of the optional regulator subnode must be "regulators".
>>>> +  - #address-cells must be 1.
>
>>> What's the single address cell used for?
>
>> I think this is required by the regulator bindings.
>> Other regulators use the same, though they don't typically
>> mention it in the properties list but only in the examples.
>
> Nope, nothing to do with regulator that I'm aware of and I've not seen
> any examples (but I don't tend to review users too often).
>

Many examples, really. Just picking one.

Documentation/devicetree/bindings/mfd/tps6507x.txt

	regulators {
                 #address-cells = <1>;
                 #size-cells = <0>;
		...

This also uses the reg property for the regulator index
(without explaining it further). Seems to be pretty common.

Guenter

>>> Mark, what's the preferred scheme for identifying regulators in a
>>> container node?
>
>>>> +  - regulator-name: arbitrary name for regulator
>
>>> Drop the 'aribtarary'. Either this should be the name of the regulator
>>> on the board, or it shouldn't be necessary.
>
>> Not sure if it even needs to be documented here. It is already documented
>> in Documentation/devicetree/bindings/regulator/regulator.txt.
>
> Document by reference then?  It really should be the name of the supply
> provided by the regulator, that wording is probably good.  Given that
> it's a standard regulator property I'd not document it here at all, just
> refer to the generic bindings and say any suitable properties there can
> be used.
>

