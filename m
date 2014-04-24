Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaDXO4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:56:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbaDXOz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:55:56 -0400
Date: Thu, 24 Apr 2014 16:55:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: async_pf: use_mm/mm_users fixes
Message-ID: <20140424145545.GA17450@redhat.com>
References: <20140421132543.GA13594@redhat.com> <53591F65.9010001@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53591F65.9010001@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Christian Borntraeger wrote:
>
> On 21/04/14 15:25, Oleg Nesterov wrote:
> > Hello.
> >
> > Completely untested and I know nothing about kvm ;) Please review.
> >
> > But use_mm() really looks misleading, and the usage of mm_users looks
> > "obviously wrong". I already sent this change while we were discussing
> > vmacache, but it was ignored. Since then kvm_async_page_present_sync()
> > was added into async_pf_execute() into async_pf_execute(), but it seems
> > to me that use_mm() is still unnecessary.
> >
> > Oleg.
> >
> >  virt/kvm/async_pf.c |   10 ++++------
> >  1 files changed, 4 insertions(+), 6 deletions(-)
> >
>
> I gave both patches some testing on s390, seems fine. I think patch2 really
> does fix a bug. So if Paolo, Marcelo, Gleb agree (maybe do a test on x86 for
> async_pf) both patches are good to go. Given that somebody tests this on x86:
>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Thanks!

I think x86 should be fine, it doesn't select CONFIG_KVM_ASYNC_PF_SYNC and
get_user_pages() is certainly fine without use_mm(). And I still think it
should do get_user_pages(tsk => NULL) but this is minor.

Oleg.

