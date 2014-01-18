Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaARK0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 05:26:21 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43068 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaARK0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 05:26:17 -0500
Message-ID: <52DA56C2.5010802@gmail.com>
Date: Sat, 18 Jan 2014 18:26:10 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg KH <gregkh@linuxfoundation.org>, andreas.dilger@intel.com,
        bergwolf@gmail.com, jinshan.xiong@intel.com, oleg.drokin@intel.com,
        jacques-charles.lafoucriere@cea.fr, devel@driverdev.osuosl.org,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda>
In-Reply-To: <20140118100547.GS7444@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 06:05 PM, Dan Carpenter wrote:
> On Sat, Jan 18, 2014 at 05:50:34PM +0800, Chen Gang wrote:
>> Unfortunately, not all compilers assumes the structures within a pack
>> region also need be packed (e.g. metag), so need add a pack explicitly
>> to satisfy all compilers.
>>
>> The related error (under metag with allmodconfig):
>>
>>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
>>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
>>
>> And originally, all related code used "__attribute__((packed))", so
>> still use it instead of '__packed'.
> 
> Use __packed.  Then at least one line will be correct which is better
> than nothing.
> 

Hmm... but that will break the 'consistency' (which is not quite good
for readers).

For me, it will be better to provide another patch to change all
"__attribute__((packed))" to "__packed" within this file.

What about your ideas?


Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
