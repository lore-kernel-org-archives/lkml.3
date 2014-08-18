Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaHRLSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:18:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:46983 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbaHRLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:18:41 -0400
Message-ID: <53F1E10D.7060007@redhat.com>
Date: Mon, 18 Aug 2014 13:18:37 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <53F1DADA.1050603@linux.vnet.ibm.com>
In-Reply-To: <53F1DADA.1050603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/08/2014 12:52, Xiao Guangrong ha scritto:
>> > EPT misconfig handler in kvm will check which reason lead to EPT 
>> > misconfiguration after vmexit. One of the reasons is that an EPT 
>> > paging-structure entry is configured with settings reserved for 
>> > future functionality. However, the handler can't identify if 
>> > paging-structure entry of reserved bits for 1-GByte page are 
>> > configured, since PDPTE which point to 1-GByte page will reserve 
>> > bits 29:12 instead of bits 7:3 which are reserved for PDPTE that 
>> > references an EPT Page Directory. This patch fix it by reserve 
>> > bits 29:12 for 1-GByte page. 
> That mask is only set in the lowest pte for 4K page, i think it
> is not a problem, no?

It will cause KVM to WARN.  The EPT memory type will also be ignored for
gigabyte pages.

Paolo
