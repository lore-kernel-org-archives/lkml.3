Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab3AYCqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:46:51 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58932 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3AYCqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:46:42 -0500
Message-ID: <5101F207.6040603@linux.vnet.ibm.com>
Date: Fri, 25 Jan 2013 10:46:31 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 06/12] KVM: MMU: introduce a static table to map guest
 access to spte access
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB658.6040205@linux.vnet.ibm.com> <20130125001550.GB22875@amt.cnet>
In-Reply-To: <20130125001550.GB22875@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012502-1618-0000-0000-0000033E5C5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 08:15 AM, Marcelo Tosatti wrote:
> On Wed, Jan 23, 2013 at 06:07:20PM +0800, Xiao Guangrong wrote:
>> It makes set_spte more clean and reduces branch prediction
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   37 ++++++++++++++++++++++++++-----------
>>  1 files changed, 26 insertions(+), 11 deletions(-)
> 
> Don't see set_spte as being a performance problem?
> IMO the current code is quite simple.

Yes, this is not a performance problem.

I just dislike this many continuous "if"-s in the function:

if (xxx)
	xxx
if (xxx)
	xxx
....

Totally, it has 7 "if"-s before this patch.

Okay, if you think this is unnecessary, i will drop this patch. :)

