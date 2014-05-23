Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaEWL6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 07:58:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62972 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaEWL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 07:58:51 -0400
Message-ID: <1400846226.25914.16.camel@debian>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Date: Fri, 23 May 2014 19:57:06 +0800
In-Reply-To: <20140523091041.GA21332@pd.tnic>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
	 <537C040E.3040901@jp.fujitsu.com> <1400637782.14703.32.camel@debian>
	 <537C12BC.6080408@jp.fujitsu.com> <1400642398.14703.42.camel@debian>
	 <537C1F24.8000604@jp.fujitsu.com>
	 <3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
	 <1400808739.19982.48.camel@debian> <20140523091041.GA21332@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 11:10 +0200, Borislav Petkov wrote:
> On Fri, May 23, 2014 at 09:32:19AM +0800, Chen Yucong wrote:
> > ...if we reach a timeout, there is very little
> > chance for recovering. Thought. the probability for this situation to
> > happen is very slight, it's not impossible. Indeed, it's hard to know
> > the precise causes for timeout.
OK, we can exclude the timeout. 
Why can not we distribute the clear operations of mces_seen to Per-CPU?
Why must monarch need to help all other CPUs to clean mces_seen? What's
the advantage for this?
Why do we have to discard the property of Per-CPU variable?
Why can not we reduce the processing time of monarch CPU?
... 
> 
> Ok, enough talking, let's close that hole and get on with our lives:
You can safely ignore all messages about this talking.

> 
> There is very little and maybe practically nothing we can do to recover
> from a system where at least one core has reached a timeout during the
> whole monarch cores gathering. So panic when that happens.
> 
Why do you prefer to use "very little" and "maybe practically"?
Do you still not sure about that?


>  	if ((s64)*t < SPINUNIT) {
> -		/* CHECKME: Make panic default for 1 too? */
> -		if (mca_cfg.tolerant < 1)
> +		if (mca_cfg.tolerant <= 1)
If (mca_cfg.tolerant == 2 || mce_cfg.tolerant == 3), what can you do for
it?
>  			mce_panic("Timeout synchronizing machine check over CPUs",
>  				  NULL, NULL);
>  		cpu_missing = 1;
> -- 
> 1.9.0
> 


