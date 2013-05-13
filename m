Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3EMQMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:12:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39718 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab3EMQMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:12:20 -0400
Message-ID: <519110DF.9070403@arm.com>
Date: Mon, 13 May 2013 17:12:15 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Landley <rob@landley.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Shawn Guo <shawn.guo@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/2] PM / OPP: add support to specify phandle of another
 node for OPP
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1367406679-21603-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <20130501144120.GA17385@kahuna>
In-Reply-To: <20130501144120.GA17385@kahuna>
X-MC-Unique: 113051317121801801
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi device-tree folks,

On 01/05/13 15:41, Nishanth Menon wrote:
> On 12:11-20130501, Sudeep.KarkadaNagesha@arm.com wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> If more than one similar devices share the same OPPs, currently we
>> need to replicate the OPP entries in all the nodes.
> Nice, thanks.
>>
>> Few drivers like cpufreq depend on physical cpu0 node to specify the
> cpufreq-cpu0?
>> OPPs and only that node is referred irrespective of the logical cpu
>> accessing it. Alternatively to support cpuhotplug path, few drivers
>> parse all the cpu nodes for OPPs. Instead we can specify the phandle
>> of the node with which the current node shares the operating points.
>>
>> This patch adds support to specify the phandle in the operating points
>> of any device node, where the node specified by the phandle holds the
>> actual OPPs.
>>
>> Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>> ---
>>  Documentation/devicetree/bindings/power/opp.txt |   41 +++++++++++++++++++++++
>>  drivers/base/power/opp.c                        |   30 ++++++++++++-----
>>  2 files changed, 63 insertions(+), 8 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/power/opp.txt b/Documentation/devicetree/bindings/power/opp.txt
>> index 74499e5..a659da4 100644
>> --- a/Documentation/devicetree/bindings/power/opp.txt
>> +++ b/Documentation/devicetree/bindings/power/opp.txt
>> @@ -23,3 +23,44 @@ cpu@0 {
>>              198000  850000
>>      >;
>>  };
>> +
> Definition of operating-points is now a little different in the
> original description - it still indicates tuple {freq,voltage}, where
> as, this patch allows phandle to a different device's operating-points
> to be used. - we might want to rephrase the description.
>
> btw, to device-tree folks, I am not sure if it is OK to have different formats
> for the same property like operating-points. At least I don't seem to
> quickly be able to find any precedence.
>
Any directions on this to proceed ? Is proposed option of phandle for
OPP acceptable ?

Regards,
Sudeep

-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

