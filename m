Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3IHOYS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 10:24:18 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43285 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3IHOYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 10:24:16 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH v2 01/15] KVM: MMU: fix the count of spte number
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
In-Reply-To: <20130908140149.GA6468@redhat.com>
Date: Sun, 8 Sep 2013 22:24:05 +0800
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6A5E49EE-3729-4825-AF31-CF03DDD92E64@gmail.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1378376958-27252-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130908121917.GH17294@redhat.com> <B8E036F3-BF65-4EF5-AA70-352951724A97@gmail.com> <20130908140149.GA6468@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 8, 2013, at 10:01 PM, Gleb Natapov <gleb@redhat.com> wrote:

> On Sun, Sep 08, 2013 at 09:55:04PM +0800, Xiao Guangrong wrote:
>> 
>> On Sep 8, 2013, at 8:19 PM, Gleb Natapov <gleb@redhat.com> wrote:
>> 
>>> On Thu, Sep 05, 2013 at 06:29:04PM +0800, Xiao Guangrong wrote:
>>>> If the desc is the last one and it is full, its sptes is not counted
>>>> 
>>> Hmm, if desc is not full but it is not the last one all sptes after the
>>> desc are not counted too.
>> 
>> But the desc must be the last one if it's not full since we always add
>> new entry or delete entry from the last desc.
>> 
> Why do we alway delete entries from last desc? We delete them from the
> desc we found them in. Current code does not try to move entries between
> descs, only inside a desc.

Oh, yes. Sorry, my memory is wrong… :(

So, currently there has some gaps in desc and it wastes memory.  Can not fix
them with simple change and  i think it is not worthy to fix them separately since
after my new algorithm, these should all be fixed… so how about just drop this
fix?



