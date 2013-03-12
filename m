Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3CLIYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:24:37 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53319 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3CLIYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:24:36 -0400
MIME-Version: 1.0
In-Reply-To: <513EE454.5040302@ti.com>
References: <1363017537-11602-1-git-send-email-silviupopescu1990@gmail.com>
	<513EE454.5040302@ti.com>
Date: Tue, 12 Mar 2013 10:24:35 +0200
Message-ID: <CAPWTe+K1E1Tm1E2B_rnj9x9hvCcUXgi2hg-DQNWHO3uZaVt+Pg@mail.gmail.com>
Subject: Re: [PATCH] omap: convert to devm_ioremap_resource()
From: Silviu Popescu <silviupopescu1990@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-omap@vger.kernel.org, jarkko.nikula@bitmer.com, lgirdwood@gmail.com,
        broonie@opensource.wolfsonmicro.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:16 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi,
>
> On 03/11/2013 04:58 PM, Silviu-Mihai Popescu wrote:
>> Convert all uses of devm_request_and_ioremap() to the newly introduced
>> devm_ioremap_resource() which provides more consistent error handling.
>>
>> devm_ioremap_resource() provides its own error messages so all explicit
>> error messages can be removed from the failure code paths.
>
> I believe both of the drivers has been patched for this:
> omap-mcbpdm:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-February/059484.html
> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-February/059427.html
>
> omap-dmic:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2013-February/059485.html
>
> and they should be already queued for next.

Hello,

As far as I can tell from the mails that you have provided, those
patches replace devm_request_mem_region(), followed by devm_ioremap()
with devm_request_and_ioremap().
What this patch attempts to do is replace devm_request_and_ioremap()
with the newly introduced devm_ioremap_resource(), for the reasons
expressed in the patch body.

Thanks,
Silviu
