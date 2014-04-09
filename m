Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965007AbaDIUbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:31:13 -0400
Received: from smtp-out-075.synserver.de ([212.40.185.75]:1059 "EHLO
	smtp-out-115.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933776AbaDIUbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:31:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1829
Message-ID: <5345AD8B.5050306@metafoo.de>
Date: Wed, 09 Apr 2014 22:28:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com> <5345279F.6070005@metafoo.de> <1397041934.11424.2.camel@AMDC1943> <53452F67.3060400@metafoo.de> <20140409202520.GQ6518@sirena.org.uk>
In-Reply-To: <20140409202520.GQ6518@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 10:25 PM, Mark Brown wrote:
> On Wed, Apr 09, 2014 at 01:30:47PM +0200, Lars-Peter Clausen wrote:
>> On 04/09/2014 01:12 PM, Krzysztof Kozlowski wrote:
>>> On śro, 2014-04-09 at 12:57 +0200, Lars-Peter Clausen wrote:
>>>> On 04/09/2014 09:21 AM, Krzysztof Kozlowski wrote:
>
>>>>> -	buf_size = min(count, (sizeof(buf)-1));
>>>>> +	buf_size = min(count, (size_t)(sizeof(buf)-1));
>
>>>> But shouldn't the type of sizeof already be size_t?
>
>>> Hmmm... yes it should. It looks like a false positive from Sparse so the
>>> commit message should be rather "Suppress" than "Fix".
>
>> I'm pretty sure it is a bug in sparse, we shouldn't suppress those, but
>> rather fix them in sparse itself.
>
> Either that or there's something else going on that hasn't been properly
> understood.  The above just looks completely bogus.
>

I had a look at the sparse code and the problem is that it sets the default 
return type of sizeof according to the type of the host it was compiled on 
(either unsigned int or unsigned long). It can be overwritten by switches like 
-m32, but of course wont work when cross compiling. So if your host system is 
64bit, but your target system is 32bit you'll get that warning.

- Lars
