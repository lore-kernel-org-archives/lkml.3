Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaFEXG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:06:26 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35768 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaFEXGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:06:22 -0400
MIME-Version: 1.0
In-Reply-To: <5390F5A8.2010202@linux.intel.com>
References: <538CC567.2060305@linux.intel.com>
	<1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com>
	<20140605151633.7dd15e8307cbd3b519ae257b@linux-foundation.org>
	<5390EC1B.3000706@linux.intel.com>
	<5390EF50.3010100@infradead.org>
	<5390F5A8.2010202@linux.intel.com>
Date: Fri, 6 Jun 2014 01:06:21 +0200
Message-ID: <CAFLxGvy7V77BCNSFRM4ZahN2oQW7n5dEoGPBtdNtjduOF-18nA@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
From: Richard Weinberger <richard.weinberger@gmail.com>
To: eric ernst <eric.ernst@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 12:56 AM, eric ernst <eric.ernst@linux.intel.com> wrote:
>
> On 14-06-05 03:29 PM, Randy Dunlap wrote:
>>
>> On 06/05/2014 03:15 PM, eric ernst wrote:
>>>
>>> On 14-06-05 03:16 PM, Andrew Morton wrote:
>>>>
>>>> On Thu,  5 Jun 2014 15:09:17 -0700 eric.ernst@linux.intel.com wrote:
>>>>
>>>>> Create a kernel cmdline parameter, "version_addendum", which can be
>>>>> used to add text to the kernel version that is reported from
>>>>> /proc/version.
>>>>
>>>> why?
>>>
>>> We have a need to keep a single product binary (kernel) across multiple
>>> android devices.  A subset of these platforms are looking for extra
>>> versioning information appended to it, accessible via /proc/version.  Rather
>>> than build multiple otherwise identical kernels with only this extended
>>> versioning as differentiation, we are looking to make this a command line
>>> parameter.  Understandable if there isn't enough value-add for the community
>>> in this patch, but I figured I'd give the patch a shot, as we need this
>>> functionality locally.  Thanks.
>>
>> Please use a newline character every 70-72 characters instead of assuming
>> that all email programs will break that extra long line up into a readable
>> format.  (mine does not.)
>
> Ack - sorry Randy - it was a quick cp / paste from earlier in the thread.
>
>>
>> What software needs to know the version info?  how early does it run?
>> Could it get the version info from 'uname -r' instead of from
>> /proc/version?
>>
>> thanks,
>
> This'll end up being used by a third party customer for tracking particular
> devices, so I'm sure "much, much later" in user space. While I'm sure they
> could use uname instead, the specific request was for /proc/version.


sandpuppy:/home/rw # echo "Windows" > /tmp/version
sandpuppy:/home/rw # mount --bind /tmp/version /proc/version
sandpuppy:/home/rw # cat /proc/version
Windows

-- 
Thanks,
//richard
