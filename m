Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568AbaKNOoa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:44:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965179AbaKNOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:44:28 -0500
Date: Fri, 14 Nov 2014 15:44:22 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yoshikawa_takuya_b1@lab.ntt.co.jp, imammedo@redhat.com
Subject: Re: [PATCH 1/3] kvm: memslots: track id_to_index changes during the
 insertion sort
Message-ID: <20141114144422.GC6801@potion.brq.redhat.com>
References: <1415963522-5255-1-git-send-email-pbonzini@redhat.com>
 <1415963522-5255-2-git-send-email-pbonzini@redhat.com>
 <20141114133500.GA10593@potion.brq.redhat.com>
 <546611E5.2090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546611E5.2090209@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-14 15:29+0100, Paolo Bonzini:
> On 14/11/2014 14:35, Radim Krčmář wrote:
> > We are replacing in a sorted array, so the the direction of our
> > traversal doesn't change, (and we could lose one tab level here,)
> > 
> > 	if (new->npages < mslots[i].npages) {
> > 		while (i < (KVM_MEM_SLOTS_NUM - 1) &&
> > 		       new->npages < mslots[i + 1].npages) {
> > 			mslots[i] = mslots[i + 1];
> > 			slots->id_to_index[mslots[i].id] = i;
> > 			i++;
> > 		}
> > 	else if (new->npages > mslots[i].npages)
> > 		while (i > 0 &&
> > 		       new->npages > mslots[i - 1].npages) {
> > 			mslots[i] = mslots[i - 1];
> > 			slots->id_to_index[mslots[i].id] = i;
> > 			i--;
> > 		}
> > 
> > (I guess you don't want me to abstract these two loops further :)
> 
> Right.  You do not need the "else if" as long as you keep the outer "if
> (new->npages != mslots[i].npages)".

True, I'm just an indentation hater.

> > (We'll have to change it into an interval tree, or something, if the
> >  number of slots rises anyway.)
> 
> I don't think that's needed, actually.  gfn_to_page and gfn_to_memslot
> are very rarely in the profiles with EPT.

Ah, that replaces my reply to Igor, thanks.
