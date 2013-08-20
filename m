Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab3HTI7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:59:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab3HTI7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:59:01 -0400
Message-ID: <52132FCE.3010304@redhat.com>
Date: Tue, 20 Aug 2013 10:58:54 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: add overcommit_kbytes sysctl variable
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com> <1376925478-15506-2-git-send-email-jmarchan@redhat.com> <52124DE7.8070502@intel.com>
In-Reply-To: <52124DE7.8070502@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 06:55 PM, Dave Hansen wrote:
> On 08/19/2013 08:17 AM, Jerome Marchand wrote:
>> Some applications that run on HPC clusters are designed around the
>> availability of RAM and the overcommit ratio is fine tuned to get the
>> maximum usage of memory without swapping. With growing memory, the
>> 1%-of-all-RAM grain provided by overcommit_ratio has become too coarse
>> for these workload (on a 2TB machine it represents no less than
>> 20GB).
>>
>> This patch adds the new overcommit_kbytes sysctl variable that allow a
>> much finer grain.
> 
> Instead of introducing yet another tunable, why don't we just make the
> ratio that comes in from the user more fine-grained?
> 
> 	sysctl overcommit_ratio=0.2
> 
> We change the internal 'sysctl_overcommit_ratio' to store tenths or
> hundreths of a percent (or whatever), then parse the input as two
> integers.  I don't think we need fully correct floating point parsing
> and rounding here, so it shouldn't be too much of a chore.  It'd
> probably end up being less code than you have as it stands.
> 

Whatever works for me. I did it in that way to be more consistent with
what has already been done for dirty*_ratio/bytes.

Thanks,
Jerome


