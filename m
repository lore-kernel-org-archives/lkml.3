Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbaILAbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 20:31:09 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:60432 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaILAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 20:31:07 -0400
Message-ID: <54123EC8.1040906@lwfinger.net>
Date: Thu, 11 Sep 2014 19:31:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: repeated bugs in new rtl wifi drivers
References: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>	<5412327B.6030000@lwfinger.net> <CAGXu5jJmyyWrsS2EFPT59RjK-np3sqmxe69meecmpicv6BNKrA@mail.gmail.com>
In-Reply-To: <CAGXu5jJmyyWrsS2EFPT59RjK-np3sqmxe69meecmpicv6BNKrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 06:50 PM, Kees Cook wrote:
> On Thu, Sep 11, 2014 at 4:38 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 09/11/2014 05:27 PM, Kees Cook wrote:
>>>
>>> Hi,
>>>
>>> I keep fixing this same bug that keeps showing up in the rtl wifi
>>> drivers. CL_PRINTF keeps getting redefined (incorrectly) instead of
>>> using a correctly fixed global. Is there a way to stop this from
>>> happening again?
>>>
>>> Here are the past three (identical) fixes I've landed:
>>> a3355a62673e2c4bd8617d2f07c8edee92a89b8d
>>> 037526f1ae7eeff5cf27ad790ebfe30303eeebe8
>>> 6437f51ec36af8ef1e3e2659439b35c37e5498e2
>>>
>>> And the buildbot report below seems to show there are more to be made. :)
>>
>>
>> Sorry that I missed your fix. I should have seen it come through Linville's
>> list. I will push your fix through again.
>
> Well, I should clarify: it's not getting unfixed/reverted, but rather,
> it hasn't been consolidated to avoid needing the code again in the
> future. All three of the fixes above are on almost identical header
> files. If we could consolidate them, that would be great, and it would
> keep things much nicer.

The two in staging are there because there was need to have those two driver 
available as quickly as possible. Even though a lot of code is the same as the 
regular tree, there were enough differences that it has taken a lot of work to 
merge those two new drivers into the wireless tree. It is part of that effort 
that ended up effectively reverting your fix for the wireless tree.

My plan is to ultimately eliminate all the CL_SNPRINTF and CL_PRINTF stuff. In 
every case I have seen, the two are paired, thus they can be replaced with a 
simple "pr_info". Now that we are unifying the Realtek and kernel codes, I need 
to check with the Realtek guys.

Larry

