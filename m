Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab3CSRIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab3CSRH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:07:58 -0400
Date: Tue, 19 Mar 2013 19:07:54 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] x86: correctly initialize the CS base on reset
Message-ID: <20130319170754.GJ19292@redhat.com>
References: <1363707026-19351-1-git-send-email-pbonzini@redhat.com>
 <20130319154319.GF19292@redhat.com>
 <51489549.10308@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51489549.10308@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 05:41:45PM +0100, Jan Kiszka wrote:
> On 2013-03-19 16:43, Gleb Natapov wrote:
> > On Tue, Mar 19, 2013 at 04:30:26PM +0100, Paolo Bonzini wrote:
> >> The CS base was initialized to 0 on VMX (wrong, but usually overridden
> >> by userspace before starting) or 0xf0000 on SVM.  The correct value is
> >> 0xffff0000, and VMX is able to emulate it now, so use it.
> >>
> >> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Reviewed-by: Gleb Natapov <gleb@redhat.com>
> 
> Just for the history (as I was wondering where this came from): CS base
> used to be set to 0xf0000 on VMX as well, but that was changed by
> b246dd5d to only affect guests when unrestricted mode is missing. That
> change actually left the base uninitialized.
> 
Looking at the code before b246dd5d it sets CS base to 0xf0000 only if it was
0xffff0000. This is the same as with current code: fix_rmode_seg() does
it.

--
			Gleb.
