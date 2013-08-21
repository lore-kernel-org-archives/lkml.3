Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab3HUQXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:23:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:25586 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab3HUQXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:23:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,928,1367996400"; 
   d="scan'208";a="349688166"
Message-ID: <5214E96B.3090009@intel.com>
Date: Wed, 21 Aug 2013 09:23:07 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jerome Marchand <jmarchan@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: add overcommit_kbytes sysctl variable
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com> <1376925478-15506-2-git-send-email-jmarchan@redhat.com> <52124DE7.8070502@intel.com> <5214DB1B.6070803@redhat.com>
In-Reply-To: <5214DB1B.6070803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 08:22 AM, Jerome Marchand wrote:
>> > Instead of introducing yet another tunable, why don't we just make the
>> > ratio that comes in from the user more fine-grained?
>> > 
>> > 	sysctl overcommit_ratio=0.2
>> > 
>> > We change the internal 'sysctl_overcommit_ratio' to store tenths or
>> > hundreths of a percent (or whatever), then parse the input as two
>> > integers.  I don't think we need fully correct floating point parsing
>> > and rounding here, so it shouldn't be too much of a chore.  It'd
>> > probably end up being less code than you have as it stands.
>> > 
> Now that I think about it, that could break user space. Sure write access
> wouldn't be a problem (one can still write a plain integer), but a script
> that reads a fractional value when it expects an integer might not be able
> to cope with it.

You're right.  Something doing FOO=$(cat overcommit_ratio) and then
trying do do arithmetic would just fail loudly.  But, it would probably
fail silently if we create another tunable that all of a sudden returns
0 (when the kernel is not _behaving_ like it is set to 0).

I'm not sure there's a good way out of this without breakage (or at
least confusing) of _some_ old scripts/programs.  Either way has ups and
downs.

The existing dirty_ratio/bytes stuff just annoys me because I end up
having to check two places whenever I go looking for it.

