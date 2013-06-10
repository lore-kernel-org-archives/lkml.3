Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3FJJ2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:28:53 -0400
Received: from 18.mo1.mail-out.ovh.net ([46.105.35.72]:57451 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090Ab3FJJ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:28:51 -0400
Message-ID: <51B59C43.2020708@overkiz.com>
Date: Mon, 10 Jun 2013 11:28:35 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Boris BREZILLON <linux-arm@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 28/50] ASoC: atmel-ssc: prepare clk before calling
 enable
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com> <1370622370-19614-1-git-send-email-b.brezillon@overkiz.com> <20130607165510.GA31367@sirena.org.uk> <51B23B04.20604@overkiz.com> <20130610090649.GC31367@sirena.org.uk>
In-Reply-To: <20130610090649.GC31367@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 11230570096205134054
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 11:06, Mark Brown wrote:
> On Fri, Jun 07, 2013 at 09:56:52PM +0200, Boris BREZILLON wrote:
>> On 07/06/2013 18:55, Mark Brown wrote:
>>> On Fri, Jun 07, 2013 at 06:26:09PM +0200, Boris BREZILLON wrote:
>>>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>>>> avoid common clk framework warnings.
>>> Applied since I happened to notice this on he list but you should
>>> *always* CC maintainers on patches otherwise they're likely to get
>>> missed.
>> I used get_mainainer script and it returns:
>> Arnd Bergmann <arnd@arndb.de> (supporter:CHAR and MISC DRI...)
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (supporter:CHAR and
>> MISC DRI...)
>> linux-kernel@vger.kernel.org (open list)
>> Please tell me if misuse this script or if I should use something else.
> I suspect you only ran this on some of the patches as that's missing
> pretty much all of the subsystem maintainers, but in general you always
> have to think about the output of get_maintainer.pl - it isn't terribly
> reliable.
I use a script to add "cc" and "to" fields to each patch:

to.sh:

#!/bin/bash

opts="--nogit --nogit-fallback --norolestats --pattern-depth=1"

if [[ $(basename $1) =~ ^0000- ]] ; then
     ./scripts/get_maintainer.pl --nom $opts $(dirname $1)/*
else
     maint=$(./scripts/get_maintainer.pl --nol $opts $1)

     if [ "$maint" == "" ] ; then
         echo "[hidden email]"
     else
         echo "$maint"
     fi
fi

cc.sh:

#!/bin/bash

opts="--nogit --nogit-fallback --norolestats"

if [[ $(basename $1) =~ ^0000- ]] ; then
     ./scripts/get_maintainer.pl --nom $opts $(dirname $1)/*
else
     ./scripts/get_maintainer.pl $opts $1
fi

But I guess it does not handle subsystem maintainers.

I'll check it before sending patch series next time.

BTW thanks for applying this patch.

Best Regards,
Boris
