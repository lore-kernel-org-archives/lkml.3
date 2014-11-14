Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965444AbaKNOaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:30:06 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40320 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887AbaKNOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:30:04 -0500
Message-ID: <546611E5.2090209@redhat.com>
Date: Fri, 14 Nov 2014 15:29:57 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com> <1415963522-5255-2-git-send-email-pbonzini@redhat.com> <20141114133500.GA10593@potion.brq.redhat.com>
In-Reply-To: <20141114133500.GA10593@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/11/2014 14:35, Radim Krčmář wrote:
> We are replacing in a sorted array, so the the direction of our
> traversal doesn't change, (and we could lose one tab level here,)
> 
> 	if (new->npages < mslots[i].npages) {
> 		while (i < (KVM_MEM_SLOTS_NUM - 1) &&
> 		       new->npages < mslots[i + 1].npages) {
> 			mslots[i] = mslots[i + 1];
> 			slots->id_to_index[mslots[i].id] = i;
> 			i++;
> 		}
> 	else if (new->npages > mslots[i].npages)
> 		while (i > 0 &&
> 		       new->npages > mslots[i - 1].npages) {
> 			mslots[i] = mslots[i - 1];
> 			slots->id_to_index[mslots[i].id] = i;
> 			i--;
> 		}
> 
> (I guess you don't want me to abstract these two loops further :)

Right.  You do not need the "else if" as long as you keep the outer "if
(new->npages != mslots[i].npages)".

> (We'll have to change it into an interval tree, or something, if the
>  number of slots rises anyway.)

I don't think that's needed, actually.  gfn_to_page and gfn_to_memslot
are very rarely in the profiles with EPT.

Paolo
