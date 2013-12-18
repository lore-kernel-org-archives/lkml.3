Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3LREAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 23:00:23 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62151 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3LREAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 23:00:21 -0500
MIME-Version: 1.0
In-Reply-To: <F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
References: <1387291383-25126-1-git-send-email-xuyongjiande@gmail.com>
	<F1B567DD-C322-4BA7-BFEA-E7C4B1F82697@kolumbus.fi>
Date: Wed, 18 Dec 2013 12:00:20 +0800
Message-ID: <CAAdffVH3pPpvu+GWwikPpGynTRRMW2unbyRvP2jQWpUU-=R6qw@mail.gmail.com>
Subject: Re: [PATCH] scsi: int overflow in st_ioctl()
From: Yu Chen <chyyuu@gmail.com>
To: =?ISO-8859-1?Q?Kai_M=E4kisara_=28Kolumbus=29?= 
	<kai.makisara@kolumbus.fi>
Cc: =?GB2312?B?0OzTwL2h?= <xuyongjiande@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the local variable of st_int_ioctl function, such as long ltmp
be assigned by arg.
I think  we should limit the parameter arg of st_int_ioctl function to
the range of 24-bit signed integer.
Yong Jianxu, please update your patch.

2013/12/18 "Kai Mäkisara (Kolumbus)" <kai.makisara@kolumbus.fi>:
> On 17.12.2013, at 16.43, Yongjian Xu xuyongjiande@gmail.com wrote:
>
>> From: Yongjian Xu <xuyongjiande@gmail.com>
>>
>> mtc.mt_count comes from user-space.
>> int overflow may occur:
>> mtc.mt_count++;
>> mtc.mt_count—;
>
> I agree that this is a problem. However, it seems that there is also another problem: the SPACE command uses a 24-bit count field and this overflows far below INT_MAX. Should the count in MTFSF etc. be limited to (2<<24-2)? This would make the checks you suggest unnecessary. (-2 so that the behavior does not depend on whether we are at file mark or not.)
>
> I am a bit hesitant with this suggestion because someone may use count INT_MAX to space to the end of the tape. This probably succeeds now but after the fix it would return an error.
>
> Thanks,
> Kai
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best Regards
==============================================
Yu Chen
Ph.D.  Associate Professor
System Software&Software Engineering Group,
Dept. of Computer Science and Technology
Tsinghua University, Beijing 100084, P.R. China
E-Mail: mailto:yuchen@tsinghua.edu.cn  chyyuu@gmail.com
==============================================
