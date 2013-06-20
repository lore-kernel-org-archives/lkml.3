Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3FTPlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:41:35 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:21443
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756318Ab3FTPld convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:41:33 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dI9371Ic89bh1431J1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Thu, 20 Jun 2013 08:41:23 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Tony Prisk <linux@prisktech.co.nz>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 0/2] Extend multi_v7_defconfig
References: <1371664384-24974-1-git-send-email-soren.brinkmann@xilinx.com>
 <201306192046.41005.arnd@arndb.de>
 <51C291D0.6000401@monstr.eu>
 <201306201002.01702.arnd@arndb.de>
 <51C2BD00.4000800@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <51C2BD00.4000800@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <5ab196fe-de67-4d75-a722-c084517a948a@CO9EHSMHS003.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:27:44AM +0200, Michal Simek wrote:
> On 06/20/2013 10:02 AM, Arnd Bergmann wrote:
> > On Thursday 20 June 2013, Michal Simek wrote:
> >> On 06/19/2013 08:46 PM, Arnd Bergmann wrote:
> >>> On Wednesday 19 June 2013, Soren Brinkmann wrote:
> >>>> I don't know how much a defconfig is supposed to provide, hence as RFC.
> >>>> This patches are needed for booting Zynq into a minimum ramfs based
> >>>> system with a serial console.
> >>>
> >>> In my opinion we should provide enable all the platform specific drivers
> >>> in the defconfigs, as well as everything needed to boot the system,
> >>> to get proper compile coverage as well as the ability to test changes
> >>> easily. Your patches look good. Michal, would you apply them and
> >>> send another pull request or should I just take them directly?
> >>
> >> Soren asked me 2 days ago if make sense to create zynq defconfig or not.
> >> I just suggested him to better extend this multi_v7_defconfig.
> >> But still question is if we can/should create zynq specific defconfig?
> >> Or are you going to remove all of these platform specific defconfig?
> > 
> > We don't have a consistent policy across platforms at the moment.
> > Traditionally we had multiple defconfigs per platform, in some cases
> > one per board, but moving towards one defconfig per platform at
> > the moment.
> 
> That's what I though but on the other hand in this process
> all these defconfigs should be removed.
> 
> > I guess whether or not to have a separate defconfig for one platform
> > or to use only multi_*_defconfig is a question of how many people
> > would use a zynq_defconfig in practice.
> 
> The point is if you look at zynq users than they will just use this zynq_defconfig
> because they know that it is for zynq and also they don't want to
> compile drivers for other platforms which zynq can't use.
> From distribution point of view they want to use only one image because it is just
> easier.
> 
> Based on this if there is an option to also add just zynq defconfig, I would prefer
> to also add it.
> 
> >> Definitely agree that multi_v7 defconfig should enable everything needed
> >> to boot the system.
> >> Does it also mean that we should also enable all zynq drivers
> >> to get better compile coverage?
> > 
> > I would say yes.
> > 
> > My feeling is that multi_v7_defconfig should enable all hardware
> > support for the platforms in it, and that users would take it
> > as a starting point if they want to have a configuration for
> > an embedded system, disabling everything they don't need.
> 
> I just wanted to be sure because you wrote just drivers for booting
> it means any "minimal" configuration to get it boot not all drivers.
> 
> If you are ok, Soren will prepare also specific zynq defconfig file
> and check if there are any missing drivers which are not enabled for zynq
> for multi_v7. I will collect them in one branch and will send pull request.
I can check. But I don't think it makes too much sense currently. Even
though multi_v7_defconfig targets several SOCs its pretty minimal. I
think there are just a few SOC BSPs and serial drivers selected. Due to
lacking driver support in mainline, a Zynq specific config would not be
that different, IMHO.
But this does hopefully change with growing driver support for Zynq in
mainline.

	Sören


