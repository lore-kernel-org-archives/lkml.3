Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab3FTKid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:38:33 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:54624 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756915Ab3FTKic convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Thu, 20 Jun 2013 06:38:32 -0400
Message-Id: <51C2F7C102000078000DF504@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 20 Jun 2013 11:38:25 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>
Cc: "John Stultz" <john.stultz@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] xen: disable non-boot VCPUs during
 suspend
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
 <1371655523-15609-2-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1371655523-15609-2-git-send-email-david.vrabel@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.06.13 at 17:25, David Vrabel <david.vrabel@citrix.com> wrote:
> syscore_suspend() and syscore_resume() expect there to be only one
> online CPU.  e.g., hrtimers_resume() only triggers events for the
> current CPU.  Xen's suspend path was leaving all VCPUs online and then
> attempting to fixup problems afterwards (e.g., with an explicit call
> to clock_was_set() to trigger pending high resolution timers).
> 
> Instead, disable non-boot CPUs before calling stop_machine() and
> reenable them afterwards.

In XenoLinux the so called "fast suspend" mode was specifically
added for performance reasons, and it looks like to date pv-ops
only ever supported that mode. So one question is whether
there's going to be any bad performance effect from this.

The other question is that about retaining the use of
stop_machine() then - it seems pretty pointless if you already
bring down all other CPUs.

Jan

