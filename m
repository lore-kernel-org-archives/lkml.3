Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaIYNeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:34:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaIYNeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:34:08 -0400
Message-ID: <542419CB.3090902@suse.cz>
Date: Thu, 25 Sep 2014 15:34:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Behan Webster <behanw@converseincode.com>
CC: ak@linux.intel.com, yamada.m@jp.panasonic.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH] kbuild, LLVMLinux: Add -Werror to cc-option to support
 clang
References: <1411500522-11480-1-git-send-email-behanw@converseincode.com> <5422B3EF.4000800@suse.cz> <5423128D.8070708@converseincode.com>
In-Reply-To: <5423128D.8070708@converseincode.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-24 20:50, Behan Webster wrote:
> On 09/24/14 05:07, Michal Marek wrote:
>> On 2014-09-23 21:28, behanw@converseincode.com wrote:
>>> From: Mark Charlebois <charlebm@gmail.com>
>>>
>>> Clang will warn about unknown warnings but will not return false
>> You mean unknown options, right?
> 2 kinds of options: flags and warnings. clang used to merely warn about 
> unused/unsupported flags/warnings. It now returns errors for unknown 
> flags, but not warnings (unless you specify -Werror).

Ah, unknown warning options. Now I understand.


> Getting clang to error on unused flags wasn't trivial (this change broke 
> a lot of builds apparently). Fortunately we weren't the only ones who 
> wanted it to behave like gcc in this case. I think it's going to be 
> *much* harder to do the same for warnings. The argument given by 
> supporters of the current situation is that if a warning isn't 
> supported, why break the build? *sigh*

I guess the reason to accept unknown warnings opentions is compatibility
with Makefiles with hardcoded gcc-isms. BTW, GCC at some point started
to ignore unknown -Wno-* options, for everyone's good of course. That's
why we ended up with the cc-disable-warning function. If -W* options for
clang need special care, then it might be a good idea to introduce
cc-warning with the conditional -Werror for clang. There are not that
many places where we add warnings, so the patch would be still short.
That way, the possible silent failure is limited only to warning options
with clang, which is not such a big deal.

Michal
