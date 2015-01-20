Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbbATKBE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:01:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:47411 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbbATKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:00:59 -0500
Date: Tue, 20 Jan 2015 11:00:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: mpe@ellerman.id.au, aik@ozlabs.ru, shreyas@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, anton@samba.org,
        svaidy@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
In-Reply-To: <20150120081121.26984.46720.stgit@preeti.in.ibm.com>
Message-ID: <alpine.DEB.2.11.1501201049371.5526@nanos>
References: <20150120081121.26984.46720.stgit@preeti.in.ibm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Preeti U Murthy wrote:
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -675,8 +675,8 @@ static void broadcast_move_bc(int deadcpu)
>  
>  	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
>  		return;
> -	/* This moves the broadcast assignment to this cpu */
> -	clockevents_program_event(bc, bc->next_event, 1);
> +	/* This allows fresh nomination of broadcast cpu */

This comment should explain WHY this enforces the move of the
broadcast to a different cpu. 'Allows' is rather ambiguous.

> +	bc->next_event.tv64 = KTIME_MAX;

Thanks,

	tglx
