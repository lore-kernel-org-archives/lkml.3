Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbaDIKVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 06:21:07 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:60280 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbaDIKVG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 9 Apr 2014 06:21:06 -0400
Message-Id: <53453B2F0200007800007119@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 09 Apr 2014 11:21:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <david.vrabel@Citrix.com>, <konrad@kernel.org>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [LINUX PATCH 2/2] xen/pvhvm: Support more than 32 VCPUs
 when migrating.
References: <201404091015.s39AFQAu022348@aserz7021.oracle.com>
In-Reply-To: <201404091015.s39AFQAu022348@aserz7021.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.04.14 at 12:15, <konrad.wilk@oracle.com> wrote:

> On Apr 9, 2014 4:03 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>> >>> On 08.04.14 at 19:25, <konrad@kernel.org> wrote: 
>> > + /* Only Xen 4.5 and higher supports this. */ 
>> > + if (HYPERVISOR_vcpu_op(VCPUOP_is_up, smp_processor_id(), NULL) == 
> -ENOSYS) 
>> > + vcpuops = false; 
>>
>> Did you mean to say "for HVM guests" in the comment? And of 
>> course the comment could quickly become stale if we backported 
>> the Xen side change to e.g. 4.4.1. 
>>
> 
> Right. But I thought that features like that (new hypercalls) wasn't 
> applicable for backporting?

It's not really a new hypercall, and fixing a problem, so I'd consider
it a candidate at least for 4.4.1.

Jan

