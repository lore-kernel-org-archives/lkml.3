Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbaDIUHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:07:42 -0400
Received: from sam.nabble.com ([216.139.236.26]:38435 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933342AbaDIUHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:07:41 -0400
Date: Wed, 9 Apr 2014 13:07:40 -0700 (PDT)
From: Arun S L <aruns@nvidia.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1397074060904-837198.post@n7.nabble.com>
In-Reply-To: <20140409155631.GP6518@sirena.org.uk>
References: <1396656730-30145-1-git-send-email-aruns@nvidia.com> <20140409155631.GP6518@sirena.org.uk>
Subject: Re: [PATCH] ASoC: dapm: Add support for multi register mux
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, Apr 04, 2014 at 05:12:10PM -0700, Arun Shamanna Lakshmi wrote:
> 1. Modify soc_enum struct to handle pointers for reg and mask
> 2. Add dapm get and put APIs for multi register one hot encoded mux
> 3. Update snd_soc_dapm_update struct to support multiple reg update

> If you've got several changes like this it's probably a sign that the
> change ought to be split into a patch series.

> I'm still not seeing any handling of the issues with having invalid
> configurations written to the device during the process of carrying out
> multi register updates; I did raise this with one of the earlier
> versions but don't recall any response.

To handle the invalid configurations in case of a multi register update,
the 'not selected registers' are cleared first and only then 'selected
register'
is set. This is ensured by initializing the snd_soc_dapm_update structure
in the right order inside put_value_enum_onehot API.

> I also think I agree with Takashi on this one - trying to implement this
> without adding an abstraction for the control values is making the code
> more complex than it needs to be, all the conditional paths for _ONEHOT
> aren't pretty (and don't use switches which is the usual idiom for this
> stuff if it's not indirected via functions).

To summarize, I need to add get and put function pointers inside kcontrol
structure and use them during dapm_connect_mux and
dapm_set_mixer_path_status. Then, a separate soc_enum_onehot structure
can be used along with the above patch.

I can probably first submit a patch for adding abstraction to control values
and then submit the change for soc_enum_onehot.

Please correct me if my understanding is wrong. 



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/PATCH-ASoC-dapm-Add-support-for-multi-register-mux-tp835209p837198.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
