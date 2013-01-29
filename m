Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3A2Czf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:55:35 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40771 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3A2Czd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:55:33 -0500
Message-ID: <51073A1C.1050600@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2013 10:55:24 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/12] KVM: MMU: simplify mmu_set_spte
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB5E9.2010500@linux.vnet.ibm.com> <20130129002151.GB10814@amt.cnet>
In-Reply-To: <20130129002151.GB10814@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012902-3864-0000-0000-0000069E0AE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 08:21 AM, Marcelo Tosatti wrote:
> On Wed, Jan 23, 2013 at 06:05:29PM +0800, Xiao Guangrong wrote:
>> In order to detecting spte remapping, we can simply check whether the
>> spte has already been pointing to the pfn even if the spte is not the
>> last spte, for middle spte is pointing to the kernel pfn which can not
>> be mapped to userspace
> 
> This check is detecting spte overwrite, when a large spte is replaced by 
> pointer to spte table.
> 
> Can't see why check for different pfn is safe: only 'int level' can
> differ, and pfn be equivalent, for example.

The 'u64 *sptep' must on the "int level" we want to set, that means:
 page_header(__pa(sptep)).role.level == "int level".


We discussed this before :), the discussion can be found at:
http://marc.info/?l=kvm&m=135345057329427&w=2.

