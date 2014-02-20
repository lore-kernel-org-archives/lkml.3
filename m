Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbaBTSSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:18:00 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57508 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaBTSR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:17:57 -0500
MIME-Version: 1.0
In-Reply-To: <53063F09.9000102@free-electrons.com>
References: <53063F09.9000102@free-electrons.com>
Date: Thu, 20 Feb 2014 19:17:56 +0100
X-Google-Sender-Auth: llR2FvZCHchjtPFx1U8AIsLeYOI
Message-ID: <CAAsK9AGpuxCvQ_m+dJh_T72dHGaU3TU6AgSyWdf5YtzzJx==Vw@mail.gmail.com>
Subject: Re: How to get rid of IRQF_DISABLED for good?
From: Levente Kurusa <levex@linux.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-20 18:44 GMT+01:00 Michael Opdenacker
<michael.opdenacker@free-electrons.com>:
> Hi,
>
> In spite of the patches I have been sending (and resending!) over the
> past months, there are still 118 occurrences of the idle IRQF_DISABLED
> flag in the kernel code. This corresponds to 31 patches which haven't
> been accepted yet.
>
> What would you advise to get rid of IRQF_DISABLED for good?
>
>   * Send a treewide patch removing the last occurrences in one shot,
>     bypassing the regular maintainers? Who could take it?

Andrew Morton would take it to his -mm tree.
This, IMO, seems to be the best solution to circumvent unresponsive/uncaring
maintainers.

>   * Remove the definition of IRQF_DISABLED to force the individual
>     maintainers (and out of tree drivers!) to update their code? It
>     could be a way of seeing which code isn't maintained any more ;)

No, every single patch has to be 'bisectable' meaning that when you bisect
you should be able to build every single patch as is.

>   * Continue to resend the patches for a few more cycles, until the
>     corresponding maintainers can no longer bear the discredit?

Maybe once more, if they don't reply, send it to Andrew Morton as well
and CC a few people who know your work is good so that they can ACK it.

Oh and maybe you could add an __attribute__((deprecated)) to it, but
I am not sure that's possible and/or correct.


--
Regards,
Levente Kurusa
