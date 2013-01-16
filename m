Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434Ab3APRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:09:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:4690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab3APRJv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:09:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,480,1355126400"; 
   d="scan'208";a="277681609"
Date: Wed, 16 Jan 2013 09:09:50 -0800
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Joe Perches <joe@perches.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20130116090950.00007e90@unknown>
In-Reply-To: <1358338729.2252.53.camel@rzhang1-mobl4>
References: <1357297965-17839-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1357297965-17839-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<1358338729.2252.53.camel@rzhang1-mobl4>
Organization: OTC
X-Mailer: Claws Mail 3.7.8cvs47 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 20:18:49 +0800
Zhang Rui <rui.zhang@intel.com> wrote:

> > +#include <linux/nmi.h>
> > +  
> drivers/thermal/intel_powerclamp.c: In function ‘clamp_thread’:
> drivers/thermal/intel_powerclamp.c:435:4: error: implicit declaration
> of function ‘local_touch_nmi’ [-Werror=implicit-function-declaration]
> 
> changing to 
> #include <asm/nmi.h>
> fixes the problem.
good catch. I missed this in my .config tests. I had
CONFIG_HARDLOCKUP_DETECTOR on so the problem was not shown. I will send
you an update.

Thanks,

Jacob
