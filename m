Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3BSJWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:22:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42464 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598Ab3BSJWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:22:37 -0500
Message-ID: <5123444D.6000806@suse.cz>
Date: Tue, 19 Feb 2013 10:22:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ebiederm@xmission.com, xemul@parallels.com, hpa@zytor.com,
        akpm@linux-foundation.org, Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [patch 1/2] kcmp: Make it to depend on CONFIG_KCMP
References: <20130219064800.719149796@openvz.org> <20130219065210.030802820@openvz.org>
In-Reply-To: <20130219065210.030802820@openvz.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.2.2013 07:48, Cyrill Gorcunov wrote:
> --- linux-2.6.git.orig/init/Kconfig
> +++ linux-2.6.git/init/Kconfig
> @@ -279,6 +279,15 @@ config FHANDLE
>  	  get renamed. Enables open_by_handle_at(2) and name_to_handle_at(2)
>  	  syscalls.
>  
> +config KCMP
> +	bool "kcmp syscall"
> +	default n

Previously, kcmp was enabled with CONFIG_CHECKPOINT_RESTORE. Maybe
change it to 'default CHECKPOINT_RESTORE', so that make oldconfig does
the right thing?

Michal
