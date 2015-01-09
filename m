Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbbAITi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:38:58 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47997 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbbAITi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141210144921.GC17184@kroah.com>
References: <1418194573-1271-1-git-send-email-shalinmehta85@gmail.com>
	<20141210070957.GN22149@ZenIV.linux.org.uk>
	<20141210144921.GC17184@kroah.com>
Date: Fri, 9 Jan 2015 21:38:56 +0200
Message-ID: <CANZNk80x4nTrdy+pv0n8_mXCuU-x2AYidCgAD5D7hipHV2gcbA@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: Fix the warning messages about casting
 without __user macro
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>, bergwolf@gmail.com,
        "Dilger, Andreas" <andreas.dilger@intel.com>, peterz@infradead.org,
        Shalin Mehta <shalinmehta85@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        majordomo@vger.kernel.org, gdonald@gmail.com, tranmanphong@gmail.com,
        "HPDD-discuss@ml01.01.org" <HPDD-discuss@ml01.01.org>,
        massa.nomura@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-10 16:49 GMT+02:00 Greg KH <gregkh@linuxfoundation.org>:
> On Wed, Dec 10, 2014 at 07:09:59AM +0000, Al Viro wrote:
>> On Tue, Dec 09, 2014 at 10:56:12PM -0800, Shalin Mehta wrote:
>> > From: Shalin Mehta <shalinmehta85@gmail.com>
>> >
>> > This issue is showed up while compiling with sparse. The iov_base in struct iovec struct explicitly declares that the assigned value should be user space pointer with __user macro. Where as here, the __user macro isn't used while casting.
>>
>> ... and pointers are not user space ones at all.  Which is to say, quit
>> messing with casts; it's not struct iovec.  Proper fix is to replace
>> it here (and in almost all places throughout drivers/staging/lustre) with
>> struct kvec.  And yes, such a patch had been sent.  Still not applied,
>> AFAICS...
>
> Yeah, it's in the merge window and I'll pick new staging patches back up
> when 3.19-rc1 is released.

Hi Greg,
Still no commits for
drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c since Sun Nov
23 (staging: lustre: Coalesce string fragments) in linux-next. Maybe
the aforementioned commit got missed for merging?

-- 
Andrey Utkin
