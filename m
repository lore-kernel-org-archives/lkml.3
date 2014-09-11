Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaIKNF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:05:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaIKNFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:05:22 -0400
Message-ID: <54119E01.9000908@redhat.com>
Date: Thu, 11 Sep 2014 15:05:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <20140911101200.GF25317@minantech.com> <54117DB4.307@redhat.com> <20140911113051.GG25317@minantech.com>
In-Reply-To: <20140911113051.GG25317@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 13:30, Gleb Natapov ha scritto:
>> > +			vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
>> > +			/*
>> > +			 * Do not pin apic access page in memory so that memory
>> > +			 * hotplug process is able to migrate it.
>> > +			 */
>> > +			put_page(page);
>> >  		}
> This code is in prepare_vmcs02() and is executed during L1->L2 vmentry. What happens
> when apic access page is migrated while L2 is running? It needs to be update somewhere.

Before it is migrated, the MMU notifier is called and will force a
vmexit on all CPUs.  The reload code will call GUP again on the page
again and swap it in.

Paolo

