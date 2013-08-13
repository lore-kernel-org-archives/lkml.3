Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab3HMHvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:51:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56324 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276Ab3HMHvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:51:11 -0400
From: Shyam Kaushik <shyam@zadarastorage.com>
References: <9a92eee58fefc1b8e3b4771ecf210d29@mail.gmail.com>
 <20130813071944.GA11270@kroah.com> <199217e8a2fc33f6aa0ecf764a0104cb@mail.gmail.com>
 <20130813072616.GA14019@kroah.com>
In-Reply-To: <20130813072616.GA14019@kroah.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Ac6X9jLHzVSNUOVzSB279QJqBM61PgAAuimQ
Date: Tue, 13 Aug 2013 13:21:12 +0530
Message-ID: <446f41f4a3ea0c758b05c0348d2b6f5d@mail.gmail.com>
Subject: RE: BUG REPORT - IDR wraps around at 30-bits - works very bad with NFSD/SCTP
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was just more time from me on this:-) But anyways since you wanted I
tried.

I tested 3.10.6-031006-generic & it works perfect in there!

[  832.513688] Processing for min_stateid[0]
[  832.513701] Allocated new_stid[0]
[  832.513703] Dumping entries in IDR
[  832.513705]  IDR Actual ID[0] == Expected Value[0]
[  832.513710]
[  832.513710] Processing for min_stateid[1073741823]
[  832.513713] Allocated new_stid[1073741823]
[  832.513714] Dumping entries in IDR
[  832.513729]  IDR Actual ID[1073741823] == Expected Value[1073741823]
[  832.513731]
[  832.513731] Processing for min_stateid[1073741824]
[  832.513736] Allocated new_stid[1073741824]
[  832.513737] Dumping entries in IDR
[  832.513739]  IDR Actual ID[1073741824] == Expected Value[1073741824]
[  832.513754]
[  832.513754] Processing for min_stateid[2147483647]
[  832.513763] Allocated new_stid[2147483647]
[  832.513765] Dumping entries in IDR
[  832.513779]  IDR Actual ID[2147483647] == Expected Value[2147483647]

Any chances of backporting some parts of fix to <3.9 kernels?

Thanks.

--Shyam

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org]
Sent: Tuesday, August 13, 2013 12:56 PM
To: Shyam Kaushik
Cc: Tejun Heo; Andrew Morton; linux-kernel@vger.kernel.org
Subject: Re: BUG REPORT - IDR wraps around at 30-bits - works very bad
with NFSD/SCTP

On Tue, Aug 13, 2013 at 12:51:14PM +0530, Shyam Kaushik wrote:
> Hi Greg,
>
> Unfortunately we don't have a 3.9/3.10 environment here. So if IDR
> developers can try the example code, it should show if the bug is still
> present in there. Thanks.

There shouldn't be anything in 3.10 preventing you from building and
testing it out, is there?  Or do you have something that restricts you
to specific kernel versions?

thanks,

greg k-h

-----
No virus found in this message.
Checked by AVG - www.avg.com
Version: 2013.0.2904 / Virus Database: 3211/6571 - Release Date: 08/12/13
