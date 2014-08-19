Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaHSGLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:11:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaHSGLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:11:49 -0400
Message-ID: <53F2EA9B.5010208@redhat.com>
Date: Tue, 19 Aug 2014 08:11:39 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com> <53F1D313.5010108@redhat.com> <20140819021741.GA2003@kernel>
In-Reply-To: <20140819021741.GA2003@kernel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2014 04:17, Wanpeng Li ha scritto:
>>> >> -		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
>>> >> +		if (level == 1 || ((level == 3 || level == 2)
>>> >> +				&& (spte & (1ULL << 7)))) {
>> >
>> >This condition can be simplified by checking the return value of ept_rsvd_mask.
>> >If it includes 0x38, this is a large page.

Oops, a "not" was missing. If it includes 0x38, this is _not_ a large
page (it is a page directory / page directory pointer / PML4).

>> Otherwise it is a leaf page and
>> you can go down the "if".
> As you know, 5:3 bits which used for EPT MT are not reserved bits, so 
> I fail to understand why check the return value of ept_rsvd_mask and 
> it's a large page if includes 0x38. Could you eplain in more details? ;-)

A non-leaf page will always have 0x38 in the ept_rsvd_mask.  A leaf page
will never have 0x38 in the ept_rsvd_mask.

Paolo
