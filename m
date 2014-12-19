Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaLST4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:56:43 -0500
Received: from www.linutronix.de ([62.245.132.108]:35745 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaLST4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:56:42 -0500
Date: Fri, 19 Dec 2014 20:56:23 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: [PATCH] tick/powerclamp: Remove tick_nohz_idle abuse
In-Reply-To: <20141219103900.101f6c6d@jacob-VirtualBox>
Message-ID: <alpine.DEB.2.11.1412192054130.17382@nanos>
References: <alpine.DEB.2.11.1412181110110.17382@nanos> <54930EB1.9080309@linux.vnet.ibm.com> <DD415AA12F8FF042BF4EA69DF123C1478AF91730@ORSMSX101.amr.corp.intel.com> <20141218115239.53d17e39@jacob-VirtualBox> <alpine.DEB.2.11.1412182209010.17382@nanos>
 <20141219103900.101f6c6d@jacob-VirtualBox>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Jacob Pan wrote:

> On Thu, 18 Dec 2014 22:12:57 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 18 Dec 2014, Jacob Pan wrote:
> > > OK I agree, also as I mentioned earlier, Peter already has a patch
> > > for consolidated idle loop and remove tick_nohz_idle_enter/exit
> > > call from powerclamp driver. I have been working on a few tweaks to
> > > maintain the functionality and efficiency with the consolidated
> > > idle loop. We can apply the patches on top of yours.
> > 
> > No. This is equally wrong as I pointed out before. The 'unified' idle
> > loop is still fake and just pretending to be idle.
> > 
> In terms of efficiency, the consolidated idle loop will allow turning
> off sched tick during idle injection period. If we just take out the
> tick_nohz_idle_xxx call, the effectiveness of powerclamp is going down
> significantly. I am not arguing the design but from fixing regression
> perspective or short term solution.

There is no perspective. Period.

Its violates every rightful assumption of the nohz_IDLE_* code and
just ever worked by chance. There is so much subtle wreckage lurking
there that the only sane solution is to forbid it. End of story.

Thanks,

	tglx
