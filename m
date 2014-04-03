Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaDCNbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:31:11 -0400
Received: from smtp-out-105.synserver.de ([212.40.185.105]:1083 "EHLO
	smtp-out-019.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751600AbaDCNbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:31:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12092
Message-ID: <533D62CE.5040907@metafoo.de>
Date: Thu, 03 Apr 2014 15:31:58 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Takashi Iwai <tiwai@suse.de>, Arun Shamanna Lakshmi <aruns@nvidia.com>,
        lgirdwood@gmail.com, swarren@wwwdotorg.org, perex@perex.cz,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Songhee Baek <sbaek@nvidia.com>
Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
References: <1396494710-20944-1-git-send-email-aruns@nvidia.com> <s5h4n2asq1o.wl%tiwai@suse.de> <20140403095330.GS14763@sirena.org.uk>
In-Reply-To: <20140403095330.GS14763@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 11:53 AM, Mark Brown wrote:
> On Thu, Apr 03, 2014 at 11:47:15AM +0200, Takashi Iwai wrote:
>
>> I'm a bit late in the game, but I feel a bit uneasy through looking
>> at the whole changes.  My primary question is, whether do we really
>> need to share the same struct soc_enum for the onehot type?  What
>> makes hard to use a struct soc_enum_onehot for them?  You need
>> different individual get/put for each type.  We may still need to
>> change soc_dapm_update stuff, but it's different from sharing
>> soc_enum.
>
> Indeed, I had thought this was where the discussion was heading - not
> looked at this version of the patch yet.
>

It would be nice, but it also requires some slight restructuring. The issue 
we have right now is that there is  strictly speaking a bit of a layering 
violation. The DAPM widgets should not need to know how the kcontrols that 
are attached to the widget do their IO. What we essentially do in 
dapm_connect_mux() (and also dapm_connect_mixer) is an open-coded version of 
the controls get handler. Replacing that by calling the get handler instead 
should allow us to use different structs for enums and onehot enums.

- Lars
