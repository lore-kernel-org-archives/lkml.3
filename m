Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3FVNH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 09:07:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5889 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3FVNH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 09:07:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sat, 22 Jun 2013 06:05:20 -0700
Message-ID: <51C5A2BC.5060401@nvidia.com>
Date: Sat, 22 Jun 2013 18:42:28 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Stephen Warren <swarren@nvidia.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulator: palmas: model SMPS10 as two regulators
References: <1371717458-10307-1-git-send-email-kishon@ti.com> <1371717458-10307-3-git-send-email-kishon@ti.com> <51C2DEEB.9090600@nvidia.com> <51C3089F.5030003@ti.com> <51C30B95.4010406@nvidia.com> <51C30F60.3060100@ti.com> <51C31537.9030705@nvidia.com> <51C31F30.5000307@ti.com> <51C45448.4080201@nvidia.com> <51C45C7A.5000509@ti.com>
In-Reply-To: <51C45C7A.5000509@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 June 2013 07:30 PM, Kishon Vijay Abraham I wrote:
> On Friday 21 June 2013 06:55 PM, Laxman Dewangan wrote:
>> On Thursday 20 June 2013 08:56 PM, Kishon Vijay Abraham I wrote:
>>> Hi,
>>>
>>> On Thursday 20 June 2013 08:14 PM, Laxman Dewangan wrote:
>>>> Have you added the regulator supply entries?
>>>> Are you testing on mainline linux-next?
>>> Not in linux-next :-( Tested only with mainline.
>>> Does inverting the order helps?
>>>
>> I think because you do not have entry of supply in your dt node, it gets
>> ignored by regulator_dev_lookup() and continue.
>>
>> I made the entry like (added entry form smps10-out2-supply and smps10-in-supply
>> in dt node) and then it failed.
>> /***
>>
>> +                           smps10-out2-supply = <&palmas_smps10_out2_reg>;
>> +                           smps10-in-supply = <&tps65090_dcdc3_reg>;
>>                               ldo3-in-supply = <&palmas_smps3_reg>;
>> @@ -903,6 +905,20 @@
>>                                           regulator-always-on;
>>                                   };
>>
>> +                               palmas_smps10_out1_reg: smps10_out1 {
>> +                                       regulator-name = "smps10_out1";
>> +                                       regulator-min-microvolt = <5000000>;
>> +                                       regulator-max-microvolt = <5000000>;
>> +                                       regulator-always-on;
>> +                               };
>> +
>> +                               palmas_smps10_out2_reg: smps10_out2 {
>> +                                       regulator-name = "smps10_out2";
>> +                                       regulator-min-microvolt = <5000000>;
>> +                                       regulator-max-microvolt = <5000000>;
>> +                                       regulator-always-on;
>> +                               };
>> +
>> **/
>>
>>
>> After reversing the sequence, it worked fine.
> You mean, changing the order in dt node helped?

The sequence on DT does not matter. We register the regulators in the 
sequence it is having enums value for regulator-id in loop. So we need 
to revert there.

Yaah, it looks odd that SMPS10-OUT2come before SMPS10-OUT1 in enums 
definition.

