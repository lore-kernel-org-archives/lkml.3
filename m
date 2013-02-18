Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3BRN0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:26:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3BRN02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:26:28 -0500
Message-ID: <51222BF9.3040802@suse.cz>
Date: Mon, 18 Feb 2013 14:26:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC 1/2] Makefile: Add arch/arch/$(hdr-arch)/boot in header
 include path
References: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com> <511E617E.6080206@wwwdotorg.org>
In-Reply-To: <511E617E.6080206@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.2.2013 17:25, Stephen Warren wrote:
> On 02/15/2013 01:52 AM, Hiroshi Doyu wrote:
>> This patch allows kernel source to include those DT
>> headers. For example:
>>
>> + #include <dts/tegra20-car.h>
>>
>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>> ---
>>  Makefile |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 0b4bf62..7f54cdb 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -364,7 +364,7 @@ LINUXINCLUDE    := \
>>  		-I$(srctree)/arch/$(hdr-arch)/include \
>>  		-Iarch/$(hdr-arch)/include/generated \
>>  		$(if $(KBUILD_SRC), -I$(srctree)/include) \
>> -		-Iinclude \
>> +		-Iinclude -Iarch/$(hdr-arch)/boot \

Would it be possible to use a new directory for this? At least POWER and
x86 have several unrelated headers in their arch/*/boot that are only
meant for the bootstrap code.

Michal
