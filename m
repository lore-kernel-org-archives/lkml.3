Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3GJPQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:16:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36245 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3GJPQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:16:16 -0400
Message-ID: <51DD7ABC.2010009@wwwdotorg.org>
Date: Wed, 10 Jul 2013 09:16:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com> <51DD03C8.1090207@nvidia.com>
In-Reply-To: <51DD03C8.1090207@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 12:48 AM, Wei Ni wrote:
> On 07/09/2013 10:00 PM, Eduardo Valentin wrote:
>> In order to be able to build thermal policies
>> based on generic sensors, like I2C device, that
>> can be places in different points on different boards,
>> there is a need to have a way to feed board dependent
>> data into the thermal framework.
>>
>> This patch introduces a thermal data parser for device
>> tree. The parsed data is used to build thermal zones
>> and thermal binding parameters. The output data
>> can then be used to deploy thermal policies.
>>
>> This patch adds also documentation regarding this
>> API and how to define define tree nodes to use
>> this infrastructure.
> 
> It looks good, with this infrastructure, we can add generic sensor
> driver into the thermal fw easily.
> 
> 
>> +
>> +Below is an example:
>> +thermal_zone {
>> +            type = "CPU";
>> +            mask = <0x03>; /* trips writability */
>> +            passive_delay = <250>; /* milliseconds */
>> +            polling_delay = <1000>; /* milliseconds */
>> +            governor = "step_wise";
>> +            trips {
>> +                    alert@100000{
>> +                            temperature = <100000>; /* milliCelsius */
>> +                            hysteresis = <0>; /* milliCelsius */
>> +                            type = <1>;
> 
> how about to use the trip type name directly, such as named as
> "passive-trip;", I think it's more readable. for example:
> trip0 {
> ....
> passive-trip;
> }
> trip1 {
> ....
> active-trip;
> }

You can always use the C pre-processor in DT now to define named constants:

include/dt-bindings/..../....h

	#define THERMAL_PASSIVE_TRIP 0
	#define THERMAL_ACTIVE_TRIP 1

*.dts:

	type = <THERMAL_PASSIVE_TRIP>;

Having a single 'property = value;' rather than n different Boolean
property names seems better, irrespective of whether value is an integer
or string; parsing and error-checking will be simpler.
