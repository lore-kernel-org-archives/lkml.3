Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaBUTMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:12:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57590 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457AbaBUTMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:12:30 -0500
Message-ID: <5307A503.1080605@zytor.com>
Date: Fri, 21 Feb 2014 11:12:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: ak@linux.intel.com, linux-tip-commits@vger.kernel.org,
        Joe Mario <jmario@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [tip:x86/asmlinkage] lto: Handle LTO common symbols in module
 loader
References: <1391846481-31491-5-git-send-email-ak@linux.intel.com> <tip-80375980f1608f43b47abc2671456b23ec68c434@git.kernel.org> <87ios99y6u.fsf@rustcorp.com.au>
In-Reply-To: <87ios99y6u.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:11 PM, Rusty Russell wrote:
> tip-bot for Joe Mario <tipbot@zytor.com> writes:
>> Commit-ID:  80375980f1608f43b47abc2671456b23ec68c434
>> Gitweb:     http://git.kernel.org/tip/80375980f1608f43b47abc2671456b23ec68c434
>> Author:     Joe Mario <jmario@redhat.com>
>> AuthorDate: Sat, 8 Feb 2014 09:01:09 +0100
>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Thu, 13 Feb 2014 20:24:50 -0800
>>
>> lto: Handle LTO common symbols in module loader
>>
>> Here is the workaround I made for having the kernel not reject modules
>> built with -flto.  The clean solution would be to get the compiler to not
>> emit the symbol.  Or if it has to emit the symbol, then emit it as
>> initialized data but put it into a comdat/linkonce section.
> 
> Gah, as I said, fix the damn comment!
> 
>>  		case SHN_COMMON:
>> +			/* Ignore common symbols */
>> +			if (!strncmp(name, "__gnu_lto", 9))
>> +				break;
>> +
>>  			/* We compiled with -fno-common.  These are not
> 
> /* Ignore common symbols */ is so bad, it's not even wrong.
> 

Joe, Andi, could one of you submit an incremental patch to clean up this
comment?

	-hpa


