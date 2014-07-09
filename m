Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaGIXAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 19:00:07 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60197 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527AbaGIXAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 19:00:04 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F328574C3@ORSMSX114.amr.corp.intel.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-6-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F328574C3@ORSMSX114.amr.corp.intel.com>
Date: Wed, 9 Jul 2014 16:00:04 -0700
Message-ID: <CAFQmdRb9vsWyF06jppS5U7Wzuc+SzRgWL+hs5+es-GC=5e_8qg@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86-mce: check if no_way_out applies before deciding
 not to clear MCE banks.
From: Havard Skinnemoen <hskinnemoen@google.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 2:00 PM, Luck, Tony <tony.luck@intel.com> wrote:
> +       if (!(no_way_out && cfg->tolerant < 3))
>                 mce_clear_state(toclear);
>
> Style - I think this is easier to grok:
>
>         if (!no_way_out || cfg->tolerant >=3)
>                 mce_clear_state(toclear);
>
> but not too strongly if other like !(a && b) form.

I tend to agree with you. It came up during our internal review, and
others argued the other way. But since I'm in charge now, I'll change
it back ;-)

> I'm never sure how to treat the crazy levels of "tolerant" though.  Do
> we really want to clear the banks?  In one sense we do ... we are still
> running and might see more UC errors. Since newer UC errors don't
> overwrite older ones, clearing the banks allows us to see how many
> errors are piling up and being ignored.
>
> But running with tolerant==3 is likely to end in tears ... should we erase
> the evidence on what bad things happened?

It probably doesn't make a huge difference since you're not supposed
to run with tolerant=3, but I kind of understood the logic to be that
if we're going to keep running, we need to clear the banks, and if
we're going to crash, we need to leave them intact so whatever runs
next gets a chance to look at them. So with tolerant==3, we are going
to continue running, and I think for debugging purposes, it's useful
to see how many additional errors are happening.

Havard
