Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaG0I6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 04:58:08 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52880 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaG0I6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 04:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <53D4BC7D.7030008@nod.at>
References: <CAPb+xgO9_7FQ3NM1NCL8zW5hMzUcWASxu-mk3e64Y+V_DnkMzg@mail.gmail.com>
	<CAFLxGvyD-R-ex8OadHV9pkz7gGOf09_8qfAwq-xB1URZqFH33w@mail.gmail.com>
	<CAPb+xgP+1MvSJsQkdsTT-W3VXCHLYV2FyQ_bNO=Seb6RKbVKPA@mail.gmail.com>
	<53D4BC7D.7030008@nod.at>
Date: Sun, 27 Jul 2014 14:28:05 +0530
Message-ID: <CAPb+xgOKD3URc3ViJaYm65TOT1tmPMHK4BfpUn+9khCA9SOGOA@mail.gmail.com>
Subject: Re: "copy_to_user" function not working in stable build "2.6.36.4"
From: zubraz singha <zubrajsingha@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake,  I forgot to add this, the "copy_to_user" function I'm
referring here is for "X86"
based architecture.

What I have found:
-> 2.6.36.4
*  "copy_to_user" calls "_copy_to_user"
* "_copy_to_user" no definition.

-> 3.14
* copy_to_user calls "_copy_to_user"
* "_copy_to_user" has a definiton
* _copy_to_user is  defined as a function call to access_ok function
and __copy_to_user.

 I was just wondering if the fix present in kernel versions "3.14" for
this , will work straight forward on "2.6.36.4". What I mean is
whether back porting of this fix will work, or there are other
parameters to consider.




On 7/27/14, Richard Weinberger <richard@nod.at> wrote:
> Am 27.07.2014 10:44, schrieb zubraz singha:
>> I do understand that this is a very old build and its not being
>> supported. As I wrote in my earlier mail,  the function works fine
>> with higher kernel versions. I will try to find out a work around for
>> this. Appreciate your feedback.
>
> First I'd look into 2.6.32.x. Maybe it needed fixing and you can forward
> port the fix. :)
>
> Thanks,
> //richard
>


-- 
-- Regards
Zubraj Singha
