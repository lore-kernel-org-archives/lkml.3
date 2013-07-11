Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3GKQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:12:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:21479 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183Ab3GKQMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:12:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="329944350"
Message-ID: <51DED90D.5050205@linux.intel.com>
Date: Thu, 11 Jul 2013 09:10:53 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DE8799.9020904@hitachi.com>
In-Reply-To: <51DE8799.9020904@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 03:23 AM, Masami Hiramatsu wrote:
>> + *
>> + * The way it is done:
>> + *	- add a int3 trap to the address that will be patched
>> + *	- sync cores
> 
> You don't need this "sync cores". (and your code didn't) :)
> 

I believe you do, lest you get "Frankenstructions".  I believe you don't
need the second one, however.  I should dig up my notes on this.

>> + *	- update all but the first byte of the patched range
>> + *	- sync cores
>> + *	- replalace the first byte (int3) by the first byte of
>> + *	  replacing opcode
>> + *	- sync cores
>> + *


