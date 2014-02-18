Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaBRQOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:14:16 -0500
Received: from smtp-out-137.synserver.de ([212.40.185.137]:1095 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755610AbaBRQOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:14:15 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 26028
Message-ID: <530386E3.2030405@metafoo.de>
Date: Tue, 18 Feb 2014 17:14:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: broonie@kernel.org, myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        dmitry.torokhov@gmail.com, lgirdwood@gmail.com, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 04/17 v2] ASoC: dapm: Add unlocked version of snd_soc_dapm_sync
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1392736948-26623-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 04:22 PM, Charles Keepax wrote:
> We will often call sync after several functions that require the DAPM
> mutex to be held. Rather than release and immediately relock the mutex
> provide an unlocked function for this situation.
>
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

We should add lockdep_assert() to the unlocked versions to catch broken 
users, but that can be done in a follow-up patch.
