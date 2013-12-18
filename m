Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3LRT2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:28:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3LRT2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:28:30 -0500
Message-ID: <52B1F75A.6090403@redhat.com>
Date: Wed, 18 Dec 2013 14:28:26 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        "Chen, Gong" <gong.chen@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down
References: <1384878243-5086-1-git-send-email-prarit@redhat.com> <CANVTcTZo8pN8y7UiSFyGNLWNwRm8nwQyzCFdQJy50z95vV15oQ@mail.gmail.com>
In-Reply-To: <CANVTcTZo8pN8y7UiSFyGNLWNwRm8nwQyzCFdQJy50z95vV15oQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/03/2013 09:48 PM, rui wang wrote:
> On 11/20/13, Prarit Bhargava <prarit@redhat.com> wrote:
> Have you considered the case when an IRQ is destined to more than one CPU? e.g.:
> 
> bash# cat /proc/irq/89/smp_affinity_list
> 30,62
> bash#
> 
> In this case offlining CPU30 does not seem to require an empty vector
> slot. It seems that we only need to change the affinity mask of irq89.
> Your check_vectors() assumed that each irq on the offlining cpu
> requires a new vector slot.
> 

Rui,

The smp_affinity_list only indicates a preferred destination of the IRQ, not the
*actual* location of the CPU.  So the IRQ is on one of cpu 30 or 62 but not both
simultaneously.

If the case is that 62 is being brought down, then the smp_affinity mask will be
updated to reflect only cpu 30 (and vice versa).

P.
