Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FEMgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:36:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3FEMgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:36:22 -0400
MIME-Version: 1.0
In-Reply-To: <s5h1u8gvkh4.wl%tiwai@suse.de>
References: <1370410969-15328-1-git-send-email-ming.lei@canonical.com>
	<1370410969-15328-4-git-send-email-ming.lei@canonical.com>
	<s5hbo7lrq2a.wl%tiwai@suse.de>
	<CACVXFVNpH2H0wxfmbeVY--Q+1UnNT1rq_Rwr-3ou3Nddq2EWXw@mail.gmail.com>
	<CACVXFVN5L6ZO2nT2o+JVqG-OUu-+ods3wgV=G4imWd7GNM5M6g@mail.gmail.com>
	<s5h1u8gvkh4.wl%tiwai@suse.de>
Date: Wed, 5 Jun 2013 20:36:19 +0800
Message-ID: <CACVXFVPxJpjViUBHeM3qi_kndwiRc7qf1J-kEqTHE3mL7mpaRQ@mail.gmail.com>
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

On Wed, Jun 5, 2013 at 7:57 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> Hmm, separating with semicolons isn't so common, but we can live with

Looks there are seldom such usage patterns in kernel, so could you let me
know which separator is more common?

> it.  I thought the previous loop can be kept but just pass each member
> to fw_get_file_firmware() unconditionally.  This will reduce the
> changes, I guess.  But it's just a matter of taste, here is no
> critically hot path, after all.

Yes, aother way is to move 'fw_path_para' out of fw_path[], and only
let  fw_get_fw_file_from_paths() deal with 'fw_path_para' and
CONFIG_FW_CUSTOMIZED_PATH. Looks it is still clean.


>> +             if (strstr(path, ".."))
>> +                     continue;
>
> I expect you'll prepare this path sanity check part in a separate
> patch, right?  It's basically independent from the new kconfig.

Yes, it will be submitted as another patch, also I plan to add
the check on firmware_name in _request_firmware_prepare()
so that the similar problem can be found earlier.

Thanks,
--
Ming Lei
