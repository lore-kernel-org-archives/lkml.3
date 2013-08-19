Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab3HSKVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:21:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48339 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3HSKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:21:23 -0400
Message-ID: <5211F1B3.4080206@arm.com>
Date: Mon, 19 Aug 2013 11:21:39 +0100
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [RFC PATCH v2 4/4] of: move of_get_cpu_node implementation to
 DT core library
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376674791-28244-3-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376691273.25016.5.camel@pasglop>
In-Reply-To: <1376691273.25016.5.camel@pasglop>
X-OriginalArrivalTime: 19 Aug 2013 10:21:20.0610 (UTC) FILETIME=[D9282420:01CE9CC5]
X-MC-Unique: 113081911212102001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 23:14, Benjamin Herrenschmidt wrote:
> On Fri, 2013-08-16 at 18:39 +0100, Sudeep KarkadaNagesha wrote:
>> +#ifdef CONFIG_PPC
>> +               /* Check for historical "ibm,ppc-interrupt-server#s" property
>> +                * for thread ids on PowerPC. If it doesn't exist fallback to
>> +                * standard "reg" property.
>> +                */
>> +               if (__of_find_n_match_cpu_property(cpun,
>> +                               "ibm,ppc-interrupt-server#s", cpu, thread))
>> +                       return cpun;
>> +#endif
> 
> It's not "historical". It's still very much in use and well defined in PAPR :-)
> 
By historical, I meant it should not be used in future bindings.

Ah, sorry missed it in ePAPR, because its not under CPU node section.
What's more interesting is that ePAPR has it as an example for
non-standard property names :)

Can I mark it as custom/non-standard instead ? I mainly want to indicate
that we need to use 'reg' property and not introduce any more custom
properties for thread ids.

Can I add your ACK with this comment fixed ?

Regards,
Sudeep

