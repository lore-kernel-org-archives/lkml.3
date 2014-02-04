Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaBDI1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 03:27:36 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:56865 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaBDI12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 03:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140204082110.GG26722@mwanda>
References: <1391497163-6894-1-git-send-email-sj38.park@gmail.com> <20140204082110.GG26722@mwanda>
From: SeongJae Park <sj38.park@gmail.com>
Date: Tue, 4 Feb 2014 17:26:57 +0900
Message-ID: <CAEjAshrT1z+-VsKPO6MYZ2=Ly8XqjJY_NVzsZkXhtUvMLTEBTA@mail.gmail.com>
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

Hello,

On Tue, Feb 4, 2014 at 5:21 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Feb 04, 2014 at 03:59:23PM +0900, SeongJae Park wrote:
>> Fix the pointer-integer size mismatch warnings below:
>>       drivers/staging/bcm/CmHost.c: In function ‘StoreCmControlResponseMessage’:
>>       drivers/staging/bcm/CmHost.c:1387:39: warning: cast to pointer from
>>                       integer of different size [-Wint-to-pointer-cast]
>>         pstAddIndication->psfAuthorizedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAuthorizedSet);
>>                                              ^
>>       drivers/staging/bcm/CmHost.c:1426:37: warning: cast to pointer from
>>                       integer of different size [-Wint-to-pointer-cast]
>>         pstAddIndication->psfAdmittedSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfAdmittedSet);
>>                                            ^
>>       drivers/staging/bcm/CmHost.c:1440:35: warning: cast to pointer from
>>                       integer of different size [-Wint-to-pointer-cast]
>>         pstAddIndication->psfActiveSet = (struct bcm_connect_mgr_params *)ntohl((ULONG)pstAddIndication->psfActiveSet);
>>                                          ^
>
> No.  You haven't fixed the bug, you've just silenced the warning so now
> someone has to spent hours and hours looking for it when it comes time
> to write a proper fix.  Don't do that.
>

I had thought silencing warning may be better in someway for some people.
But, anyway, now I agree and respect your opinion. Thank you for the opinion :)

> regards,
> dan carpenter
>
>
