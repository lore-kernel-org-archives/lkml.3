Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbaKAUXz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:23:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:47490 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825AbaKAUXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:23:54 -0400
Date: Sat, 1 Nov 2014 21:23:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Custer <jcuster@sgi.com>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86: UV BAU Increase maximum CPUs per socket/hub
In-Reply-To: <1414792180-102802-1-git-send-email-jcuster@sgi.com>
Message-ID: <alpine.DEB.2.11.1411012121350.5308@nanos>
References: <1414792180-102802-1-git-send-email-jcuster@sgi.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, James Custer wrote:

> We have encountered hardware with 18 cores/socket that gives 36 CPUs/socket
> with hyperthreading enabled. This exceeds the current MAX_CPUS_PER_SOCKET
> causing a failure in get_cpu_topology. Increase MAX_CPUS_PER_SOCKET to 64
> and MAX_CPUS_PER_UVHUB to 128.
> 
> Additionally, this exposed another bug. When get_cpu_topology fails, we
> need to make sure that we do not use bau_control->statp (e.g. when a
> user reads /proc/sgi_uv/ptc_statistics causing ptc_seq_show to be
> invoked). In uv_bau_init we call set_bau_off() when
> init_per_cpu()->get_cpu_topology() fails -- therefore, to avoid
> referencing a NULL pointer we add code that detects when the bau is off
> and print out the bau is disabled.

Can you please split this in two patches. One fixing the ptc_seq_show
bug and the other increasing the constants. 
 
If someone looks for a fix for the ptc_seq_show wreckage he definitly
is not going to look at a patch which increases the number of cpus per
socket.

Thanks,

	tglx
