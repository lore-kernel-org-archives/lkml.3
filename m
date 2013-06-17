Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3FQLtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:49:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:34862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3FQLts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:49:48 -0400
Message-ID: <51BEF7DA.700@linutronix.de>
Date: Mon, 17 Jun 2013 13:49:46 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, leoli@freescale.com, scottwood@freescale.com,
        Priyanka.Jain@freescale.com
Subject: Re: [PATCH][RFC] kernel/cpu: do not change the cpus_allowed of the
 current task when unplugging cpus
References: <1368699439-13034-1-git-send-email-chenhui.zhao@freescale.com> <20130607090543.GD10280@linutronix.de> <20130609095942.GA8548@localhost.localdomain> <20130614152917.GA8597@linutronix.de> <20130617104832.GA20410@localhost.localdomain>
In-Reply-To: <20130617104832.GA20410@localhost.localdomain>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 12:48 PM, Zhao Chenhui wrote:
> I don't think it is necessary to change the mask. migration_call() invoked by
> the cpu notify "CPU_DYING" will remove all running tasks from the dying cpu.
> Even if the current task is running on the dying cpu, it will be transfered
> to another online cpu. 

I had here hiccups if the task was running on the CPU which should go
down.

> I guess that changing the mask benefits the latency of the system.
> Please correct me.

I don't get this. Lets say your system has CPUs 0-15 and you pin your
application to CPU0. After this application brings CPU15 down it is
allowed to run on CPUs 0-14. This is wrong and has been corrected. The
CPU down mechanism should not affected CPU mask of the application.

> 
> -Chenhui
> 

Sebastian
