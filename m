Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966390Ab3HHU2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:28:00 -0400
Received: from mail-bn1lp0150.outbound.protection.outlook.com ([207.46.163.150]:31134
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753130Ab3HHU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:27:58 -0400
Message-ID: <5203FF48.7000903@caviumnetworks.com>
Date: Thu, 8 Aug 2013 13:27:52 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>
CC: David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] smp.c: Quit unconditionally enabling irqs in on_each_cpu_mask().
References: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com> <000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com>
In-Reply-To: <000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 093290AD39
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(51704005)(24454002)(189002)(199002)(479174003)(377454003)(79102001)(56816003)(59896001)(81686001)(46102001)(53416003)(77982001)(74876001)(23756003)(59766001)(69226001)(83072001)(51856001)(50986001)(50466002)(47976001)(76796001)(47736001)(49866001)(76786001)(80316001)(4396001)(64126003)(54316002)(16406001)(74706001)(47776003)(63696002)(66066001)(65956001)(33656001)(53806001)(36756003)(74502001)(56776001)(31966008)(77096001)(47446002)(74366001)(74662001)(81342001)(83322001)(81542001)(54356001)(80022001)(65806001)(76482001)(80976001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB113;H:BLUPRD0712HT004.namprd07.prod.outlook.com;CLIP:64.2.3.195;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:25 PM, Christoph Lameter wrote:
> On Thu, 8 Aug 2013, David Daney wrote:
>
>> I don't know of any bugs currently caused by this unconditional
>> local_irq_enable(), but I want to use this function in MIPS/OCTEON
>> early boot (when we have early_boot_irqs_disabled).  This also makes
>> this function have similar semantics to on_each_cpu() which is good in
>> itself.
>
> smp_call_function_many() wants interrupts enabled.

That's what the comments say, but it isn't actually true.

The usage introduced by the patch is no different than the existing 
usage in on_each_cpu() 30 line up in the file.

David Daney


