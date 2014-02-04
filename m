Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787AbaBDJB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:01:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:54740 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaBDJBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:01:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140204085143.GF26776@mwanda>
References: <1391497163-6894-1-git-send-email-sj38.park@gmail.com>
 <20140204082110.GG26722@mwanda> <CAEjAshrT1z+-VsKPO6MYZ2=Ly8XqjJY_NVzsZkXhtUvMLTEBTA@mail.gmail.com>
 <20140204085143.GF26776@mwanda>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 4 Feb 2014 18:00:47 +0900
Message-ID: <CAEjAshpzAQoV0M779FGTQbkXqQVz1pBNcwTBSU+B1o6wcD454A@mail.gmail.com>
Subject: Re: [PATCH] staging: bcm: fix pointer-integer size mismatch warnings
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, lisa@xenapiadmin.com,
        devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 5:51 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 04, 2014 at 05:26:57PM +0900, SeongJae Park wrote:
>> Hello,
>>
>> On Tue, Feb 4, 2014 at 5:21 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Tue, Feb 04, 2014 at 03:59:23PM +0900, SeongJae Park wrote:
>> >> Fix the pointer-integer size mismatch warnings below:
>> >>       drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
>> >>       drivers/staging/bcm/CmHost.c:1387:39: warning: cast to pointer from
>> >>                       integer of different size [-Wint-to-pointer-cast]
>> >>         pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
>> >>                                              ^
>> >>       drivers/staging/bcm/CmHost.c:1426:37: warning: cast to pointer from
>> >>                       integer of different size [-Wint-to-pointer-cast]
>> >>         pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
>> >>                                            ^
>> >>       drivers/staging/bcm/CmHost.c:1440:35: warning: cast to pointer from
>> >>                       integer of different size [-Wint-to-pointer-cast]
>> >>         pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfActiveSet);
>> >>                                          ^
>> >
>> > No.  You haven't fixed the bug, you've just silenced the warning so now
>> > someone has to spent hours and hours looking for it when it comes time
>> > to write a proper fix.  Don't do that.
>> >
>>
>> I had thought silencing warning may be better in someway for some people.
>> But, anyway, now I agree and respect your opinion. Thank you for the opinion :)
>
> Don't worry about it.  You're not the first person to try submit that
> patch.
>
> When I last looked at it, this driver only worked under 32 bits and
> there were other 64 bit bugs as well besides this one.
>
> regards,
> dan carpenter
>

Thank you very much for your kind reply. I'm yet newbie to kernel community
and thinking I should try with unavoidable mistakes. Your reply have gave me
more courage for trial.
I will not forget the learning I got from this trial :)
