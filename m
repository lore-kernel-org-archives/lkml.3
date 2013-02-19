Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab3BSRSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 12:18:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933005Ab3BSRSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 12:18:18 -0500
Message-ID: <5123B3D5.1000405@wwwdotorg.org>
Date: Tue, 19 Feb 2013 10:18:13 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-arm-kernel@lists.infradead.org,
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
References: <1360918364-27960-1-git-send-email-hdoyu@nvidia.com> <511E617E.6080206@wwwdotorg.org> <51222BF9.3040802@suse.cz>
In-Reply-To: <51222BF9.3040802@suse.cz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 06:26 AM, Michal Marek wrote:
> On 15.2.2013 17:25, Stephen Warren wrote:
>> On 02/15/2013 01:52 AM, Hiroshi Doyu wrote:
>>> This patch allows kernel source to include those DT
>>> headers. For example:
>>>
>>> + #include <dts/tegra20-car.h>
>>>
>>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
>>> ---
>>>  Makefile |    2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/Makefile b/Makefile
>>> index 0b4bf62..7f54cdb 100644
>>> --- a/Makefile
>>> +++ b/Makefile
>>> @@ -364,7 +364,7 @@ LINUXINCLUDE    := \
>>>  		-I$(srctree)/arch/$(hdr-arch)/include \
>>>  		-Iarch/$(hdr-arch)/include/generated \
>>>  		$(if $(KBUILD_SRC), -I$(srctree)/include) \
>>> -		-Iinclude \
>>> +		-Iinclude -Iarch/$(hdr-arch)/boot \
> 
> Would it be possible to use a new directory for this? At least POWER and
> x86 have several unrelated headers in their arch/*/boot that are only
> meant for the bootstrap code.

The need here is to allow access to headers in
arch/$(hdr-arch)/boot/dts, but passing the directory above that allows
including files as <dts/foo.h> which is nice. That's the rationale for
this patch.

But as I mentioned in other threads, I wonder if we should put the
header files in arch/$(hdr-arch)/boot/dts at all;
Documentation/devicetree/bindings/... would keep the headers adjacent to
the documentation for the bindings themselves, and the headers really
are part of the binding definitions... That would avoid the issue Michal
pointed out, and I think clean up the dtc+cpp include path usage too.

Grant, what are your thoughts?
