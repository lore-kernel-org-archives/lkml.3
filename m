Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbaDXO2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:28:24 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:43783 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbaDXO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:27:56 -0400
Message-ID: <53591F65.9010001@de.ibm.com>
Date: Thu, 24 Apr 2014 16:27:49 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: async_pf: use_mm/mm_users fixes
References: <20140421132543.GA13594@redhat.com>
In-Reply-To: <20140421132543.GA13594@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042414-0542-0000-0000-000008C36A5F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/14 15:25, Oleg Nesterov wrote:
> Hello.
> 
> Completely untested and I know nothing about kvm ;) Please review.
> 
> But use_mm() really looks misleading, and the usage of mm_users looks
> "obviously wrong". I already sent this change while we were discussing
> vmacache, but it was ignored. Since then kvm_async_page_present_sync()
> was added into async_pf_execute() into async_pf_execute(), but it seems
> to me that use_mm() is still unnecessary.
> 
> Oleg.
> 
>  virt/kvm/async_pf.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 

I gave both patches some testing on s390, seems fine. I think patch2 really
does fix a bug. So if Paolo, Marcelo, Gleb agree (maybe do a test on x86 for
async_pf) both patches are good to go. Given that somebody tests this on x86:

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

