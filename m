Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3ENP2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:28:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48798 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3ENP2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:28:36 -0400
Message-ID: <519257FC.8070708@zytor.com>
Date: Tue, 14 May 2013 08:27:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Qiaowei Ren <qiaowei.ren@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        tboot-devel@lists.sourceforge.net,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>, Gang Wei <gang.wei@intel.com>
Subject: Re: [PATCH] x86: add a new SMP bring up way for tboot case
References: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
In-Reply-To: <1368566485-14785-1-git-send-email-qiaowei.ren@intel.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 02:21 PM, Qiaowei Ren wrote:
> tboot provides a better AP wakeup mechanism based on cpu MWAIT
> feature for OS/VMM. With this mechanism, system will boot faster
> and will NOT require VT to be enabled. But it requires that
> OS/VMM must have support it, otherwise system can never boot up.
> 
> Once this mechanism is enabled, tboot will put APs waiting in
> MWAIT loops before launching kernel. kernel can check the new
> flag field in v6 tboot shared page for the hint. If the bit
> TB_FLAG_AP_WAKE_SUPPORT in flag field is set, kernel BSP has
> to write the monitored memory (tboot->ap_wake_trigger) to bring
> APs out of MWAIT loops. The sipi vector should be written in
> tboot->ap_wake_addr before waking up APs.
> 

This really needs a *detailed* specification about the state the CPU is
parked in.  Most BIOSes do in fact park the CPUs in an mwait loop, but
we can't use it because the CPU state they are parked in is ill-defined.

This is a good idea, but please write (or point to) a spec about what
the parked CPU state looks like and how the OS gets control.  From the
*looks* of the code I assume it is entered in 16-bit real mode but then
it is important to know what parts of the register state are well-defined.

> +#define TB_FLAG_AP_WAKE_SUPPORT 0X00000001

Minor nit: please lower-case the hexadecimal x.

	-hpa

