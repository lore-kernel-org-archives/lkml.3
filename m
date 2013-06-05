Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3FEMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:54:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3FEMyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:54:44 -0400
MIME-Version: 1.0
In-Reply-To: <s5hwqq8u3o1.wl%tiwai@suse.de>
References: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
	<1370410969-15328-4-git-send-email-ming.lei@canonical.com>
	<s5hbo7lrq2a.wl%tiwai@suse.de>
	<CACVXFVNpH2H0wxfmbeVY--Q+1UnNT1rq_Rwr-3ou3Nddq2EWXw@mail.gmail.com>
	<CACVXFVN5L6ZO2nT2o+JVqG-OUu-+ods3wgV=G4imWd7GNM5M6g@mail.gmail.com>
	<s5h1u8gvkh4.wl%tiwai@suse.de>
	<CACVXFVPxJpjViUBHeM3qi_kndwiRc7qf1J-kEqTHE3mL7mpaRQ@mail.gmail.com>
	<s5hwqq8u3o1.wl%tiwai@suse.de>
Date: Wed, 5 Jun 2013 20:54:42 +0800
Message-ID: <CACVXFVMURqYxhNk=H-r2c9WoGUxD6uWWaiPS_4F-fHp-v5fOog@mail.gmail.com>
Subject: Re: [PATCH 3/3] firmware loader: allow distribution to choose default
 search paths
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 5, 2013 at 8:45 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 5 Jun 2013 20:36:19 +0800,
> Ming Lei wrote:
>>
>> On Wed, Jun 5, 2013 at 7:57 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >
>> > Hmm, separating with semicolons isn't so common, but we can live with
>>
>> Looks there are seldom such usage patterns in kernel, so could you let me
>> know which separator is more common?
>
> $PATH uses colon, but I don't know of many others.

OK, will change to colon to keep consistent with $PATH.

>
>> > it.  I thought the previous loop can be kept but just pass each member
>> > to fw_get_file_firmware() unconditionally.  This will reduce the
>> > changes, I guess.  But it's just a matter of taste, here is no
>> > critically hot path, after all.
>>
>> Yes, aother way is to move 'fw_path_para' out of fw_path[], and only
>> let  fw_get_fw_file_from_paths() deal with 'fw_path_para' and
>> CONFIG_FW_CUSTOMIZED_PATH. Looks it is still clean.
>
> Why not just pass all strings to fw_get_fw_file_from_paths(), no
> matter whether it's a single or multiple path strings?
>
> static const char * const fw_path[] = {
>         fw_path_para,
> #ifdef CONFIG_FW_CUSTOMIZED_PATH
>         CONFIG_FW_CUSTOMIZED_PATH,
> #endif
>         "/lib/firmware/updates/" UTS_RELEASE,
>         "/lib/firmware/updates",
>         "/lib/firmware/" UTS_RELEASE,
> };
>
> ....
>
>         for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
>                 /* skip the unset customized path */
>                 if (!fw_path[i][0])
>                         continue;
>                 success = fw_get_fw_file_from_paths(fw_path[i], path, buf);
>                 if (success)
>                         break;
>         }

Good, this approach is very clean, and I will take it, :-)

Thanks,
--
Ming Lei
