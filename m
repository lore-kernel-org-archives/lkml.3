Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaDFOnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 10:43:55 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:32779 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaDFOnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 10:43:52 -0400
X-AuditID: cbfec373-b7f4a6d000005e0a-37-53416826c7f2
Date: Sun, 06 Apr 2014 11:43:44 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for v3.15-rc1] media updates
Message-id: <20140406114344.295b22da@samsung.com>
In-reply-to: <CA+55aFz8+kgRAm9Oozkcaa+diL_6OEP=M4wr7j5z-HTOg-2O=g@mail.gmail.com>
References: <20140403131143.69f324c7@samsung.com>
 <CA+55aFz8+kgRAm9Oozkcaa+diL_6OEP=M4wr7j5z-HTOg-2O=g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/hIF21DMdgg8kLTCzmrF/DZrHk5y4m
	i8u75rBZ9GzYymrxqO8tuwOrx5TfG1k9Tsz4zeLxeZNcAHMUl01Kak5mWWqRvl0CV8a+ZzPZ
	Ci5zVCy5PImxgfEZWxcjB4eEgIlExyHpLkZOIFNM4sK99UBhLg4hgSWMEosv3oVy+pgkVrc8
	ZAGpYhFQlWi4e5UVxGYTMJJ41dgCZosA2Z9fXGEFaWAWOMMocfrfXzaQhLCAscTnV33sIDav
	gKHEgcUnmEBsToFgif41zxhBbCGBComNM96xQJzhJPHq9WQmiHpBiR+T74HFmQW0JDZva2KF
	sOUlNq95yzyBUWAWkrJZSMpmISlbwMi8ilG0tDi5oDgpPddIrzgxt7g0L10vOT93EyMkfIt3
	ML7YYHWIUYCDUYmHtyLHIViINbGsuDL3EKMEB7OSCK+miWOwEG9KYmVValF+fFFpTmrxIUYm
	Dk6pBkZ90+PLYn5Xl5VP+VOYpLP74KFDa3SPm/hOsLKwEPy/4ciPKpX797bG75y58pNw7nqW
	G3Zp79kb4k0dcj5Vxj8oeOQ9o9jaun0S66xQG7vU8iPrKm9N81Sd0SO0x4xdwuSRR8nV7Pvt
	naF3NOf/WnleqGx99UKuHS1Oa0wsFzs3VFfqq+btX6bEUpyRaKjFXFScCACYUH5dPQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 04 Apr 2014 15:04:16 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> On Thu, Apr 3, 2014 at 9:11 AM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> >
> > Please pull from:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus
> 
> Oh, just noticed that this seems to be the cause of a new annoying warning:
> 
>    usr/include/linux/v4l2-common.h:72: found __[us]{8,16,32,64} type
> without #include <linux/types.h>
> 
> which seems to have come in through commits 777f4f85b75f1 and 254a47770163f.
> 
> I think the proper fix is to just add that
> 
>   #include <linux/types.h>

Yes, this is the proper fix. Thanks for noticing. I added a make
headers_check on my test scripts, to allow me to notice things like
that next time.

I just committed a patch for it on my tree. I'll send you together
with a few other fixes at the beginning of the next week.

> 
> to include/uapi/linux/v4l2-common.h. Assuming that really is supposed
> to be a user-visible API at all?
> 
>               Linus

Thanks!
Mauro
