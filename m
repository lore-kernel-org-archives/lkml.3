Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab3E1NZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934075Ab3E1NYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:24:47 -0400
Date: Mon, 27 May 2013 21:18:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v7 04/11] KVM: MMU: zap pages in batch
Message-ID: <20130528001802.GB1359@amt.cnet>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1369252560-11611-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130524203432.GB4525@amt.cnet>
 <51A2C2DC.6080403@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A2C2DC.6080403@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 10:20:12AM +0800, Xiao Guangrong wrote:
> On 05/25/2013 04:34 AM, Marcelo Tosatti wrote:
> > On Thu, May 23, 2013 at 03:55:53AM +0800, Xiao Guangrong wrote:
> >> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
> >> caused by requiring lock
> >>
> >> After the patch, kvm_zap_obsolete_pages can forward progress anyway,
> >> so update the comments
> >>
> >> [ It improves kernel building 0.6% ~ 1% ]
> > 
> > Can you please describe the overload in more detail? Under what scenario
> > is kernel building improved?
> 
> Yes.
> 
> The scenario is we do kernel building, meanwhile, repeatedly read PCI rom
> every one second.
> 
> [
>    echo 1 > /sys/bus/pci/devices/0000\:00\:03.0/rom
>    cat /sys/bus/pci/devices/0000\:00\:03.0/rom > /dev/null
> ]

Can't see why it reflects real world scenario (or a real world
scenario with same characteristics regarding kvm_mmu_zap_all vs faults)?

Point is, it would be good to understand why this change 
is improving performance? What are these cases where breaking out of
kvm_mmu_zap_all due to either (need_resched || spin_needbreak) on zapped
< 10 ?



