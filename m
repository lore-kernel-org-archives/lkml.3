Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaGIVk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:40:58 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:64222 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaGIVk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:40:56 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-4-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
Date: Wed, 9 Jul 2014 14:40:55 -0700
Message-ID: <CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:36 PM, Luck, Tony <tony.luck@intel.com> wrote:
> +       if (!xchg(&reboot_notifier_registered, true))
> +               register_reboot_notifier(&cmci_reboot_notifier);
>
> This is super-safe ... but isn't the xchg() overkill? I thought we serialized bringup
> of other cpus.

Could be. There are spinlocks being taken elsewhere in that path
though, and I'm not sure if I see any downside with the xchg(), unless
this path is actually performance-critical.

Havard
