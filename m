Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab3HVPif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 11:38:35 -0400
Received: from 20.mo3.mail-out.ovh.net ([178.33.47.94]:42058 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752372Ab3HVPie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 11:38:34 -0400
Message-ID: <52163076.2010501@overkiz.com>
Date: Thu, 22 Aug 2013 17:38:30 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "David S. Miller" <davem@davemloft.net>, Mark Brown <broonie@kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Grant Likely <grant.likely@secretlab.ca>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH] phylib: mdio: handle register/unregister/register
 sequence
References: <1377174836-10569-1-git-send-email-b.brezillon@overkiz.com> <20130822152757.GA23163@kroah.com>
In-Reply-To: <20130822152757.GA23163@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 3492260036265605238
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2013 17:27, Greg Kroah-Hartman wrote:
> On Thu, Aug 22, 2013 at 02:33:56PM +0200, Boris BREZILLON wrote:
>> Hello,
>>
>> This patch is a proposal to support the register/unregister/register
>> sequence on a given mdio bus.
>>
>> I use the register/unregister/register sequence to add a fallback when the
>> of_mdiobus_register (this function calls mdiobus_register with phy_mask
>> set to ~0) does not register any phy device (because the device tree does
>> not define any phy).
>> In this case I call mdiobus_unregister and then call mdiobus_register with
>> a phy_mask set to 0 to trigger a full mdio bus scan.
>>
>> I'm not sure this is the right way to do it (this is why I added RFC in the
>> subject).
>>
>> Could someone help me figuring out what I should use to implement my fallback ?
>>
>> 1) use the register/unregister/register sequence
> That will not work.  Well, you might think it would work, but then
> things randomly start breaking later on.  Try it with the
> KOBJECT_DELAYED_DESTROY build option in linux-next, and watch things go
> "boom" :)
>
> The rule is, you should never register a kobject/struct device that you
> have previously unregistered before, as you really don't know if
> unregistering has finished or not.

Thanks for your answer.

>
> sorry,
>
> greg k-h

