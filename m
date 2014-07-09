Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaGIV4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:56:43 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:59167 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGIV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328574AE@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-5-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F328574AE@ORSMSX114.amr.corp.intel.com>
Date: Wed, 9 Jul 2014 14:56:40 -0700
Message-ID: <CAFQmdRZ0ZKBV2oxq1Re==x96_rrg1u4WAh7WdGe+zvE3dzqo0A@mail.gmail.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 1:47 PM, Luck, Tony <tony.luck@intel.com> wrote:
>                 if (!(flags & MCP_UC) &&
> -                   (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC)))
> +                   (m.status & (mca_cfg.ser ? MCI_STATUS_S : MCI_STATUS_UC))) {
> +                       spin_unlock_irqrestore(&mce_banks[i].poll_spinlock,
> +                                              irq_flags);
>                         continue;
> +               }
>
> Perhaps move this test for UC up to before you grab the lock?

Will do, thanks.

Havard
