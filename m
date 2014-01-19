Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaASKHW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:07:22 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33443 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaASKHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:07:18 -0500
Message-ID: <52DBA3D4.3090308@gmail.com>
Date: Sun, 19 Jan 2014 18:07:16 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: devel@driverdev.osuosl.org, James Hogan <james.hogan@imgtec.com>,
        andreas.dilger@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add "__attribute__((packed))"
 for the related union
References: <52DA4E6A.1000308@gmail.com> <20140118100547.GS7444@mwanda> <52DA56C2.5010802@gmail.com> <20140118142404.GT7444@mwanda>
In-Reply-To: <20140118142404.GT7444@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2014 10:24 PM, Dan Carpenter wrote:
> On Sat, Jan 18, 2014 at 06:26:10PM +0800, Chen Gang wrote:
>> On 01/18/2014 06:05 PM, Dan Carpenter wrote:
>>> On Sat, Jan 18, 2014 at 05:50:34PM +0800, Chen Gang wrote:
>>>> Unfortunately, not all compilers assumes the structures within a pack
>>>> region also need be packed (e.g. metag), so need add a pack explicitly
>>>> to satisfy all compilers.
>>>>
>>>> The related error (under metag with allmodconfig):
>>>>
>>>>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
>>>>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
>>>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
>>>>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
>>>>
>>>> And originally, all related code used "__attribute__((packed))", so
>>>> still use it instead of '__packed'.
>>>
>>> Use __packed.  Then at least one line will be correct which is better
>>> than nothing.
>>>
>>
>> Hmm... but that will break the 'consistency' (which is not quite good
>> for readers).
>>
>> For me, it will be better to provide another patch to change all
>> "__attribute__((packed))" to "__packed" within this file.
>>
>> What about your ideas?
>>
> 
> In the end, it's not something we care about enough to ask you to redo
> the patch.  But what I'm saying is that you should prefer kernel style
> over local style.  We'll fix the surrounding lines later.
> 

OK, thanks, and also thank James and "./scripts/checkpatch.pl" who/which
also mentioned about it to me.


BTW: this patch is related with another patch which is discussing (so I
have cc that patch to you and Greg too): "if we could sure that it is a
compiler's feature issue, we will skip this patch".


Thanks
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
