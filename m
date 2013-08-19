Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225Ab3HSKNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 06:13:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:32772 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3HSKNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 06:13:12 -0400
Message-ID: <5211EFC7.9090800@arm.com>
Date: Mon, 19 Aug 2013 11:13:27 +0100
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
Subject: Re: [RFC PATCH v2 3/4] powerpc: refactor of_get_cpu_node to support
 other architectures
References: <1376586580-5409-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376674791-28244-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376674791-28244-2-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1376691186.25016.4.camel@pasglop>
In-Reply-To: <1376691186.25016.4.camel@pasglop>
X-OriginalArrivalTime: 19 Aug 2013 10:13:08.0379 (UTC) FILETIME=[B3C3A6B0:01CE9CC4]
X-MC-Unique: 113081911131001901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/08/13 23:13, Benjamin Herrenschmidt wrote:
> On Fri, 2013-08-16 at 18:39 +0100, Sudeep KarkadaNagesha wrote:
>> +static bool __of_find_n_match_cpu_property(struct device_node *cpun,
>> +                       const char *prop_name, int cpu, unsigned int
>> *thread)
>> +{
>> +       const __be32 *cell;
>> +       int ac, prop_len, tid;
>> +       u64 hwid;
>> +
>> +       ac = of_n_addr_cells(cpun);
>> +       cell = of_get_property(cpun, prop_name, &prop_len);
>> +       if (!cell)
>> +               return false;
>> +       prop_len /= sizeof(*cell);
>> +       for (tid = 0; tid < prop_len; tid++) {
>> +               hwid = of_read_number(cell, ac);
>> +               if (arch_match_cpu_phys_id(cpu, hwid)) {
>> +                       if (thread)
>> +                               *thread = tid;
>> +                       return true;
>> +               }
>> +               cell += ac;
>> +       }
>> +       return false;
>> +}
> 
> The only problem I can see here is if "ac" is not 1, that will not work
> for the ibm,ppc-interrupt-server#s case. IE. The latter is always 1 cell
> per entry, only "reg" depends on #address-cells.
> 
> However that's only a theorical problem since on ppc #address-cells of
> /cpus is always 1...
> 
Ok agreed, but I assume in future if thread ids need 2 ac, it would use
standard 'reg' instead of 'ibm,ppc-interrupt-server#' property.

So I assume the above function is generic and need not be modified to
handle non '1' ac case  with non standard 'ibm,ppc-interrupt-server#'.

Regards,
Sudeep

