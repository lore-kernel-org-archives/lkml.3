Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3BRQGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:06:40 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58034 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3BRQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:06:38 -0500
Date: Tue, 19 Feb 2013 01:06:31 +0900 (JST)
Message-Id: <20130219.010631.336702748.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/13] vmcore: introduce types for objects copied in
 2nd kernel
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130215152828.GC27784@redhat.com>
References: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
	<20130214101205.22466.5909.stgit@localhost6.localdomain6>
	<20130215152828.GC27784@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/13] vmcore: introduce types for objects copied in 2nd kernel
Date: Fri, 15 Feb 2013 10:28:28 -0500

> On Thu, Feb 14, 2013 at 07:12:05PM +0900, HATAYAMA Daisuke wrote:
>> Some parts of old memory need to be copied in buffers on 2nd kernel to
>> be remapped to user-space. To distinguish objects in the buffer on 2nd
>> kernel and the ones on old memory, enum vmcore_type is introduced: the
>> object in the buffer on 2nd kernel has VMCORE_2ND_KERNEL type, and the
>> one on old memory has VMCORE_OLD_MEMORY type.
>> 
>> Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>> ---
>> 
>>  include/linux/proc_fs.h |   11 ++++++++++-
>>  1 files changed, 10 insertions(+), 1 deletions(-)
>> 
>> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
>> index 32676b3..4b153ed 100644
>> --- a/include/linux/proc_fs.h
>> +++ b/include/linux/proc_fs.h
>> @@ -97,11 +97,20 @@ struct kcore_list {
>>  	int type;
>>  };
>>  
>> +enum vmcore_type {
>> +	VMCORE_OLD_MEMORY,
>> +	VMCORE_2ND_KERNEL,
> 
> This VMCORE_2ND_KERNEL tag looks bad.
> 
> How about introducing a "unsigned int flag" element in "struct vmcore"
> and set the flag MEM_TYPE_OLDMEM for any contents which come from oldmem.
> 
> If MEM_TYPE_OLDMEM is not set, it is assumed that contents are to be
> fetched from current kernel using pointer vmcore->buf.

This sounds strange to me. There has not been contents to be fetched
from current kenrel so far. So, object with MEM_TYPE_OLDMEM seems more
normal than without. Should we prepare special type for objects in 2nd
kernel?

Thanks.
HATAYAMA, Daisuke

