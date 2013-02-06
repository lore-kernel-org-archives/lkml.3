Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3BFAHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 19:07:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:35537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab3BFAHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:07:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,610,1355126400"; 
   d="scan'208";a="287088112"
Message-ID: <51119ED0.3030207@intel.com>
Date: Wed, 06 Feb 2013 08:07:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: torvalds@linux-foundation.org, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: steal writing sem for better performance
References: <1360069915-31619-1-git-send-email-alex.shi@intel.com> <20130205145854.GA30949@gmail.com>
In-Reply-To: <20130205145854.GA30949@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 10:58 PM, Ingo Molnar wrote:
> 
> * Alex Shi <alex.shi@intel.com> wrote:
> 
>> Commit 5a50508 change to rwsem from mutex, that cause aim7 fork_test
>> dropped 50%. Yuanhan liu does a good analysis, find it caused by
>> strict sequential writing. Ingo suggest stealing sem writing from
>> front task in waiting queue. https://lkml.org/lkml/2013/1/29/84
>> So has this patch.
>>
>> In this patch, I just allow writing steal happen when the 
>> first waiter is also writer. Then the performance fully 
>> recovered.
> 
> All the aim7 fork_test performance regression is recovered?

Sure. 100% recovered on my NHM EP, NHM EX, SNB EP 2S and 4S machines.
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks Alex
