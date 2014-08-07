Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbaHGPh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:37:29 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47421 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:37:28 -0400
Message-ID: <53E39D2D.1060202@linux.vnet.ibm.com>
Date: Thu, 07 Aug 2014 17:37:17 +0200
From: "Thierry Fauck@linux.vnet.ibm.com" <thierry@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avagin@openvz.org, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Some systems have a dynamic PAGE_SIZE value and do not
 add a definition for PAGE_SIZE. This value will have to be retrieved using
 getpagesize() or sysconf().
References: <1407324866-3548-1-git-send-email-thierry@linux.vnet.ibm.com> <20140806130647.5f94c95c9621dc7d69501641@linux-foundation.org>
In-Reply-To: <20140806130647.5f94c95c9621dc7d69501641@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080715-8372-0000-0000-000000C4BD42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2014 10:06 PM, Andrew Morton wrote:
> On Wed,  6 Aug 2014 13:34:26 +0200 Thierry FAUCK - IBM LTC <thierry@linux.vnet.ibm.com> wrote:
>
>> --- a/tools/testing/selftests/ptrace/peeksiginfo.c
>> +++ b/tools/testing/selftests/ptrace/peeksiginfo.c
>> @@ -31,6 +31,10 @@ static int sys_ptrace(int request, pid_t pid, void *addr, void *data)
>>  #define TEST_SICODE_PRIV	-1
>>  #define TEST_SICODE_SHARE	-2
>>  
>> +#ifndef PAGE_SIZE
>> +#define PAGE_SIZE sysconf(_SC_PAGESIZE)
>> +#endif
>> +
>>  #define err(fmt, ...)						\
>>  		fprintf(stderr,					\
>>  			"Error (%s:%d): " fmt,			\
> More details, please.  What are "some systems"?
>
Sorry, about that "common description".
A more appropriate one could be : On IBM powerpc where multiple page
size value are supported, current ppc64 and ppc64el distro don't define
the PAGE_SIZE variable in /usr/include as this is a dynamic value
retrieved by the getpagesize() or sysconf() defined in unistd.h. The
PAGE_SIZE variable sounds defined when only one value is supported by
the kernel.
As such, when the PAGE_SIZE definition doesn't exist system should
retrieve the dynamic value.

Is that a better explanation ?

-- 
Thierry Fauck @ linux.vnet.ibm

