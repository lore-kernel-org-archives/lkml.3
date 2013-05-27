Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab3E0CUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:20:25 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38323 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0CUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:20:23 -0400
Message-ID: <51A2C2DC.6080403@linux.vnet.ibm.com>
Date: Mon, 27 May 2013 10:20:12 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130524203432.GB4525@amt.cnet>
In-Reply-To: <20130524203432.GB4525@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052702-9264-0000-0000-000003D22C05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 04:34 AM, Marcelo Tosatti wrote:
> On Thu, May 23, 2013 at 03:55:53AM +0800, Xiao Guangrong wrote:
>> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
>> caused by requiring lock
>>
>> After the patch, kvm_zap_obsolete_pages can forward progress anyway,
>> so update the comments
>>
>> [ It improves kernel building 0.6% ~ 1% ]
> 
> Can you please describe the overload in more detail? Under what scenario
> is kernel building improved?

Yes.

The scenario is we do kernel building, meanwhile, repeatedly read PCI rom
every one second.

[
   echo 1 > /sys/bus/pci/devices/0000\:00\:03.0/rom
   cat /sys/bus/pci/devices/0000\:00\:03.0/rom > /dev/null
]

