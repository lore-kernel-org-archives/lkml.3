Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaKYAtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:49:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:8258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbaKYAtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:49:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="421040359"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Zahari Doychev <zahari.doychev@linux.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Drokin, Oleg" <oleg.drokin@intel.com>,
        "bergwolf@gmail.com" <bergwolf@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Thread-Topic: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Thread-Index: AQHQCBjYoCgzCgGRq0KdjTb3TPiruJxw9gEA//+M9BI=
Date: Tue, 25 Nov 2014 00:48:49 +0000
Message-ID: <0DD3F9E5-6500-4A14-B7AA-B662589807A9@intel.com>
References: <cover.1416853961.git.zahari.doychev@linux.com>
 <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>,<20141124234036.GA4835@mwanda>
In-Reply-To: <20141124234036.GA4835@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-posix initializers are a holdover from Windows, where the compiler doesn't have C99 initializers. We don't need that anymore, so the initializer can indeed be uncommented. 

Cheers, Andreas

> On Nov 24, 2014, at 16:41, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
>> On Mon, Nov 24, 2014 at 07:55:41PM +0100, Zahari Doychev wrote:
>> --- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
>> +++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
>> @@ -784,7 +784,8 @@ lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
>>           unsigned int nsiov, struct iovec *siov, unsigned int soffset,
>>           unsigned int nob)
>> {
>> -    struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
>> +    struct iovec diov = {/*.iov_base = */ (void __user *)dest,
>> +                 /*.iov_len = */ dlen};
>> 
> 
> Why can't we just make the comments into code by removing the /*
> characters?  Remove the cast by declaring the data as __user data to
> begin with instead of declaring it incorrectly and then casting to the
> correct type later.
> 
> Also it's not allowed to send two patches with the exact same subject.
> Also the subject was sucky and too vague anyway.  :)
> 
> regards,
> dan carpenter
> 
