Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab3IIKMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:12:24 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:45568 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3IIKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:12:20 -0400
Message-ID: <522D9F07.6030009@redhat.com>
Date: Mon, 09 Sep 2013 12:12:23 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] KVM: mmu: allow page tables to be in read-only slots
References: <1378383714-9723-1-git-send-email-pbonzini@redhat.com> <20130908090448.GD17294@redhat.com>
In-Reply-To: <20130908090448.GD17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2013 11:04, Gleb Natapov ha scritto:
> On Thu, Sep 05, 2013 at 02:21:53PM +0200, Paolo Bonzini wrote:
>> Page tables in a read-only memory slot will currently cause a triple
>> fault when running with shadow paging, because the page walker uses
>> gfn_to_hva and it fails on such a slot.
>>
>> TianoCore uses such a page table.  The idea is that, on real hardware,
>> the firmware can already run in 64-bit flat mode when setting up the
>> memory controller.  Real hardware seems to be fine with that as long as
>> the accessed/dirty bits are set.  Thus, this patch saves whether the
>> slot is readonly, and later checks it when updating the accessed and
>> dirty bits.
>>
>> Note that this scenario is not supported by NPT at all, as explained by
>> comments in the code.
>>
>> Cc: stable@vger.kernel.org
>> Cc: kvm@vger.kernel.org
>> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> I would prefer to change gfn_to_hva_read() to gfn_to_hva_prot() in this
> patch already, it will not make it any bigger

Sure.

Paolo

