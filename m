Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3GKUts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:49:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:43385 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756613Ab3GKUtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:49:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,647,1367996400"; 
   d="scan'208";a="330066460"
Message-ID: <51DF1A6A.7020803@linux.intel.com>
Date: Thu, 11 Jul 2013 13:49:46 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DE8799.9020904@hitachi.com> <51DED90D.5050205@linux.intel.com> <alpine.LNX.2.00.1307112127530.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307112127530.29788@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 12:29 PM, Jiri Kosina wrote:
> On Thu, 11 Jul 2013, H. Peter Anvin wrote:
> 
>>>> + * The way it is done:
>>>> + *	- add a int3 trap to the address that will be patched
>>>> + *	- sync cores
>>>
>>> You don't need this "sync cores". (and your code didn't) :)
>>
>> I believe you do, lest you get "Frankenstructions".  I believe you don't
>> need the second one, however.  I should dig up my notes on this.
> 
> I found this post from 2010 from you:
> 
> 	http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/01530.html
> 
> If it's still valid and you guys at Intel haven't discovered any reason 
> why that procedure would be invalid, I'll send out v3 with that'd be using 
> exactly this ordering of syncing of the cores.
> 

That is still the latest word as far as I know.

	-hpa


