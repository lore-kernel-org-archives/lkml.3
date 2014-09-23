Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaIWTAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:00:10 -0400
Received: from nm18-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.115.89]:37286
	"EHLO nm18-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaIWTAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:00:08 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 15:00:08 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s1024; d=rogers.com;
	b=sXg6et3aSJlXM9HHUVYH0PPZkzv4WP6HWJpSwOMgD82m1XVqDjLtRwi9dq/1soY7Wszj3cNunnmQMwkE7IP6vLlaZt7tcxQoQ3OVxPVh3T4SNqNeQKVGYBvQGYJQk4A8I2u51Bt+8kGphLqKbaiTP1fGzfhxgIYMLXxTaVJ5k34=;
X-Yahoo-Newman-Id: 530162.60049.bm@smtp117.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: wdyjPukVM1lEm28bnttXryodm90Rq.bwrmgOBXt7lHO21Oe
 2egYEEshbaMLiW0WU7vto0fsQaOGOx543Xb6feuLx5TPWtJj7fICcdaG2XHo
 zhuLcviAqF2L8TCAJCDQ_3TRKECEV16cy5p7vhWIOxlO6UDe8JRTiYLxiyBX
 xo_vpLYwpD6B..01Kz41.mNey_u0E.E.Z1gZ3c_sxRQluwNZK0L2O75MIr3R
 5o98o8gNg7MtmlTB7mLiOlRK3GWfga1Jr3R0uTojTp1YCGhxD75qiqbHLIeU
 RoF8AIVjfL8SRaiJMT.RVsXI3YgFtgdLVPqALduUKuWV6pxk8DDBo4fqScR5
 EJRPbHU.Vk_kpvPlBx6_GoEct4Rq4pKx7OE0jAfLzkEz0s3poDDocM0GK5rJ
 vU1YuMzgdkznpQ2kxxsexMlslx9BQ9RS8PiLDa5kPcefpDqSomlByxVxoASN
 AW1mzv.1PkG3uGLBaoD3erKgC9pBC8ZbgrcOMDugZt5jzKPSXihnawt3MD2H
 eaLq.dB.tAdtp7go5MjLcgd8CGWT7oIh.CO.2Zx3TWU8f4.Tn_M80IjDKMsC
 e8tMr0KDH3yA8YbgmyMm45Zvf_00yLNeUDp6ZO_WwrcPmtypjWJgf76VQEgu
 D_XHUNNP2B0knR2YOL8DHwyiH8Q--
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
From: Shawn Starr <shawn.starr@rogers.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [3.16-rcX][pciehp][radeon] PCIe HotPlug conflicts with radeon GPU
Date: Tue, 23 Sep 2014 14:53:35 -0400
Message-ID: <1722798.naFc0gpZgU@segfault>
Organization: sh0n.net
User-Agent: KMail/4.14.1 (Linux/3.17.0-0.rc5.git5.2.fc22.1.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <CAErSpo6zLY8RVAHnLe81jjOE8cxGzskjPq3HL7eZVOtC-WF6=w@mail.gmail.com>
References: <2354837.kuMZPK0Y1Q@segfault> <CAErSpo6zLY8RVAHnLe81jjOE8cxGzskjPq3HL7eZVOtC-WF6=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On September 11, 2014 04:26:21 PM Bjorn Helgaas wrote:
> [+cc linux-pci]
> 
> On Sat, Aug 2, 2014 at 10:02 AM, Shawn Starr <shawn.starr@rogers.com> wrote:
> > Hello devs,
> > 
> > There are two issues I am encountering with the PCIe Hotplug driver on my
> > Lenovo Laptop (W500). I note this goes back further than 3.15.
> > 
> > It is noted here:
> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
> > f244d8b623dae7a7bc695b0336f67729b95a9736
> > https://bugzilla.kernel.org/show_bug.cgi?id=79701
> > 
> > And my open bug here:
> > https://bugzilla.kernel.org/show_bug.cgi?id=77261
> > 
> > 1) If I enable the device to use both the integrated and discrete GPU,
> > pciehp will decide to force unload radeon because it puts itself into a
> > power saving state, fails back to the Intel integrated GPU in this case
> > unless I tell radeon.ko to runpm=0 (no power management, then pciehp wont
> > touch it).
> > 
> > 2) If the Radeon GPU resets and you use pci_reset=1 for kernel module
> > option, pciehp decides to force unload radeon even though the GPU is
> > trying to setup after failing.
> > 
> > Kernel I am using right now: 3.16.0-0.rc7.git3.1.fc21.x86_64 (about to
> > boot into snapshot kernel-core-3.16.0-0.rc7.git4.1.fc21.x86_64)
> Hi Shawn,
> 
> Thanks for the report and sorry that it got dropped.  But I see you're
> cc'd on https://bugzilla.kernel.org/show_bug.cgi?id=79701, so you've
> probably seen the work there.  If you can try out the patches I just
> posted, that would be great.
> 
> Bjorn


Hi Bjorn,

I will be testing this in 3.17-rcX if it hits 3.17, otherwise manually patch 
it in.

Thanks,
Shawn


