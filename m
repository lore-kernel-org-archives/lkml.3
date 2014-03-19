Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbaCSWHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:07:17 -0400
Received: from www85.your-server.de ([213.133.104.85]:48223 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbaCSWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:07:14 -0400
From: Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 3.8: access permission filesystem
References: <87k3bqnflm.fsf@olafdietsche.de> <874n2t6get.fsf@xmission.com>
Date: Wed, 19 Mar 2014 23:07:07 +0100
Message-ID: <874n2tonas.fsf@olafdietsche.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: olaf@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Olaf Dietsche <olaf--list.linux-kernel@olafdietsche.de> writes:
>
>> I am in the process of catching up with the last two years or so.
>> Right now, I am at the changes involving user namespaces.
>>
>> I have two possible implementations, both working equally well in a
>> shared environment. Since I am not familiar with namespaces in general
>> and user namespaces in particular, I would like you to look over the
>> patches and tell me, what you think.
>>
>> Are the patches good so far? Are there are any things I missed and must
>> consider? Maybe, I am completely off track? Anything else?
>>
>> I included both patches inline below. The patches are also available as
>> separate branches at github 
>>
>> https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-1
>> https://github.com/olafdietsche/linux-accessfs/tree/tmp-user-ns-2
>>
>> I am leaning toward the second patch. Although it is a little bit longer
>> than the first one, it involves no user id conversions.
>
> Using kuid's and kgid's throughout as your second patch does is best.
> Conversion is only needed on normal filesystems because they have a
> backing store and reside on disk.  As accessfs appears not to have
> backing store, storing things with kuid's and kgid's is the preferred
> method.
>
> Your first patch is buggy as it uses current_user_ns().  Something a
> filesystem in general should not care about.

I have seen similar uses in other filesystems like ext3, jfs or
debugfs. What would be the correct way to use make_kuid() or make_gid()?

> I don't see anything wrong with your second patch.

Thanks a lot for this fast response and your guidance. So, I will dump
the first and continue with the second patch.

> From what little I understand of accessfs, I expect you will want to
> play with and come up to speed on namespaces, as namespaces change
> the universe of objects you will be dealing with, in some subtle
> but interesting ways.  At least assuming anyone in who uses accessfs
> is going to be using more than a single container.
>
> Eric

Regards, Olaf
