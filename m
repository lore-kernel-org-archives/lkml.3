Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061Ab3CZNOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:14:41 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:44972 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3CZNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:39 -0400
Message-ID: <51519F3B.6070201@tilera.com>
Date: Tue, 26 Mar 2013 09:14:35 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrik Austad <haustad@cisco.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: ns2cycles should use __raw_get_cpu_var
References: <514DB895.9010201@tilera.com> <1364282202-8031-1-git-send-email-haustad@cisco.com>
In-Reply-To: <1364282202-8031-1-git-send-email-haustad@cisco.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/26/2013 3:16 AM, Henrik Austad wrote:
> ns2cycles use per_cpu variables, and will, eventually, find its way into
> smp_processord_id(). This is not safe in a preemptible kernel,
> preemption should ideally be disabled.
>
> BUG: using smp_processor_id() in preemptible [00000000] code:
> systemd-modules/367
> caller is ns2cycles+0x40/0xb8
>
> Starting stack dump of tid 367, pid 367 (systemd-modules) on cpu 2 at
> cycle 20969956421
>  frame 0: 0xfffffff70004b860 dump_stack+0x0/0x20 (sp 0xfffffe407993fa90)
>  frame 1: 0xfffffff7006abc28 debug_smp_processor_id+0x1a8/0x1e0 (sp
> 0xfffffe407993fa90)
>  frame 2: 0xfffffff7004d7b40 ns2cycles+0x40/0xb8 (sp 0xfffffe407993fab8)
>  frame 3: 0xfffffff7004dc578 __ndelay+0x38/0x80 (sp 0xfffffe407993fae0)
>
> However, in this case:
>
> - the frequency is the same accross all cores
> - we use the data read-only
> - we do not scale the frequency
>
> Which means that we can use the __raw_get_cpu_var instead.
>
> Signed-off-by: Henrik Austad <haustad@cisco.com>
> ---
>  arch/tile/kernel/time.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)

Thanks - taken into the tile tree!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

