Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3FDNn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:43:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10649 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3FDNnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:43:22 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=windows-1252
X-AuditID: cbfec7f4-b7fd76d0000035e1-76-51adeef89650
Message-id: <51ADEEF6.1030200@samsung.com>
Date: Tue, 04 Jun 2013 15:43:18 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@linaro.org, tony@atomide.com, balbi@ti.com, arnd@arndb.de,
        swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, rob.herring@calxeda.com, rob@landley.net,
        b-cousson@ti.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        benoit.cousson@linaro.org, mchehab@redhat.com,
        akpm@linux-foundation.org, cesarb@cesarb.net, davem@davemloft.net,
        rnayak@ti.com, shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v6 1/9] drivers: phy: add generic PHY framework
References: <1367229812-30574-1-git-send-email-kishon@ti.com>
 <1367229812-30574-2-git-send-email-kishon@ti.com>
 <51ADBF9B.5060403@samsung.com> <51ADDCD9.8080400@ti.com>
In-reply-to: <51ADDCD9.8080400@ti.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWyybYRjH8/Y79NOofDqHNy4sKlsyizpsiTfLDhIXvswu2NWy7KCrjmaK
	tcrshqW2ZeKwVEZbh6AlDqVLZ8HWKVUlscyhNIo4RBgjJJgIJlv1wu5+yfN/nv/v4qEw3nc8
	iJJkZItlGcJ0PsnBR06GpsIPttqTIls6fVG10UCiPyo7G+3PmjDUv5CPNDsuEmmdd1H1aCGO
	+qqWCNR33A2QUmck0dhKMYlMy04C1b/R48jxpZpEVfoyHDU0vcbQrIOLzIMDbGQp+chCq2Vm
	gAaa+1ioY70SRxulBgytdOgxNF1ZSCDL5O3YIKZQWUwyR4cqwOz/VuFM3e4km7HNqjGms8XF
	Yn61aQhmzmkmmWH1Ec5Yagxs5pM+nxlV1wOmRLlFMtu9UyQzNN3FYnZNwYn0fc71FHG6JEcs
	i7iZzEkztTqxLA39oubEBQrArncR8KIgfRVuOH6wPRwAx+aNZBHgUDy6EcCd8jXCPeDSvvCg
	fB4vAhSF0eehbeKZBwVwYTzMneDROwAuf873pMPgpraOdDNOX4C9I8MsN5N0FCwZLAVu9qcT
	oU7vqfX7lx/pOcDctRg9g0PXxObpwjk6DlrnfrI8PgYAuxzrp1e96ItweM9Ivge09j897Zme
	9kyvDmCtwF+sEGXJn6RKowRyoVSuyEgViDKlJuD5gL1uoLNfswKaAnxvbkinIYlHCHPkeVIr
	gBTG9+OGOtuTeNwUYd5LsSzzsUyRLpZbAYvyCioAkssh9fa9Gpvsnaohcv5eWdriqiTmYaAw
	ziZ5Gi8/fNBx49GV3ghyXOnz9ZWo8VixsXYnED3nyhLeqrajRdFD8eG2zMiK2OxJZU/uusin
	YtHo7Rwg7DFxLb5g8BJV9W3mVnBbe0Jyw4cmXUWtICA0j2hO17ASl4h+i7lWncvH5WnCqDBM
	Jhf+BQUZFQPfAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/04/2013 02:26 PM, Kishon Vijay Abraham I wrote:
>>> +static inline int phy_init(struct phy *phy)
>>> +{
>>> +	pm_runtime_get_sync(&phy->dev);
>>
>> Hmm, no need to check return value here ? Also it looks a bit unexpected to
> 
> I purposely dint check the return values in order to support platforms 
> that don’t enable pm_runtime.

Then I guess this should be called conditionally and any errors returned
if runtime PM is enabled ? Not sure if pm_runtime_enabled() would be
helpful such situation.

>> possibly have runtime_resume callback of a PHY device called before ops->init()
>> call ? It seems a bit unclear what the purpose of init() callback is.
> 
> Not really. Anything that is used to initialize the PHY (internal 
> configuration) can go in phy_init. Usually in runtime_resume callback, 
> optional functional clocks are enabled and also in some cases context 
> restore is done. So it really makes sense to enable clocks/module 
> (pm_runtime_get_sync) before doing a PHY configuration (phy_init).

OK, that makes sense. All PHY device resources must be prepared anyway
before a PHY object is registered with the PHY core.

>>> +	if (phy->ops->init)
>>> +		return phy->ops->init(phy);
>>> +
>>> +	return -EINVAL;
>>> +}
>>> +
>>> +static inline int phy_exit(struct phy *phy)
>>> +{
>>> +	int ret = -EINVAL;
>>> +
>>> +	if (phy->ops->exit)
>>> +		ret = phy->ops->exit(phy);
>>> +
>>> +	pm_runtime_put_sync(&phy->dev);
>>> +
>>> +	return ret;
>>> +}
>>
>> Do phy_init/phy_exit need to be mandatory ? What if there is really
> 
> No. phy_init/phy_exit is not mandatory at all.
>> nothing to do in those callbacks ? Perhaps -ENOIOCTLCMD should be
>> returned if a callback is not implemented, so PHY users can recognize
>> such situation and proceed ?
> 
> So currently these APIs return -EINVAL if these callbacks are not 
> populated which is good enough IMHO.

But -EINVAL could be well returned from the callback function. Perhaps
ENOTSUPP could be used instead ?


Thanks,
Sylwester
