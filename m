Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaIXWGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 18:06:09 -0400
Received: from lists.s-osg.org ([54.187.51.154]:37572 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbaIXWGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 18:06:08 -0400
Message-ID: <5423404B.2050400@osg.samsung.com>
Date: Wed, 24 Sep 2014 16:06:03 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Davidlohr Bueso <dave@stgolabs.net>
CC: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH v2 1/7] selftests: add kselftest framework for uniform
 test reporting
References: <cover.1411506121.git.shuahkh@osg.samsung.com> <0b1961bd4d2104beafd2e8c1a17690f6efe14a61.1411506121.git.shuahkh@osg.samsung.com> <1411546144.30630.10.camel@linux-t7sj.site>
In-Reply-To: <1411546144.30630.10.camel@linux-t7sj.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2014 02:09 AM, Davidlohr Bueso wrote:

>> +/* counters */
>> +static int ksft_pass;
>> +static int ksft_fail;
>> +static int ksft_xfail;
>> +static int ksft_xpass;
>> +static int ksft_xskip;
> 
> unsigned int?

Yes unsigned int is a better choice.

> 
>> +static inline void ksft_inc_pass_cnt(void) { ksft_pass++; }
>> +static inline void ksft_inc_fail_cnt(void) { ksft_fail++; }
>> +static inline void ksft_inc_xfail_cnt(void) { ksft_xfail++; }
>> +static inline void ksft_inc_xpass_cnt(void) { ksft_xpass++; }
>> +static inline void ksft_inc_xskip_cnt(void) { ksft_xskip++; }
> 
> It would probably make sense to have the counters in a structures,
> something like: struct ksft_counter { ... } ksft_cnt;
> 
> Then just pass it around the proposed functions as arguments. That also
> minimizes a bit the global variables and would allow you to easily
> change it in the future.

How does the following look?

struct ksft_count
{
        unsigned int ksft_pass;
        unsigned int ksft_fail;
        unsigned int ksft_xfail;
        unsigned int ksft_xpass;
        unsigned int ksft_xskip;
};

static ksft_count ksft_cnt;

static inline void ksft_inc_pass_cnt(void) { ksft_cnt.ksft_pass++; }
static inline void ksft_inc_fail_cnt(void) { ksft_cnt.ksft_fail++; }
static inline void ksft_inc_xfail_cnt(void) { ksft_cnt.ksft_xfail++; }
static inline void ksft_inc_xpass_cnt(void) { ksft_cnt.ksft_xpass++; }
static inline void ksft_inc_xskip_cnt(void) { ksft_cnt.ksft_xskip++; }

With this approach, tests don't have to define their own counter
variable and pass it in. I am looking to abstract the framework
as much as possible.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
