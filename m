Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3ETTfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:35:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3ETTfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:35:52 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ZSTTxNyh34AA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=7TU8zCdB22MA:10 a=6rqHouBjAAAA:8 a=QyXUC8HyAAAA:8 a=Cjt9h6emqCp7LdGQ2vsA:9 a=QEXdDO2ut3YA:10 a=TAmEwCHjoHMA:10 a=dGJ0OcVc7YAA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369078550.6828.121.camel@gandalf.local.home>
Subject: Re: [ 094/136 ] e1000e: fix runtime power management transitions
From: Steven Rostedt <rostedt@goodmis.org>
To: jeffrey.t.kirsher@intel.com
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Borislav Petkov <bp@suse.de>, Aaron Brown <aaron.f.brown@intel.com>
Date: Mon, 20 May 2013 15:35:50 -0400
In-Reply-To: <1368855636.2235.136.camel@jtkirshe-mobl>
References: <20130518021557.139113314@goodmis.org>
	 <20130518021656.829696669@goodmis.org> <5197132A.5030308@openvz.org>
	 <1368855636.2235.136.camel@jtkirshe-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-17 at 22:40 -0700, Jeff Kirsher wrote:
> On Sat, 2013-05-18 at 09:35 +0400, Konstantin Khlebnikov wrote:
> > Steven Rostedt wrote:
> > > 3.6.11.4 stable review patch.
> > > If anyone has any objections, please let me know.
> > 
> > I don't think that 3.6.y needs this. That was fix for problem which appeared
> > in 3.8 after some changes in PCI power management code. Probably it depends
> > on these changes. If no one complains about problems we should leave it as is.
> 
> My thoughts are the same as Konstantin, but I would like Bruce Allan to
> weigh in on this since he is the e1000e maintainer.  Since it is late
> Friday night, Bruce probably won't see this until Monday to respond.

Any word on this? I'll wait till tomorrow to do the release. If I don't
hear anything, then I may just remove it.

Thanks,

-- Steve

> 
> > >
> > > ------------------
> > >
> > > From: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > >
> > > [ Upstream commit 66148babe728f3e00e13c56f6b0ecf325abd80da ]
> > >
> > > This patch removes redundant actions from driver and fixes its interaction
> > > with actions in pci-bus runtime power management code.
> > >
> > > It removes pci_save_state() from __e1000_shutdown() for normal adapters,
> > > PCI bus callbacks pci_pm_*() will do all this for us. Now __e1000_shutdown()
> > > switches to D3-state only quad-port adapters, because they needs quirk for
> > > clearing false-positive error from downsteam pci-e port.
> > >
> > > pci_save_state() now called after clearing bus-master bit, thus __e1000_resume()
> > > and e1000_io_slot_reset() must set it back after restoring configuration space.
> > >
> > > This patch set get_link_status before calling pm_runtime_put() in e1000_open()
> > > to allow e1000_idle() get real link status and schedule first runtime suspend.
> > >
> > > This patch also enables wakeup for device if management mode is enabled
> > > (like for WoL) as result pci_prepare_to_sleep() would setup wakeup without
> > > special actions like custom 'enable_wakeup' sign.
> > >
> > > Cc: Bruce Allan<bruce.w.allan@intel.com>
> > > Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> > > Acked-by: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
> > > Tested-by: Borislav Petkov<bp@suse.de>
> > > Tested-by: Aaron Brown<aaron.f.brown@intel.com>
> > > Signed-off-by: Jeff Kirsher<jeffrey.t.kirsher@intel.com>
> > > Signed-off-by: Steven Rostedt<rostedt@goodmis.org>
> > 
> 
> 


