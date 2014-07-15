Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaGON6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:58:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35058 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaGON6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:58:23 -0400
Message-ID: <d51dceebf7efa42ae225a36cce24a9fd.squirrel@www.codeaurora.org>
In-Reply-To: <CADsdr6MCnqCwt8623sB=rpuip4cw7LysT1_1KYzBc7yOahcmZA@mail.gmail.com>
References: <1404743641-16847-1-git-send-email-sviau@codeaurora.org>
    <1404743641-16847-2-git-send-email-sviau@codeaurora.org>
    <CADsdr6MCnqCwt8623sB=rpuip4cw7LysT1_1KYzBc7yOahcmZA@mail.gmail.com>
Date: Tue, 15 Jul 2014 08:58:22 -0500
Subject: Re: [PATCH] drm/msm/mdp5: add support for MDP5 v1.3
From: =?iso-8859-1?Q?=22St=E9phane_Viau=22?= <sviau@codeaurora.org>
To: "divya ojha" <odivya77@gmail.com>
Cc: "Stephane Viau" <sviau@codeaurora.org>, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com
User-Agent: SquirrelMail/1.4.22-4.el6
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi Stephane,
>
> On Mon, Jul 7, 2014 at 8:04 PM, Stephane Viau <sviau@codeaurora.org>
> wrote:
>>
>> MDP5 has several functional blocks (ie: VIG/RGB pipes, LMs, ...).
>> From one revision to another, these blocks' base addresses might
>> change due to the number of instances present in the MDP5 hw.
> ..
>> -static inline uint32_t REG_MDP5_PIPE(enum mdp5_pipe i0) { return
>> 0x00001200 + 0x400*i0; }
>> +static inline uint32_t __offset_PIPE(enum mdp5_pipe idx)
>> +{
>
> ERROR: switch and case should be at the same indent

Note that this file is generated through Envytools>rnn>headergen2 tool.
https://github.com/freedreno/envytools/blob/master/rnn/headergen2.c#L246
does indent the "case" statement one more time than the "switch" line.
If I modify this code, all switch/case statements will get modified in the
generated file, and that's not really what I want to do; I only want to
add a the few lines of code needed for MDP5 v1.3 support.
By the way, a lot of checkpatch warnings/errors are already present for
these generated files.

Thanks,
Stéphane.

>
>> +       switch (idx) {
>> +               case SSPP_VIG0: return (mdp5_cfg->pipe_vig.base[0]);
>> +               case SSPP_VIG1: return (mdp5_cfg->pipe_vig.base[1]);
>> +               case SSPP_VIG2: return (mdp5_cfg->pipe_vig.base[2]);
> ..
>> -static inline uint32_t REG_MDP5_LM(uint32_t i0) { return 0x00003200 +
>> 0x400*i0; }
>> +static inline uint32_t __offset_LM(uint32_t idx)
>> +{
>
> ERROR: switch and case should be at the same indent
>
>> +       switch (idx) {
>> +               case 0: return (mdp5_cfg->lm.base[0]);
>> +               case 1: return (mdp5_cfg->lm.base[1]);
>> +               case 2: return (mdp5_cfg->lm.base[2]);
> ..
>
>> -static inline uint32_t REG_MDP5_DSPP(uint32_t i0) { return 0x00004600 +
>> 0x400*i0; }
>> +static inline uint32_t __offset_DSPP(uint32_t idx)
>> +{
>
> ERROR: switch and case should be at the same indent
>
>> +       switch (idx) {
>> +               case 0: return (mdp5_cfg->dspp.base[0]);
>> +               case 1: return (mdp5_cfg->dspp.base[1]);
>> +               case 2: return (mdp5_cfg->dspp.base[2]);
>> +               case 3: return (mdp5_cfg->dspp.base[3]);
> ..
>> -static inline uint32_t REG_MDP5_INTF(uint32_t i0) { return 0x00012500 +
>> 0x200*i0; }
>> +static inline uint32_t __offset_INTF(uint32_t idx)
>> +{
>
> ERROR: switch and case should be at the same indent
>
>> +       switch (idx) {
>> +               case 0: return (mdp5_cfg->intf.base[0]);
>> +               case 1: return (mdp5_cfg->intf.base[1]);
>> +               case 2: return (mdp5_cfg->intf.base[2]);
> ..
>> -static inline uint32_t REG_MDP5_AD(uint32_t i0) { return 0x00013100 +
>> 0x200*i0; }
>> +static inline uint32_t __offset_AD(uint32_t idx)
>> +{
>
> ERROR: switch and case should be at the same indent
>
>> +       switch (idx) {
>> +               case 0: return (mdp5_cfg->ad.base[0]);
>> +               case 1: return (mdp5_cfg->ad.base[1]);
>> +               default: return INVALID_IDX(idx);
>> +       }
>> +}
> ..
>>  }
>> --
>> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> Forum,
>> hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

