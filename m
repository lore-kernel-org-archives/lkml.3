Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3F0Fnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:43:33 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41551 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3F0Fnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <1372310676.28480.89.camel@kjgkr>
References: <1369533945-6955-1-git-send-email-linkinjeon@gmail.com>
	<1369619214.10521.25.camel@kjgkr>
	<CAKYAXd_QZronHD536LOfeFWLmtCoweRq3gbH94R4_7oKC7hv3w@mail.gmail.com>
	<1369704867.10521.46.camel@kjgkr>
	<CAKYAXd-OO5niMiFv+ysStw=c-NQXT4AkTz3m7o1wTRZRd=WYFw@mail.gmail.com>
	<1372140227.28480.69.camel@kjgkr>
	<CAKYAXd-NEKCuEyoLwWHLrN165yq7EKRRcz9RknfdbR5EOO6cvQ@mail.gmail.com>
	<1372310676.28480.89.camel@kjgkr>
Date: Thu, 27 Jun 2013 14:43:31 +0900
Message-ID: <CAKYAXd8cfvhce3_NWiLOzRz_=sWwqisH=gH4ZMGkxjv_Pt2H7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add sysfs support for controlling the gc_thread
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/27, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Hi,
>
> 2013-06-26 (수), 14:10 +0900, Namjae Jeon:
>> 2013/6/25, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
>> >> > - any priority scheme for cleaning?
>> >> Could you plz tell me a little more detail ?
>> >
>> > I meant, as well as the GC times, user also gives a kind of status
>> > like:
>> > LONG_IDLE, SHORT_IDLE, something like that.
>> > Therefore, how about using this information to select a victim
>> > selection
>> > policy between cost-benefit and greedy algorithms?
>> currently we will provide the option of updating the time values from
>> the ‘sysfs’ interface, and the GC policy is selected by default from
>> GC thread based upon the gc type, BG or FG.
>> So, do you mean we should provide an option to select the default GC
>> policy for the user using ‘sysfs’ interface? Like, if the user sets
>> “LONG_IDLE” – we choose Cost Benefit and in case of SHORT_IDLE
>> “Greedy” ? Please elaborate more on this.
>
> Yes, exact.
> For example, if an user configures a small period of GC interval but
> gives LONG_IDLE, we can choose cost-benefit.
> But, if SHORT_IDLE is given with a long GC period, we need to choose
> greedy.
> How do you think?
Hi. Jaegeuk.
Looks reasonable to me.
I will provide a policy attribute for f2fs sysfs with values,
LONG_IDLE and SHORT_IDLE with gc time.

Thanks :)
> Thanks,
>
> --
> Jaegeuk Kim
> Samsung
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
