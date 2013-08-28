Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab3H1KN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:13:57 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:41949 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3H1KNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:13:51 -0400
Message-ID: <521DCD57.7000401@linux.vnet.ibm.com>
Date: Wed, 28 Aug 2013 18:13:43 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 09/12] KVM: MMU: introduce pte-list lockless walker
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-10-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130828092001.GQ22899@redhat.com> <521DC3FD.1020507@linux.vnet.ibm.com> <20130828094630.GR22899@redhat.com>
In-Reply-To: <20130828094630.GR22899@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082810-5140-0000-0000-000003BD43A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2013 05:46 PM, Gleb Natapov wrote:
> On Wed, Aug 28, 2013 at 05:33:49PM +0800, Xiao Guangrong wrote:
>>> Or what if desc is moved to another rmap, but then it
>>> is moved back to initial rmap (but another place in the desc list) so
>>> the check here will not catch that we need to restart walking?
>>
>> It is okay. We always add the new desc to the head, then we will walk
>> all the entires under this case.
>>
> Which races another question: What if desc is added in front of the list
> behind the point where lockless walker currently is?

That case is new spte is being added into the rmap. We need not to care the
new sptes since it will set the dirty-bitmap then they can be write-protected
next time.

> 
>> Right?
> Not sure. While lockless walker works on a desc rmap can be completely
> destroyed and recreated again. It can be any order.

I think the thing is very similar as include/linux/rculist_nulls.h

