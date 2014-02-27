Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaB0TUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:20:41 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:54006 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaB0TUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:20:39 -0500
Message-ID: <530F9001.8040608@linaro.org>
Date: Thu, 27 Feb 2014 11:20:33 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd.bergmann@linaro.org>
CC: Greg KH <gregkh@linuxfoundation.org>, Colin Cross <ccross@android.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [RFC][PATCH] staging: Fix build issues with new binder API
References: <1393453747-12513-1-git-send-email-john.stultz@linaro.org> <530E6B56.8060405@linaro.org> <201402272015.24077.arnd.bergmann@linaro.org>
In-Reply-To: <201402272015.24077.arnd.bergmann@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 11:15 AM, Arnd Bergmann wrote:
> On Wednesday 26 February 2014, John Stultz wrote:
>> The new 64bit binder API causes build issues on 32bit ARM
>> due to the lack of 64bit __get_user_asm_* implementation.
> It is impossible to implement this. Many have tried before.
>
>> Until that implementation is done, remove the choice for
>> 32bit ARM, automatically enabling the old 32bit binder
>> protocol.
>>
>> This can be reverted once a 64bit __get_user_asm_*
>> implementation is merged.
> I think the best solution is to use __copy_from_user for
> the 64-bit access. You can wrap it in a helper function
> if you want to speed up the native-word-size case.

Ah. Thanks for the context and the tip. Will try to get an appropriate
solution there then.

thanks
-john
