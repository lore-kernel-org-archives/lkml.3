Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaHUIGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:06:09 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:57886 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbaHUIGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:06:00 -0400
Message-ID: <53F5A864.5040206@suse.cz>
Date: Thu, 21 Aug 2014 10:05:56 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: stable@vger.kernel.org, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 3.12 000/104] 3.12.27-stable review
References: <cover.1408535000.git.jslaby@suse.cz> <20140820165459.GA21275@roeck-us.net> <20140820195436.GA22902@roeck-us.net>
In-Reply-To: <20140820195436.GA22902@roeck-us.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014, 09:54 PM, Guenter Roeck wrote:
> On Wed, Aug 20, 2014 at 09:54:59AM -0700, Guenter Roeck wrote:
>> On Wed, Aug 20, 2014 at 01:43:51PM +0200, Jiri Slaby wrote:
>>> This is the start of the stable review cycle for the 3.12.27 release.
>>> There are 104 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri Aug 22 13:43:20 CEST 2014.
>>> Anything received after that time might be too late.
>>>
>> Build results look good:
>> 	total: 135 pass: 135 fail: 0
>>
>> qemu tests passed except for sparc64 which hangs during boot, both for SMP and
>> non-SMP builds. I'll try to bisect as soon as I have a somewhat stable internet
>> connection.
>>
> Bisect result:
> 
> # bad: [c07d9e5da83f1470ccc58d37fe222dab36dbca67] drivers/rtc/interface.c: fix infinite loop in initializing the alarm
> # good: [d83a3234d2e1e2a55e7f2430fc9ca29a9bd315e7] Linux 3.12.26
> git bisect start 'HEAD' 'v3.12.26'
> # bad: [0d543dade2be5f0ddb268c6d6ea0e86938e3bf42] sparc64: Add membar to Niagara2 memcpy code.
> git bisect bad 0d543dade2be5f0ddb268c6d6ea0e86938e3bf42
> # good: [6e1af05639abfc6f1841e6bf8b5c8492971ed1f2] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
> git bisect good 6e1af05639abfc6f1841e6bf8b5c8492971ed1f2
> # good: [6a25e8f778995cabb0cfe2acb3247e3b42dec35f] macvlan: Initialize vlan_features to turn on offload support.
> git bisect good 6a25e8f778995cabb0cfe2acb3247e3b42dec35f
> # good: [bf42f839476f1f447ca696fbbab7e741861d9d7d] sparc64: Fix executable bit testing in set_pmd_at() paths.
> git bisect good bf42f839476f1f447ca696fbbab7e741861d9d7d
> # bad: [6acda98c75b536deaba1bf21f93411fcc484fbb5] sparc64: Add basic validations to {pud,pmd}_bad().
> git bisect bad 6acda98c75b536deaba1bf21f93411fcc484fbb5
> # good: [a91ce41d405b3cc59d6666ec91a5a3235f9cbcf6] sparc64: Fix top-level fault handling bugs.
> git bisect good a91ce41d405b3cc59d6666ec91a5a3235f9cbcf6
> # first bad commit: [6acda98c75b536deaba1bf21f93411fcc484fbb5] sparc64: Add basic validations to {pud,pmd}_bad().
> 
> Reverting the offending patch ('Add basic validations ...') fixes the problem.

Hi,

thanks for the work!

Just note on patches, in 3.12, there are all 3.10 patches plus these three:
+sparc64-add-basic-validations-to-pud-pmd-_bad.patch
+sparc64-fix-executable-bit-testing-in-set_pmd_at-paths.patch
+sparc64-give-more-detailed-information-in-pgd-pmd-_error-and-kill-pte_error.patch

where the third adds only printouts.

These 3.14 patches are not applied to 3.12:
+sparc64-don-t-use-_page_present-in-pte_modify-mask.patch
+sparc64-fix-bugs-in-get_user_pages_fast-wrt.-thp.patch
+sparc64-fix-huge-pmd-invalidation.patch
+sparc64-fix-hex-values-in-comment-above-pte_modify.patch
+sparc64-fix-range-check-in-kern_addr_valid.patch
+sparc64-use-ilog2_4mb-instead-of-constant-22.patch

The last three are just cosmetical in 3.12. And I do not immediately see
in the rest, how they could improve the state. So I am going to remove
the add-basic-validations patch from 3.12.

thanks,
-- 
js
suse labs
