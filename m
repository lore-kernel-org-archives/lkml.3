Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3CGWSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:18:22 -0500
Received: from mail.candelatech.com ([208.74.158.172]:47505 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843Ab3CGWSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:18:21 -0500
Message-ID: <51391225.1020403@candelatech.com>
Date: Thu, 07 Mar 2013 14:18:13 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mateusz Guzik <mguzik@redhat.com>
CC: linux-cifs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: 3.7.10+:  BUG Dentry still in use [unmount of cifs cifs]
References: <51363F80.8070609@candelatech.com> <20130307191914.GA1652@mguzik.brq.redhat.com>
In-Reply-To: <20130307191914.GA1652@mguzik.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 11:19 AM, Mateusz Guzik wrote:
> On Tue, Mar 05, 2013 at 10:54:56AM -0800, Ben Greear wrote:
>> In doing some CIFS testing (utilizing it's feature to bind to local
>> address..but not sure that matters), we saw this error when trying
>> to un-mount.
>>
>> Our kernel is patched (nfs, some networking related patches), but there
>> are no out-of-kernel patches to CIFS, so I don't *think* this is anything
>> we could have caused.
>>
>> This problem appears to be easily reproducible, so we will be happy
>> to test patches if anyone has any suggestions.
>>
>> BUG: Dentry ffff8800c07e43c0{i=45762,n=cifs2-01.7.lf-data} still in use (1) [unmount of cifs cifs]
>
> We encountered similar panic, but it was related to writes. In our case
> the problem was that some cifsInodeInfo holding dentry references were
> still around (in slow-work queue) during superblock destruction in unmount.
>
> I reproduced the problem on 3.8 kernel (sorry, no 3.7 handy) with reads
> as well, which should match your scenario.
>
> I attached a patch that deals with this problem by grabbing refcounts to
> cifs superblock on cifsInodeInfo creation. This delays sb destruction
> until all cifsInodeInfos are gone. I didn't test it on 3.7.10 kernel but
> it should work fine.

The 3.7.10 patch applied cleanly and appears to fix our problem.

Thanks so much for the patch!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

