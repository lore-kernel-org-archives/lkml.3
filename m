Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaB0TEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:04:07 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61220 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbaB0TEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:04:05 -0500
Message-ID: <530F8C21.9070602@linaro.org>
Date: Thu, 27 Feb 2014 11:04:01 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [RFC][PATCH] staging: Fix build issues with new binder API
References: <1393453747-12513-1-git-send-email-john.stultz@linaro.org> <20140227033400.GA31199@kroah.com>
In-Reply-To: <20140227033400.GA31199@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 07:34 PM, Greg KH wrote:
> On Wed, Feb 26, 2014 at 02:29:07PM -0800, John Stultz wrote:
>> The new 64bit binder API causes build issues on 32bit ARM
>> due to the lack of 64bit __get_user_asm_* implementation.
> So no one ever tested this out on ARM?  Really, that seems odd...

Its my bad, I was focused on the 32bit legacy compatibility code in my
testing because the userspace I have only works with that.

Arve actually warned about this in one of his mails, but I mistakenly
thought it was an issue w/ 3.10 and earlier kernels and had since been
addressed.


> Anyway, if you want this to always be on, that's fine with me, your
> choice :)

I think its the best option for now, but wanted to send it out for
comment to see if anyone objected.

I'm about to head for a conference so I'll be offline until around
Monday. While at the conference I'm going to be working with folks to
see if we can't get the real solution (a __get_user_asm_64
implementation) sorted.  But if there are no objections, it might be
best to queue this for staging-next so folks don't hit the issue in the
meantime.

thanks
-john





