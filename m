Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3DYFhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 01:37:20 -0400
Received: from intranet.asianux.com ([58.214.24.6]:54560 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3DYFhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 01:37:18 -0400
X-Spam-Score: -100.8
Message-ID: <5178C0DE.9070503@asianux.com>
Date: Thu, 25 Apr 2013 13:36:30 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
CC: Michael Neuling <mikey@neuling.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, sfr@canb.auug.org.au, matt@ozlabs.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: "attempt to move .org backwards" still show up
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com>
In-Reply-To: <5178ABA2.4030109@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月25日 12:05, Mike Qiu wrote:
>> I will try, and plan to get a result within this week (2013-04-28)
>>
>> Thanks.
> Hi
> This has block my work now
> So I hope you can take a look ASAP
> Thanks
> :)

The root cause is the room 0x500..0xc00 is not enough when
KVM_HANDLER_PR expresses the real codes. The relationship is
KVM_HANDLER_PR depend on CONFIG_KVM_BOOK3S_PR depend on
CONFIG_KVM_BOOK3S_64_PR.

If possible, we can by pass it: just use CONFIG_KVM_BOOK3S_64_HV instead
of CONFIG_KVM_BOOK3S_64_PR (enter menuconfig -> Virtualization -> "KVM
support for POWER7 and PPC970 using hypervisor mode in host").

For 'allmodconfig', it will use CONFIG_KVM_BOOK3S_64_HV instead of
CONFIG_KVM_BOOK3S_64_PR, so 'allmodconfig' will not have this issue.


Next, I will continue to analyse how to fix it.

Welcome other members (especially the related maintainers) to provide
suggestions and completions.

Thanks.

-- 
Chen Gang

Asianux Corporation
