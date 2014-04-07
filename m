Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaDGRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:15:25 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:29270
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbaDGRPW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:15:22 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z579ehz98dI9371Ic89bh936eI103dK1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h17326ah8275bh8275dh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Mon, 7 Apr 2014 10:15:04 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>, <swarren@nvidia.com>,
        <linaro-kernel@lists.linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] cpufreq: remove sysfs link when a cpu != policy->cpu, is
 removed
References: <324f43fc664f51eec355b08b6c2d4cedd2140b4c.1392628861.git.viresh.kumar@linaro.org>
 <1848612.IZFZXgfmHj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1848612.IZFZXgfmHj@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <5b6a0eb5-59d7-43ca-9adc-35c7acd58424@VA3EHSMHS022.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 11:03PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 17, 2014 02:52:11 PM Viresh Kumar wrote:
> > Earlier patch tried to do this but missed this piece of code to fix.
> > 
> > 42f921a cpufreq: remove sysfs files for CPUs which failed to come back after
> > resume
> > 
> > Currently we are getting this on suspend/resume:
> > 
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 877 at fs/sysfs/dir.c:52 sysfs_warn_dup+0x68/0x84()
> > sysfs: cannot create duplicate filename '/devices/system/cpu/cpu1/cpufreq'
> > Modules linked in: brcmfmac brcmutil
> > CPU: 0 PID: 877 Comm: test-rtc-resume Not tainted 3.14.0-rc2-00259-g9398a10cd964 #12
> > [<c0015bac>] (unwind_backtrace) from [<c0011850>] (show_stack+0x10/0x14)
> > [<c0011850>] (show_stack) from [<c056e018>] (dump_stack+0x80/0xcc)
> > [<c056e018>] (dump_stack) from [<c0025e44>] (warn_slowpath_common+0x64/0x88)
> > [<c0025e44>] (warn_slowpath_common) from [<c0025efc>] (warn_slowpath_fmt+0x30/0x40)
> > [<c0025efc>] (warn_slowpath_fmt) from [<c012776c>] (sysfs_warn_dup+0x68/0x84)
> > [<c012776c>] (sysfs_warn_dup) from [<c0127a54>] (sysfs_do_create_link_sd+0xb0/0xb8)
> > [<c0127a54>] (sysfs_do_create_link_sd) from [<c038ef64>] (__cpufreq_add_dev.isra.27+0x2a8/0x814)
> > [<c038ef64>] (__cpufreq_add_dev.isra.27) from [<c038f548>] (cpufreq_cpu_callback+0x70/0x8c)
> > [<c038f548>] (cpufreq_cpu_callback) from [<c0043864>] (notifier_call_chain+0x44/0x84)
> > [<c0043864>] (notifier_call_chain) from [<c0025f60>] (__cpu_notify+0x28/0x44)
> > [<c0025f60>] (__cpu_notify) from [<c00261e8>] (_cpu_up+0xf0/0x140)
> > [<c00261e8>] (_cpu_up) from [<c0569eb8>] (enable_nonboot_cpus+0x68/0xb0)
> > [<c0569eb8>] (enable_nonboot_cpus) from [<c006339c>] (suspend_devices_and_enter+0x198/0x2dc)
> > [<c006339c>] (suspend_devices_and_enter) from [<c0063654>] (pm_suspend+0x174/0x1e8)
> > [<c0063654>] (pm_suspend) from [<c00624e0>] (state_store+0x6c/0xbc)
> > [<c00624e0>] (state_store) from [<c01fc200>] (kobj_attr_store+0x14/0x20)
> > [<c01fc200>] (kobj_attr_store) from [<c0126e50>] (sysfs_kf_write+0x44/0x48)
> > [<c0126e50>] (sysfs_kf_write) from [<c012a274>] (kernfs_fop_write+0xb4/0x14c)
> > [<c012a274>] (kernfs_fop_write) from [<c00d4818>] (vfs_write+0xa8/0x180)
> > [<c00d4818>] (vfs_write) from [<c00d4bb8>] (SyS_write+0x3c/0x70)
> > [<c00d4bb8>] (SyS_write) from [<c000e620>] (ret_fast_syscall+0x0/0x30)
> > ---[ end trace 76969904b614c18f ]---
> > 
> > Fix this by removing sysfs link for cpufreq directory when cpu removed isn't
> > policy->cpu.
> > 
> > Reported-by: Stephen Warren <swarren@nvidia.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> > 
> > Fix for 3.14 only.
> 
> Queued up for 3.14, thanks!

I see this on 3.13 too (in our vendor tree, but I think mainline would
show the behavior as well). It probably worth to add it into the 3.13
stable kernel.

	Sören
> 
> >  drivers/cpufreq/cpufreq.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 08ca8c9..cb003a6 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1323,8 +1323,7 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
> >  	up_read(&policy->rwsem);
> >  
> >  	if (cpu != policy->cpu) {
> > -		if (!frozen)
> > -			sysfs_remove_link(&dev->kobj, "cpufreq");
> > +		sysfs_remove_link(&dev->kobj, "cpufreq");
> >  	} else if (cpus > 1) {
> >  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
> >  		if (new_cpu >= 0) {
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

