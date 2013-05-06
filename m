Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3EFPpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:45:49 -0400
Received: from muin.pair.com ([209.68.1.55]:56155 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab3EFPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:45:48 -0400
MIME-Version: 1.0
In-Reply-To: <1367444087-18336-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1367444087-18336-1-git-send-email-mark.langsdorf@calxeda.com>
Date: Mon, 6 May 2013 10:45:45 -0500
Message-ID: <CAOZdJXWBQGjs_eLJ_jdrcp5DYaPgFr50_ZF-eCHzPPMvHYgD-Q@mail.gmail.com>
Subject: Re: [PATCH] ata: increase retry count but shorten duration for
 Calxeda controller
From: Timur Tabi <timur@tabi.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 4:34 PM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
>
> -       const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +       unsigned long timing[] = { 5, 100, 500};


Why are you dropping the 'const'?

Assuming it works, this should be more efficient:

static const unsigned long timing[] = {5, 100, 500};
