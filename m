Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3JVO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:29:55 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:62761 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3JVO3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:29:07 -0400
Message-ID: <52668BAE.2000301@linux.com>
Date: Tue, 22 Oct 2013 16:29:02 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Subject: Re: [RFC] Rollback FS
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>	<20131020123521.GA15627@thunk.org>	<CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>	<5263D576.70202@linux.com>	<CABjrhvq8WYUzv6DVewiincNkSH9rCC_-1RVEOop1QE8+e3dnig@mail.gmail.com>	<5263DA0A.7030004@linux.com> <CABjrhvomv62ww9z3_LXosWVMPCrAe7jME2NhBa4AkaZP5TQN3Q@mail.gmail.com>
In-Reply-To: <CABjrhvomv62ww9z3_LXosWVMPCrAe7jME2NhBa4AkaZP5TQN3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-20 17:22 keltezéssel, jiaweiwei írta:
> On Sun, Oct 20, 2013 at 9:26 PM, Levente Kurusa <levex@linux.com> wrote:
>> 2013-10-20 15:19 keltezéssel, jiaweiwei írta:
>>> On Sun, Oct 20, 2013 at 9:07 PM, Levente Kurusa <levex@linux.com> wrote:
>>> [...]
>>>>> A good catch. Following ideas would be suitable.
>>>>>
>>>>> 1, Keep the blocks or inodes by a parameter we give.
>>>>> 2, Keep the blocks or inodes for several seconds.
>>>> Keep them where? On the HDD? We just deleted/moved that.
>>>
>>> Delete/move a file with a parameter, which would keep the blocks or inodes
>>> in-place. Or we would keep the blocks or inodes for several seconds.
>>
>> The problem with keeping the inodes/blocks for several seconds is
>> that you would need to find a magic number that is not small enough,
>> because if it is, then what if the user doesn't notice the problem
>> during a long operation? If the magic number is big, then we waste a
>> lot of space.
>>
>> The problem with the parameter thing is that again, all the different
>> filesystems need to support that feature. We can't just tell Ext3 or JFFS2 on the VFS level,
>> that 'Hey, keep those inodes in place incase someone just made himself some headache.'
>>
> 
> Above you said are what we should do.
I never said that.
> Don't waste time, let me design and
> implement it. I would send design document for review, thanks.
Do it, but I don't think it would be accepted.


-- 
Regards,
Levente Kurusa
