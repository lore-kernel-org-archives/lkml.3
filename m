Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3JHJq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:46:57 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7131 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3JHJqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:46:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Oct 2013 02:42:45 -0700
Message-ID: <5253D489.7010900@nvidia.com>
Date: Tue, 8 Oct 2013 17:46:49 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: About [PATCH 1/2] regulator: core: Provide a dummy regulator
 with full constraints
References: <5253A17E.10503@nvidia.com> <20131008090910.GW21581@sirena.org.uk>
In-Reply-To: <20131008090910.GW21581@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 05:09 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Oct 08, 2013 at 02:09:02PM +0800, Wei Ni wrote:
> 
>> In the latest regulator framework, it default to provide dummy
>> regulators with full constraints by your patch "regulator: core: Provide
>> a dummy regulator with full constraints".
> 
>> I tried to use regulator_get() on lm90.c. If not set vcc-supply property
>> in the dts file to assume the regulator is physically present and
>> enabled, but it still can't get dummy regulator, just return -ENODEV.
>> I traced it, the regulator_dev_lookup() will return -ENODEV, and at that
>> time the has_full_constraints is still false, didn't be initialized in
>> regulator_init_complete() yet, so it will not return dummy regulator,
>> and will not return -EPROBE_DEFER either. This will cause the
>> lm90_probe() failed.
> 
>> Could you take a look ?
> 
> Could you take a look at why we're getting -ENODEV please - this
> indicates a problem with the device tree code since it should be what's
> requesting probe deferral when it sees a link is present.

In the regulator_dev_lookup(), it will try to read the "xx-supply" to
get the regnode, but I didn't set the vcc-supply in dts file for lm90,
so the of_get_regulator() will return NULL, then the
regulator_dev_lookup() will set the ret to -ENODEV, and return the rdev
as NULL.

Thanks.
Wei.

> 
> * Unknown Key
> * 0x7EA229BD
> 

