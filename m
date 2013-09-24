Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab3IXJn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:43:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42882 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3IXJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:43:56 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-4d-52415eda8086
Message-id: <52415ED9.3030407@samsung.com>
Date: Tue, 24 Sep 2013 11:43:53 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>, m.chehab@samsung.com,
        t.figa@samsung.com, kyungmin.park@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/4] media: s5p-tv: Replace mxr_ macro by default dev_
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1379775649-6331-2-git-send-email-m.krawczuk@partner.samsung.com>
 <52405519.3020504@samsung.com> <13162989.WhfDRzW6dg@amdc1032>
In-reply-to: <13162989.WhfDRzW6dg@amdc1032>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xK7q34hyDDE6cVbbYOGM9q8XZpjfs
	FpseX2O1uLxrDptFz4atrBYX18lbnF5zitni8Jt2Vov1M16zOHB6bF5S73Hw3R4mj74tqxg9
	Pm+SC2CJ4rJJSc3JLEst0rdL4Mr40HGKseCaWMXvS8cZGxhbhLoYOTkkBEwkurZ3skHYYhIX
	7q0Hsrk4hASWMkqcPbuIBcL5zCix43A3axcjBwevgJbE3A0mIA0sAqoS10/sZQKx2YAGHVvy
	mRHEFhWIkPhzeh8riM0rICjxY/I9FhBbRMBCYu2Kt2AzmQV+MkpMnnEIbLOwgK/E5fP32SGW
	XWSUuHb2I1g3p4C2xNyD79hBbGYBHYn9rdPYIGx5ic1r3jJPYBSYhWTJLCRls5CULWBkXsUo
	mlqaXFCclJ5rpFecmFtcmpeul5yfu4kREu5fdzAuPWZ1iFGAg1GJh/dCgkOQEGtiWXFl7iFG
	CQ5mJRHeG7aOQUK8KYmVValF+fFFpTmpxYcYmTg4pRoYBWpak9eKTGKc//8Uh5qAqdw1j3fu
	16YxaMzMaGW/E7Axa3a/5pviLzb7Jmhz7xPqUf93+MbJ9PPrqjIt950S6uxfaajzcEXXwhNB
	KZsmb/2Zv6nx1dneE6wXt/LLF4vICfaeO/z3zpsFs1jVnmf7iEXvC723giVk7/JzG1++/fpo
	36TvuSe2f1NiKc5INNRiLipOBAD5Ne6XVQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/23/2013 05:48 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Tomasz,
> 
> On Monday, September 23, 2013 04:50:01 PM Tomasz Stanislawski wrote:
>> Hello,
>> May I ask what is the rationale for this patch?
>> To reduce a few lines of code?
> 
> This patch makes source code more generic-like and easier to follow (mxd_r*

more generic(-like?) - NOT. Using mxr_ macros is a more generic way to produce logs
because one can change only one line to change error format for the whole module.
For example, in case of mxr_ family, a patch adding function name to debug message
would require just a few lines patch. Using in case of dev_ family, one has to
produce 200-lines of highly conflicting patch.

'easier to follow' - MAYBE. I agree that some people may prefer to
see more directly what is happening, but tell me if you really consider line:

mxr_dbg(mdev, "this is debug\n");

as a very confusing and obfuscated piece of code.

COME ON!

Regards,
TS

> macros currently only obfuscate the code and make them harder to read for
> everybody, maybe besides the original driver author ;). Removal of few
> superfluous lines of code is just a bonus.
> 
>> Or to give up possibility of changing message format in just one place?
> 
> For over two and half year (since s5p-tv driver introduction in Feb 2011)
> such change was not needed and it doesn't seem that keeping the code to
> allow such possibility is worth an added code obfuscation.
> 
> Besides you can easily script a change to message format so in practice
> I don't see a real advantage of keeping non-standard messaging macros
> just for easing a potential message format conversion.
> 
>> I could see migrating from mxr_* to pr_* could seen as the fix, but not this.
> 
> Such migration seems to be pointless as you would have to add an extra
> argument to pr_* to not lose the device information.

There is something called pr_fmt. It may help with mentioned issue.

> 



> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
>> Waiting for reply,
>> Tomasz Stanislawski
>>
>>
>> On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
>>> Replace mxr_dbg, mxr_info and mxr_warn by generic solution.
>>>
>>> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/media/platform/s5p-tv/mixer.h           |  12 ---
>>>  drivers/media/platform/s5p-tv/mixer_drv.c       |  47 ++++++-----
>>>  drivers/media/platform/s5p-tv/mixer_grp_layer.c |   2 +-
>>>  drivers/media/platform/s5p-tv/mixer_reg.c       |   6 +-
>>>  drivers/media/platform/s5p-tv/mixer_video.c     | 100 ++++++++++++------------
>>>  drivers/media/platform/s5p-tv/mixer_vp_layer.c  |   2 +-
>>>  6 files changed, 78 insertions(+), 91 deletions(-)
>>>

