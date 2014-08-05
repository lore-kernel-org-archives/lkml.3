Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaHEErM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:47:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:50824 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbaHEErL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:47:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,802,1400050800"; 
   d="scan'208";a="580081221"
Date: Tue, 5 Aug 2014 12:48:11 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, freyes@suse.com
Subject: Re: [PATCH 1/2] KVM: nVMX: Fix nested vmexit ack intr before load
 vmcs01
Message-ID: <20140805044811.GA17143@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406880727-60001-1-git-send-email-wanpeng.li@linux.intel.com>
 <1407182196.2571.14.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407182196.2571.14.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,
On Mon, Aug 04, 2014 at 12:56:36PM -0700, Davidlohr Bueso wrote:
>On Fri, 2014-08-01 at 16:12 +0800, Wanpeng Li wrote:
>> External interrupt will cause L1 vmexit w/ reason external interrupt when L2 is 
>> running. Then L1 will pick up the interrupt through vmcs12 if L1 set the ack 
>> interrupt bit. Commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info
>> if L1 asks us to)
>
>So being that 77b0f5d is in 3.15, we need it for -stable.
>
>>  get intr that belongs to L1 before load vmcs01 which is wrong, 
>> especially this lead to the obvious L1 ack APICv behavior weired since APICv 
>> is for L1 instead of L2. This patch fix it by ack intr after load vmcs01.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>
>It strikes me that this fixes Felipe's issue:
>http://paste.opensuse.org/view/raw/78752586
>

Could you verify if the latest version also fix your issue? Your Tested-by
to the latest version is appreciated.

Regards,
Wanpeng Li 

>
>
