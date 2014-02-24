Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBXDHQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:07:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40353 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751422AbaBXDHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:07:14 -0500
Message-ID: <530AB6EA.7090807@marvell.com>
Date: Mon, 24 Feb 2014 11:05:14 +0800
From: Nenghua Cao <nhcao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] asoc: soc-core: fix coccinelle warnings
References: <1392969970-28037-1-git-send-email-nhcao@marvell.com> <20140222025204.GM25940@sirena.org.uk>
In-Reply-To: <20140222025204.GM25940@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-23_03:2014-02-21,2014-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402230211
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 10:52 AM, Mark Brown wrote:
> On Fri, Feb 21, 2014 at 04:06:10PM +0800, Nenghua Cao wrote:
> 
>> --- a/sound/soc/soc-core.c
>> +++ b/sound/soc/soc-core.c
>> @@ -2413,7 +2413,7 @@ struct snd_kcontrol *snd_soc_cnew(const struct snd_kcontrol_new *_template,
>>  	struct snd_kcontrol *kcontrol;
>>  	char *name = NULL;
>>  
>> -	memcpy(&template, _template, sizeof(template));
>> +	memcpy(&template, _template, sizeof(struct snd_kcontrol_new));
>>  	template.index = 0;
>>  
>>  	if (!long_name)
> 
> This looks like a regression - it's better form to use the object name
> rather than the type of the object since this prevents errors if the
> type changes.  What coccinelle was suggesting here was to replace with a
> simple assingment statement rather than change the argument within the
> memcpy(), I think this stops the warning showing because of that issue
> since it makes it harder for coccinelle to figure out that this is a
> memcpy() of the whole object.
> 
Hi, Mark

      I am not familiar with coccinelle. But it isn't reasonable and
convenient to use simple assignment instead of memcpy() here. So let's
retain it. I will submit another patch to fix "Assignment of bool to
0/1" issue. How do you think about it?
