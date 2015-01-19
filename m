Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbbASQe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:34:28 -0500
Received: from lists.s-osg.org ([54.187.51.154]:53280 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbbASQe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:34:26 -0500
Message-ID: <54BD3208.1040409@osg.samsung.com>
Date: Mon, 19 Jan 2015 09:34:16 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: linux-kernel@vger.kernel.org, mmarek@suse.cz, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        linux-kbuild@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4/6] kbuild: add a new kselftest_install make target to
 install selftests
References: <1420794375-31881-1-git-send-email-mpe@ellerman.id.au> <1420794375-31881-4-git-send-email-mpe@ellerman.id.au> <54B93DA1.2010601@osg.samsung.com> <1421627747.3787.7.camel@ellerman.id.au>
In-Reply-To: <1421627747.3787.7.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2015 05:35 PM, Michael Ellerman wrote:
> On Fri, 2015-01-16 at 09:34 -0700, Shuah Khan wrote:
>> On 01/09/2015 02:06 AM, Michael Ellerman wrote:
>>> Add a new make target to install kernel selftests. This new target will
>>> build and install selftests.
>>>
>>> The default is just $(objtree)/selftests. This is preferable to
>>> something based on $(INSTALL_MOD_PATH) (which defaults to /), as it
>>> allows a normal user to install the tests. This is similar to the
>>> default behaviour of make headers_install.
>>
>> A normal user can install tests at any location they choose by
>> overriding the default path. For example:
>>
>> INSTALL_MOD_PATH=/tmp make kselftest_install
>>
>> will install under tmp.
> 
> Why default to a directory that most users can't write to? That's not helpful.
> 
> Users who are root can override the path, for example:
> 
> INSTALL_MOD_PATH=/ make kselftest_install
> 
>> The approach I used also ties test installs to kernel release.
>> This addresses an important use-case for kernel developers
>> that want to compare results from release to release.
> 
> Sure, I'm happy to add the kernel release, so the default would be
> $(objtree)/selftests/$(kernel-release)/.
> 
>> The use-case for any user to be able to install tests at
>> any location is addressed by the above example.
> 
> The default should work for most users most of the time, / does not achieve
> that.
> 
>> I would like these two above use-cases continued to be supported,
>> especially the one that tries the test installs to kernel release.
> 
> That's fine, I'm happy to update this to use kernel release. But defaulting to
> / doesn't make sense.
> 

I want to keep the kselftest installs to default to the location
other kernel installs such as firmware and modules default to.
This keep the use-case the same as other kernel installs. As user
can override the location, I don't any problems with this.

For most kernel developers, INSTALL_MOD_PATH is the familiar place
to cleanup kernels and I don't see any reason to change that.

You are welcome to send patches to simply the install process for
the individual tests for the next release. I want individual patches
for each test and a separate patch for the shared logic patch.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
