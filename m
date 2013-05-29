Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966840Ab3E2UNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:13:16 -0400
Received: from muin.pair.com ([209.68.1.55]:58159 "EHLO muin.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966699Ab3E2UMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1369842679-9680-1-git-send-email-mark.langsdorf@calxeda.com>
Date: Wed, 29 May 2013 15:12:52 -0500
Message-ID: <CAOZdJXUHb1Kbu=LoqUgKA3_EMjPU3Q1KrZ-pENb-0Siym8_Pvw@mail.gmail.com>
Subject: Re: [PATCH] ata: increase retry count but shorten duration for
 Calxeda controller
From: Timur Tabi <timur@tabi.org>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 10:51 AM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
>
>  {
> -       const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
> +       unsigned long timing[] = { 5, 100, 500};


You didn't address my comments the last time you posted this.  I'll
post them again:


Why are you dropping the 'const'?

Assuming it works, this should be more efficient:

static const unsigned long timing[] = {5, 100, 500};
