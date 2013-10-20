Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3JTN0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 09:26:38 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41822 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JTN0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 09:26:37 -0400
Message-ID: <5263DA0A.7030004@linux.com>
Date: Sun, 20 Oct 2013 15:26:34 +0200
From: Levente Kurusa <levex@linux.com>
Reply-To: levex@linux.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: jiaweiwei <jiaweiwei.xiyou@gmail.com>
CC: "Theodore Ts'o" <tytso@mit.edu>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Subject: Re: [RFC] Rollback FS
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com>	<F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com>	<CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com>	<20131020123521.GA15627@thunk.org>	<CABjrhvpzcETE=CZrOkRgxpKhFm9-piYJLJ=8zdwnNkmJtkWRtQ@mail.gmail.com>	<5263D576.70202@linux.com> <CABjrhvq8WYUzv6DVewiincNkSH9rCC_-1RVEOop1QE8+e3dnig@mail.gmail.com>
In-Reply-To: <CABjrhvq8WYUzv6DVewiincNkSH9rCC_-1RVEOop1QE8+e3dnig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-10-20 15:19 keltezéssel, jiaweiwei írta:
> On Sun, Oct 20, 2013 at 9:07 PM, Levente Kurusa <levex@linux.com> wrote:
> [...]
>>> A good catch. Following ideas would be suitable.
>>>
>>> 1, Keep the blocks or inodes by a parameter we give.
>>> 2, Keep the blocks or inodes for several seconds.
>> Keep them where? On the HDD? We just deleted/moved that.
> 
> Delete/move a file with a parameter, which would keep the blocks or inodes
> in-place. Or we would keep the blocks or inodes for several seconds.

The problem with keeping the inodes/blocks for several seconds is
that you would need to find a magic number that is not small enough,
because if it is, then what if the user doesn't notice the problem
during a long operation? If the magic number is big, then we waste a
lot of space.

The problem with the parameter thing is that again, all the different
filesystems need to support that feature. We can't just tell Ext3 or JFFS2 on the VFS level,
that 'Hey, keep those inodes in place incase someone just made himself some headache.'

-- 
Regards,
Levente Kurusa
