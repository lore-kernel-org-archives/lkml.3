Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3ETSNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:13:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:40143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab3ETSNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:13:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,709,1363158000"; 
   d="scan'208";a="340644049"
Message-ID: <519A67C9.6000709@linux.intel.com>
Date: Mon, 20 May 2013 11:13:29 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?RmVybmFuZG8gTHVpcyBWw6F6cXVleiBDYW8=?= 
	<fernando@oss.ntt.co.jp>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        the arch/x86 maintainers <x86@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "x86-64, init: Do not set NX bits on non-NX capable
 hardware"
References: <20130514160108.GA5055@dhcp22.suse.cz> <1369062192-7066-1-git-send-email-mhocko@suse.cz> <519A483F.7070400@zytor.com> <20130520164335.GA9441@dhcp22.suse.cz> <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
In-Reply-To: <CA+55aFzxdGOW=7-x+41U4SZB5par7jKU9vuuhFdsQfZOuLiLtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 10:21 AM, Linus Torvalds wrote:
> On Mon, May 20, 2013 at 9:43 AM, Michal Hocko <mhocko@suse.cz> wrote:
>>
>> The configuration has been posted in the referenced thread:
>> https://lkml.org/lkml/2013/5/14/398
> 
> Hmm. That's a regular intel i5 Sandybridge CPU. Which certainly has NX.
> 
> Hmm. secondary_startup_64 isn't __initcode, is it? I think it's used
> for resuming the other CPU's too and for CPU hotplug. Yes/no?
> 
> If so early_pmd_flags shouldn't be __initdata, I think.
> 
> Michal, does it work if you don't do the revert, but just remove the
> __initdata instead?
> 

Indeed.  Looks like we corrupt a random bit in memory on resume.

	-hpa

