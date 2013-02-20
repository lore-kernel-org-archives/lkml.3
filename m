Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935291Ab3BTMTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:19:43 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40639 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934840Ab3BTMTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:19:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130219133806.GC9138@mwanda>
References: <CAJsYZ5nnAHW9Uu-ee09ttFZZT-DeBVSiHzUnpwt3ZE0hjTFA=g@mail.gmail.com>
	<20130219133806.GC9138@mwanda>
Date: Wed, 20 Feb 2013 17:49:41 +0530
Message-ID: <CAJsYZ5=LTon+Wq=2B08HiRKr5o2g9syhfqFVgM7JD3bS5a_tzg@mail.gmail.com>
Subject: Re: [PATCH] staging: android: ashmem: get_name, set_name not to hold ashmem_mutex
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Cruz Julian Bishop <cruzjbishop@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,
Thanks for the feedback. I have incorporated both your review comments
and have re-tested the patch.
I'll submit the patch for approval.

Warm Regards,
Shankar


On Tue, Feb 19, 2013 at 7:08 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Good job fixing the bug.  :)
>
> My one concern would be that in set_name() there is a race caused
> by dropping the lock.  It would be better to do that
> copy_from_user() first, before taking the lock.  I don't expect this
> to actually be a problem in real life.
>
> +       /*
> +        * Local variable to hold the name copied from user space
> +        * This variable is approx of size 270 bytes, not huge
> +        */
> +       char local_name[ASHMEM_NAME_LEN];
>
> These obvious comments are not needed.  We trust you do not overflow
> the stack.  ;)  Also it's checked automatically during build.
>
> Looks good generally.
>
> regards,
> dan carpenter
>
