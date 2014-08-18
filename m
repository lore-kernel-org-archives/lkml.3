Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaHRKwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:52:17 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:55423 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaHRKwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:52:15 -0400
Message-ID: <53F1DADA.1050603@linux.vnet.ibm.com>
Date: Mon, 18 Aug 2014 18:52:10 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081810-1396-0000-0000-0000001625E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 05:50 PM, Wanpeng Li wrote:
> EPT misconfig handler in kvm will check which reason lead to EPT 
> misconfiguration after vmexit. One of the reasons is that an EPT 
> paging-structure entry is configured with settings reserved for 
> future functionality. However, the handler can't identify if 
> paging-structure entry of reserved bits for 1-GByte page are 
> configured, since PDPTE which point to 1-GByte page will reserve 
> bits 29:12 instead of bits 7:3 which are reserved for PDPTE that 
> references an EPT Page Directory. This patch fix it by reserve 
> bits 29:12 for 1-GByte page. 

That mask is only set in the lowest pte for 4K page, i think it
is not a problem, no?

