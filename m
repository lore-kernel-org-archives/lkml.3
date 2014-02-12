Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaBLJ05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:26:57 -0500
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1039 "EHLO
	smtp-out-003.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055AbaBLJ0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:26:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8388
Message-ID: <52FB3E5C.8040701@metafoo.de>
Date: Wed, 12 Feb 2014 10:26:52 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: broonie@kernel.org, lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        kuninori.morimoto.gx@renesas.com, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH v2 1/3] ASoC: binding: add tdm-slot.txt
References: <1392191112-27028-1-git-send-email-Li.Xiubo@freescale.com> <1392191112-27028-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1392191112-27028-2-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 08:45 AM, Xiubo Li wrote:
> TDM slot:
>
> This specifies audio DAI's TDM slot.
>
> Each entry is has four non-negative integer values in DT:
>         <tx_mask, rx_mask, slots, slot_width>
>
> For instance:
>         simple-slot-info = <0xffffffc 0xffffffc 2 0>;


The current internal API for TDM is very poor, I don't think we want to 
expose that 1 to 1 to the devicetree. Since this means we'd have to support 
that forever. The first thing is that the semantics of 
snd_soc_dai_set_tdm_slot() are very unclear. E.g. some drivers use a zero 
bit for a active slot, some drivers use a 1 bit for a active slot. The 
second thing is that we are not able to specify which channel should be 
mapped to which slot. You can merely specify from/to which slots the CODEC 
should read/write and then it is up to the driver to guess which channel 
should go to which slot. In my opinion a binding that allows to specify a 
explicit mapping of which channel goes to which slot would be much better.

Also those are four different settings. In my opinion they should not be 
expressed in one property, but rather in four. E.g. specifying a tx_mask for 
a rx only device does not make much sense.

- Lars
