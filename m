Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKFQYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:24:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKFQYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:24:05 -0500
Message-ID: <545BA09E.7040301@redhat.com>
Date: Thu, 06 Nov 2014 17:23:58 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] kvm: x86: increase user memory slots to 509
References: <1415289167-24661-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1415289167-24661-1-git-send-email-imammedo@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/11/2014 16:52, Igor Mammedov wrote:
> With the 3 private slots, this gives us 512 slots total.
> Motivation for this is in addition to assigned devices
> support more memory hotplug slots, where 1 slot is
> used by a hotplugged memory stick.
> It will allow to support upto 256 hotplug memory
> slots and leave 253 slots for assigned devices and
> other devices that use them.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

It would use more memory, and some loops are now becoming more
expensive.  In general adding a memory slot to a VM is not cheap, and I
question the wisdom of having 256 hotplug memory slots.  But the
slowdown mostly would only happen if you actually _use_ those memory
slots, so it is not a blocker for this patch.

We probably should change the kmemdup + heap sort of
__kvm_set_memory_region + update_memslots to copy the array and insert
the new item at the right place, at the same time.  Using a heap sort is
overkill and unnecessarily goes from O(n^2) to O(n^2 log n).  With a
bigger constant in front as well.

If you want to do it, I'd be grateful.  Otherwise I can look at it as
time permits.

Paolo
