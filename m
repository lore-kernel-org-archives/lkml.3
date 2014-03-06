Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaCFPZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:25:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43709 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751169AbaCFPZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:25:35 -0500
Date: Thu, 6 Mar 2014 15:24:58 +0000
From: Will Deacon <will.deacon@arm.com>
To: AKASHI Takahiro <takahiro.akashi@linaro.org>
Cc: "wad@chromium.org" <wad@chromium.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] arm64: Add seccomp support
Message-ID: <20140306152458.GG5202@mudshark.cambridge.arm.com>
References: <1391767892-5395-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320025-2855-3-git-send-email-takahiro.akashi@linaro.org>
 <20140228172006.GF30996@mudshark.cambridge.arm.com>
 <5317DEC6.4060103@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5317DEC6.4060103@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 02:34:46AM +0000, AKASHI Takahiro wrote:
> On 03/01/2014 02:20 AM, Will Deacon wrote:
> > On Tue, Feb 25, 2014 at 09:20:24AM +0000, AKASHI Takahiro wrote:
> > I'm slightly surprised that we do the secure computing check first. Doesn't
> > this allow a debugger to change the syscall to something else after we've
> > decided that it's ok?
> 
> To be honest, I just followed other architectures' implementation.
> Can you elaborate any use case that you have in your mind?

My initial thought was that we should do the secure_computing check *after*
the debugger has finished messing around with the registers. However, I
suppose you'd have had to enable ptrace in your seccompd filter for that
scenario to occur, so there's probably not an issue here after all.

Will
