Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3JRNgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 09:36:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51027 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab3JRNgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 09:36:32 -0400
Date: Fri, 18 Oct 2013 15:36:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Joonas Saarinen <jza@saunalahti.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD Bobcat cpufreq
Message-ID: <20131018133630.GD1007@pd.tnic>
References: <31997499.9414731382102390275.JavaMail.jza@saunalahti.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <31997499.9414731382102390275.JavaMail.jza@saunalahti.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 04:19:49PM +0300, Joonas Saarinen wrote:
> It's promising that the boost state support is "supported and
> active" but the output is still kind of sparse. There's no mention
> about specific turbo states,

could be bug in the tool...

> nor do I get /proc/cpuinfo or that cpupower tool ever to show an
> evidence that the CPU is going to 1333MHz. On Windows CPU-Z showed it
> constantly visiting that state.

You can also try turbostat in tools/power/x86/turbostat/

# ./turbostat -i 1

to give you core freq. readout every second and then pin a workload on
one core in another shell, say kernel build:

$ taskset 1 make

You should be able to see core 0 boosting like in my case:

cor CPU   GHz  TSC
        3.90 4.01
  0   0 4.17 4.01
  1   1 4.17 4.01
  2   2 2.23 4.01
  3   3 2.74 4.01
  4   4 1.83 4.01
  5   5 3.23 4.01
  6   6 1.69 4.01
  7   7 1.43 4.01

cores 0 and 1 go over 4GHz which is their boosted state.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
