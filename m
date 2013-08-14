Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab3HNUuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:50:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:27055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933083Ab3HNUuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:50:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,879,1367996400"; 
   d="scan'208";a="387214588"
Message-ID: <520BED7A.4000903@intel.com>
Date: Wed, 14 Aug 2013 13:50:02 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Dave Hansen <dave.hansen@linux.intel.com>,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, david@fromorbit.com,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: page fault scalability (ext3, ext4, xfs)
References: <520BB9EF.5020308@linux.intel.com> <20130814194359.GA22316@thunk.org>
In-Reply-To: <20130814194359.GA22316@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 12:43 PM, Theodore Ts'o wrote:
> Thanks dave for doing this comparison.  Is there any chance you can
> check whether lockstats shows anything interesting?
> 
>> Test case is this:
>>
>> 	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c
> 
> One interesting thing about the test case.  It looks like the first
> time through the while loop, the file will need to be extended (since
> it is a new tempfile).  But subsequent times through the list the
> blocks for the file will already be allocated.  If the file is
> prezero'ed ahead of time, so we're only measuring the cost of the
> write page fault, and we take block allocation out of the comparison,
> do we see the same scalability curve?

Would a plain old fallocate() do the trick, or does it actually need
zeros written to it?

