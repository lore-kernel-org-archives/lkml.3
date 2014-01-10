Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbaAJLSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:18:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11178 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbaAJLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:18:27 -0500
Message-ID: <52CFD7BE.5030907@marvell.com>
Date: Fri, 10 Jan 2014 19:21:34 +0800
From: Nenghua Cao <nhcao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: dpcm: don't do hw_param when BE has
 done	hw_param
References: <1389332195-15900-1-git-send-email-nhcao@marvell.com> <s5htxdcxg0q.wl%tiwai@suse.de>
In-Reply-To: <s5htxdcxg0q.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-10_04:2014-01-10,2014-01-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401100029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 06:55 PM, Takashi Iwai wrote:
> [Corrected mail addresses of both Mark and Liam]
> 
Hi, Takashi:
Thanks for correcting my mistake.
> At Fri, 10 Jan 2014 13:36:35 +0800,
> Nenghua Cao wrote:
>>
>> From: Nenghua Cao <nhcao@marvell.com>
>>
>>     It fixes the following case:
>>     Two FEs connects the same BE; FE1 & BE path has been opened and hw_paramed.
>> At this momment, FE2 & BE path is being opened and hw_paramed. The BE
>> dai will do hw_param again even if it has done hw_param. It is not
>> reasonable.
>> FE1------------>BE
>> FE2-------------^
> 
> What happens if FE2 tries to set up an incompatible hw_params?
> (Through a quick glance, it won't work properly well, too, though...)
> 
If FE2 uses an incompatible param, it will make FE1 doesn't work. Maybe
FE2 works well.
If FE2 uses the same param, BE hw_param function will be called twice
(This is the most happening case).
So we can't get benefits from it.
> 
> Takashi
> 
>>
>> Signed-off-by: Nenghua Cao <nhcao@marvell.com>
>> ---
>>  sound/soc/soc-pcm.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
>> index 891b9a9..ec07e37 100644
>> --- a/sound/soc/soc-pcm.c
>> +++ b/sound/soc/soc-pcm.c
>> @@ -1339,7 +1339,6 @@ static int dpcm_be_dai_hw_params(struct snd_soc_pcm_runtime *fe, int stream)
>>  			continue;
>>  
>>  		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
>> -		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
>>  		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
>>  			continue;
>>  
>> -- 
>> 1.7.0.4
>>
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>

