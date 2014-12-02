Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbaLBSp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:45:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaLBSp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:45:26 -0500
Message-ID: <547E08C1.3090708@redhat.com>
Date: Tue, 02 Dec 2014 19:45:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/5] kvm: optimize GFN to memslot lookup with large slots
 amount
References: <1417454967-4465-1-git-send-email-imammedo@redhat.com> <1417454967-4465-6-git-send-email-imammedo@redhat.com> <20141202173350.GA11312@potion.brq.redhat.com>
In-Reply-To: <20141202173350.GA11312@potion.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/12/2014 18:33, Radim Krčmář wrote:
>> > +	while (start < end) {
>> > +		slot = start + (end - start) / 2;
>> > +
>> > +		if (gfn >= memslots[slot].base_gfn)
> (Even thought division is costly, I think that checking here if 'slot'
>  is the one we want wouldn't help very much.)
> 

Division by an unsigned is just a right shift.  Division by signed
integer is a right shift + conditional move.  We can change / 2 to
explicit >> 1, or change start and end to unsigned, or both.

Paolo
