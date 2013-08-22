Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3HVN3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:29:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:35780 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3HVN3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:29:15 -0400
Message-ID: <52161245.3080404@arm.com>
Date: Thu, 22 Aug 2013 14:29:41 +0100
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
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v4 03/19] powerpc: refactor of_get_cpu_node to support
 other architectures
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>  <1376991021-12160-4-git-send-email-Sudeep.KarkadaNagesha@arm.com> <1377152143.25016.289.camel@pasglop>
In-Reply-To: <1377152143.25016.289.camel@pasglop>
X-OriginalArrivalTime: 22 Aug 2013 13:29:11.0164 (UTC) FILETIME=[962B73C0:01CE9F3B]
X-MC-Unique: 113082214291300501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/13 07:15, Benjamin Herrenschmidt wrote:
> On Tue, 2013-08-20 at 10:30 +0100, Sudeep KarkadaNagesha wrote:
>> From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
>>
>> Currently different drivers requiring to access cpu device node are
>> parsing the device tree themselves. Since the ordering in the DT need
>> not match the logical cpu ordering, the parsing logic needs to consider
>> that. However, this has resulted in lots of code duplication and in some
>> cases even incorrect logic.
>>
>> It's better to consolidate them by adding support for getting cpu
>> device node for a given logical cpu index in DT core library. However
>> logical to physical index mapping can be architecture specific.
>>
>> PowerPC has it's own implementation to get the cpu node for a given
>> logical index.
>>
>> This patch refactors the current implementation of of_get_cpu_node.
>> This in preparation to move the implementation to DT core library.
>> It separates out the logical to physical mapping so that a default
>> matching of the physical id to the logical cpu index can be added
>> when moved to common code. Architecture specific code can override it.
> 
> So the patch unfortunately collides with other changes in powerpc -next,
> though it's not a huge deal and not hard to fixup, but expect Linus
> to tick unless we sort it out some other way.
> 
> Appart from that, it's fine, builds on all my test configs and doesn't
> seem to negatively impact things as far as I can tell so far...
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 

Hi Ben,

Thanks a lot for testing and ACK.
I will check with Rafael about these (trivial) conflicts.

Regards,
Sudeep


