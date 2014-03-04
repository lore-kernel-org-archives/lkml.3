Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaCDBkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:40:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:49666 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755145AbaCDBkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:40:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,582,1389772800"; 
   d="scan'208";a="466044400"
Date: Tue, 4 Mar 2014 09:40:02 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>, Anton Vorontsov <anton@enomsg.org>,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] pstore: reset ftrace_read_cnt at ramoops_pstore_open
Message-ID: <20140304014002.GA10071@lskakaxi-intel>
References: <1393569464-14904-1-git-send-email-shuox.liu@intel.com>
 <CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jLFq-FqXsw4SWuhE-JPzCCecvMdUHbF0_B=S-GODFU1pg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon  3.Mar'14 at 11:45:59 -0800, Kees Cook wrote:
>On Thu, Feb 27, 2014 at 10:37 PM,  <shuox.liu@intel.com> wrote:
>> From: Liu ShuoX <shuox.liu@intel.com>
>>
>> ftrace_read_cnt need to be reset in open to support mutli times
>> getting the records.
>>
>> Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
>> ---
>>  fs/pstore/ram.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
>> index fa8cef2..a5d0cab 100644
>> --- a/fs/pstore/ram.c
>> +++ b/fs/pstore/ram.c
>> @@ -101,6 +101,7 @@ static int ramoops_pstore_open(struct pstore_info *psi)
>>
>>         cxt->dump_read_cnt = 0;
>>         cxt->console_read_cnt = 0;
>> +       cxt->ftrace_read_cnt = 0;
>>         return 0;
>>  }
>
>I think we need a separate function for "clear" for the
>ramoops_context struct. IIUC, we're missing a similar initialization
>in ramoops_probe, which lacks both console_read_cnt=0 and
>ftrace_read_cnt=0. Then both places could call this?
Hi Kees,
Currently, we have only one static ramoops_context named oops_cxt.
*_read_cnt should be initialized to 0 as default. Need we still add
such function for 'clear'?

>
>-Kees
>
>-- 
>Kees Cook
>Chrome OS Security
