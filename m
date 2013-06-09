Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3FIJGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 05:06:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:35957 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3FIJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 05:06:36 -0400
Message-ID: <51B44590.7030009@linux.vnet.ibm.com>
Date: Sun, 09 Jun 2013 17:06:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 00/11] KVM: MMU: fast zap all shadow pages
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130609085342.GI4725@redhat.com>
In-Reply-To: <20130609085342.GI4725@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060908-9574-0000-0000-00000837808F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2013 04:53 PM, Gleb Natapov wrote:
> On Fri, May 31, 2013 at 08:36:19AM +0800, Xiao Guangrong wrote:
>> Hi Gleb, Paolo, Marcelo,
>>
>> I have putted the potential controversial patches to the latter that are
>> patch 8 ~ 10, patch 11 depends on patch 9. Other patches are fully reviewed,
>> I think its are ready for being merged. If not luck enough, further discussion
>> is needed, could you please apply that patches first? :)
>>
>> Thank you in advance!
>>
>> Some points are raised during discussion but missed in this version:
>> 1) Gleb's idea that skip obsolete pages in the hast list walker
>>
>>    Unfortunately, it is not safe. There has a window between updating
>>    valid-gen and reloading mmu, in that window, the obsolete page can
>>    be used by vcpu, but the guest page table fail to be write-protected
>>    (since the obsolete page is skipped in mmu_need_write_protect()).
>>
> Can you elaborate on how this can happen. valid_gen is updated under
> mmu_lock and reloading of mmus happens under the same lock, so for all
> other vcpus this should look like atomic thing.

You're right.

Actually, i made another optimization patch in this version that moves
kvm_reload_remote_mmus() out of mmu-lock, but did not attach it into this
series. It seems my brain is not parallel-able enough. :(

