Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKIJZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:25:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46825 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKIJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:25:41 -0500
Message-ID: <545F3307.4000305@gmail.com>
Date: Sun, 09 Nov 2014 17:25:27 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: dmitry.kasatkin@intel.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: mpi: Use "static inline" instead of "extern inline"
 in header file for __GNUC__
References: <545F2C99.4080607@gmail.com> <1415524261.23530.37.camel@perches.com>
In-Reply-To: <1415524261.23530.37.camel@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2014 05:11 PM, Joe Perches wrote:
> On Sun, 2014-11-09 at 16:58 +0800, Chen Gang wrote:
>> In header file, "extern inline" may cause multiple definition, so need
>> change it to "static inline". And also need be quoted  by __GNUC__ for
>> they are as inline functions only for __GNUC__.
> []
>> diff --git a/lib/mpi/mpi-inline.h b/lib/mpi/mpi-inline.h
> []
>> @@ -30,7 +30,7 @@
>>  #define G10_MPI_INLINE_H
>>  
>>  #ifndef G10_MPI_INLINE_DECL
>> -#define G10_MPI_INLINE_DECL  extern inline
>> +#define G10_MPI_INLINE_DECL  static inline
> 
> Why not remove the #define and use static inline
> in the 4 places the #define is currently used?
> 

I just follow the original author's ways, the original author may think
it is useful.

I guess, it may be used by other systems (neither Linux kernel nor gcc).
For another compiler, it may need another syntax for it (although I am
not quite sure about it).

So for safety reason, still keep it no touch, at present.

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
