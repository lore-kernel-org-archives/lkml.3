Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaGJR4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 13:56:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:36263 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGJR4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 13:56:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140710162419.GK2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-4-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
	<CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
	<20140710162419.GK2970@pd.tnic>
Date: Thu, 10 Jul 2014 10:56:05 -0700
Message-ID: <CAFQmdRb-qENEhFrEeNzvBrMuBjusZcxvhanTuzL9VmKncv-1Tg@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 9:24 AM, Borislav Petkov <bp@alien8.de> wrote:
> We don't need all that atomicity special fun if we register the reboot
> notifier on the BSP, say from mcheck_init() which is done even pre-SMP.
>
> If that's too early, we can add an initcall or whatever...

OK, will see if I can find a better place for it.

> Also, since this is kexec-only, this all should be nicely enabled only
> on KEXEC kernels. Please use the ifdeffery sparingly :-)
>
> I'm saying that because I'm assuming BIOS will clear those MSRs upon
> warm reset. If it doesn't, then we have a bigger problem.

Even on kexec-enabled kernels, we might be doing a regular BIOS boot.
Is there any way to detect that we're doing a kexec boot and only
clearing the MSRs in that case?

Havard
