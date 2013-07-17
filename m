Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3GQTww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:52:52 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:64887 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab3GQTwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:52:51 -0400
Content-Type: text/plain; charset=windows-1255
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: commit f8f559422b (KVM: MMU: fast invalidate all mmio sptes) causes hang
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130717193100.GM13732@redhat.com>
Date: Thu, 18 Jul 2013 03:52:43 +0800
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1B1F8ADA-1CD3-4CC4-B24D-A0C81B7DFCC5@gmail.com>
References: <20130717163215.GA359@x4> <20130717164232.GI13732@redhat.com> <20130717165743.GA357@x4> <B438F263-D5D5-4755-AAAA-ED92F4F0379E@gmail.com> <20130717193100.GM13732@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18, 2013, at 3:31 AM, Gleb Natapov <gleb@redhat.com> wrote:

> On Thu, Jul 18, 2013 at 03:07:11AM +0800, Xiao Guangrong wrote:
>> Ouch!
>> 
>> The guest is hang when boot from ubuntu iso, i bisected the code and found it is caused by:
>> 
>> cad55f1aed000db46dfd1b5706707f33624d8604 is the first bad commit
>> commit cad55f1aed000db46dfd1b5706707f33624d8604
>> Author: Cornelia Huck <cornelia.huck@de.ibm.com>
>> Date:   Wed Jul 3 16:30:53 2013 +0200
>> 
>>    KVM: kvm-io: support cookies
>> 
>>    Add new functions kvm_io_bus_{read,write}_cookie() that allows users of
>>    the kvm io infrastructure to use a cookie value to speed up lookup of a
>>    device on an io bus.
>> 
>>    Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
>>    Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> 
>> Now, i have reset the code behind this commit and continue to install the guest…...
>> 
> You are on an old queue branch (the commit was never in next). I fixed it not long time ago. Can you
> pull?

Yes. The issue is gone after update the code. Thank you, Gleb!

