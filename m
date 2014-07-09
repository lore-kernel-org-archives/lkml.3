Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaGIXBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:01:13 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51698 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaGIXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328574D1@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-7-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F328574D1@ORSMSX114.amr.corp.intel.com>
Date: Wed, 9 Jul 2014 16:01:12 -0700
Message-ID: <CAFQmdRZu8aqiDwL2aaUQUZOGxHj0qYudPz9XU06wAOfZyw3rpA@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86-mce: ensure the MCP timer is not already set in
 the mce_timer_fn.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 2:04 PM, Luck, Tony <tony.luck@intel.com> wrote:
> +       /* Ensure a CMCI interrupt can't preempt this. */
> +       local_irq_save(flags);
>         if (mce_available(__this_cpu_ptr(&cpu_info))) {
>                 machine_check_poll(MCP_TIMESTAMP,
>                                 &__get_cpu_var(mce_poll_banks));
>
> Does this remove the problem that you fixed in part4?  If a CMCI can
> no longer interrupt a poll ... do we really need the locks you added?

It's possible this fixes part of the problem. But I still think
there's a race between multiple CPUs polling shared banks.

Havard
