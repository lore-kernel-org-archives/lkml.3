Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3CTSIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:08:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33987 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3CTSIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:08:30 -0400
Message-ID: <5149FB1A.2030608@ti.com>
Date: Wed, 20 Mar 2013 13:08:26 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: video: omap2: dss: Use PTR_RET function
References: <1363680194-10404-1-git-send-email-gheorghiuandru@gmail.com> <5149A3D0.2010902@ti.com> <5149D95D.2030505@ti.com> <5149EAE7.7040800@ti.com> <5149F9B4.2020400@ti.com>
In-Reply-To: <5149F9B4.2020400@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/20/2013 01:02 PM, Jon Hunter wrote:
> 
> On 03/20/2013 11:59 AM, Tomi Valkeinen wrote:
>> On 2013-03-20 17:44, Jon Hunter wrote:
>>>
>>> On 03/20/2013 06:56 AM, Tomi Valkeinen wrote:
>>>> On 2013-03-19 10:03, Alexandru Gheorghiu wrote:
>>>>> Use PTR_RET function instead of IS_ERR and PTR_ERR.
>>>>> Patch found using coccinelle.
>>>>>
>>>>> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
>>>>> ---
>>>>>  drivers/video/omap2/dss/core.c |    5 +----
>>>>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/omap2/dss/core.c
>>>>> index f8779d4..60cc6fe 100644
>>>>> --- a/drivers/video/omap2/dss/core.c
>>>>> +++ b/drivers/video/omap2/dss/core.c
>>>>> @@ -181,10 +181,7 @@ int dss_debugfs_create_file(const char *name, void (*write)(struct seq_file *))
>>>>>  	d = debugfs_create_file(name, S_IRUGO, dss_debugfs_dir,
>>>>>  			write, &dss_debug_fops);
>>>>>  
>>>>> -	if (IS_ERR(d))
>>>>> -		return PTR_ERR(d);
>>>>> -
>>>>> -	return 0;
>>>>> +	return PTR_RET(d);
>>>>>  }
>>>>>  #else /* CONFIG_OMAP2_DSS_DEBUGFS */
>>>>>  static inline int dss_initialize_debugfs(void)
>>>>>
>>>>
>>>> Thanks. I'll apply to omapdss tree.
>>>
>>> Is this correct? If debugfs_create_file() returns a valid pointer, then
>>> now dss_debugfs_create_file() will return a non-zero value on success. I
>>> don't think this is what you want. A similar case came up recently here [1].
>>
>> Hmm. I don't follow. And I don't understand the post where you referred.

Yes looking at Russell's response I am not sure I following now as it is
also using PTR_RET() and not PTR_ERR(). My eyes deceived me on this one.

Jon
