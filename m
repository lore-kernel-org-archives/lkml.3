Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757321AbaAJNSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:18:48 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51999 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751562AbaAJNSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:18:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] intel_idle: close avn_cstates array with correct marker
Date: Fri, 10 Jan 2014 14:32:36 +0100
Message-ID: <1676949.y75c76bCzK@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <52CF5402.70106@linux.intel.com>
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com> <5913087.iUSSiA9xVP@vostro.rjw.lan> <52CF5402.70106@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 10, 2014 09:59:30 AM Jiang Liu wrote:
> 
> On 2014/1/9 21:31, Rafael J. Wysocki wrote:
> > On Thursday, January 09, 2014 03:30:27 PM Jiang Liu wrote:
> >> Close avn_cstates array with correct marker to avoid overflow
> >> in function intel_idle_cpu_init().
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> >> Cc: <stable@vger.kernel.org> # 3.13
> > 
> > Why did you mark it for 3.13-stable?  3.13 hasn't been released yet, so this
> > can be pushed for 3.13 still.
> > 
> > Is the problem present in 3.13-rc?  If so, has it been introduced by any
> > recent commits or was it there before?  In which case, do we need this patch
> > in stable as well?
> > 
> > Rafael
> Hi Rafael,
> 	This issue is introduced in 3.13-rc2, and I feel it's too late
> to catch up with 3.13 window, so mark it for 3.13 speculatively.
> 	After more thoughts, I feel this patch should be divided into
> two patches.
> 	One is to temporarily remove the __initdata marker. The other
> is to correctly mark end of avn_cstates array. The second bug should
> be introduced when merging "22e580d intel_idle: Fixed C6 state on
> Avoton/Rangeley processors" with "eba682a intel_idle: shrink states tables".
> 	Should I split it into two?

No need.  I'm going to push your fixes to Linus shortly.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
