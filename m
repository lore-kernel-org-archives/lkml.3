Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751077Ab3HSHAu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:00:50 -0400
Received: from gw1.transmode.se ([195.58.98.146]:52771 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab3HSHAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:00:48 -0400
MIME-Version: 1.0
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: <20130818205713.GA32563@kroah.com>
References: <20130818205713.GA32563@kroah.com>,
	<OF4D0C0FB6.A839872C-ONC1257BCB.004FDEBA-C1257BCB.004FDEBC@transmode.se>
Subject: Re: High load which eventually leads to lockup
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <OF825BE505.E28A86C5-ONC1257BCC.002685F1-C1257BCC.002685F2@transmode.se>
Date: Mon, 19 Aug 2013 09:00:46 +0200
X-Mailer: Lotus Domino Web Server Release 8.5.3FP1 March 07, 2012
X-MIMETrack: Serialize by Notes Server on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 19/08/2013 09:00:46,
	Serialize complete at 19/08/2013 09:00:46,
	Serialize by Router on mail1/Transmode(Release 8.5.3FP1|March 07, 2012) at
 19/08/2013 09:00:46
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----Greg KH <gregkh@linuxfoundation.org> wrote: -----
> 
> On Sun, Aug 18, 2013 at 04:32:23PM +0200, Joakim Tjernlund wrote: > The last week I have had 4
> lockups which required power on/off. > Before getting there I noticed that the machine was
> getting slow. >  > top reported high load(5-10) but there was no process consuming CPU except >
> for migration/0 which were spicing 100% on and off.  > Ping times went up with a factor of 40
> too. >  > Eventually I got a few entries in the kernel log: > Aug 16 12:40:51 gentoo-jocke
> kernel: Modules linked in: nfnetlink_log nfnetlink bluetooth rfkill sg isofs ipt_MASQUERADE
> iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack
> ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp ip6table_filter ip6_tables iptable_filter
> ip_tables ebtables x_tables autofs4 nfsd dm_crypt vboxnetadp(O) vboxnetflt(O) vboxdrv(O) usbhid
> dm_mod kvm_intel kvm snd_hda_codec_hdmi aesni_intel ablk_helper cryptd xts lrw gf128mul
> snd_hda_codec_realtek ehci_pci ehci_hcd usbcore snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
> snd_page_alloc snd_timer snd microcode usb_common radeon e1000e ttm firmware_class ptp pps_core
> pcspkr > Aug 16 12:40:51 gentoo-jocke kernel: CPU 0  > Aug 16 12:40:51 gentoo-jocke kernel: Pid:
> 2421, comm: X Tainted: G           O 3.9.11 #1 Hewlett-Packard HP Compaq 8200 Elite CMT PC/1494
> The virtual box drivers are a huge mess.  Seriously, I really don't even know how the things are
> able to work at all (virtual table pointers from userspace through to the kernel?)  I spent a
> bunch of time to try to clean them up and get them into mergable state, but without the ability
> to also fix up the userspace side, that ended up being a dead-end.  Can you duplicate the problem
> without these modules loaded?  I'd blame them for any problems you might ever have, given how
> crazy they are.  thanks,  greg k-h 

ok you don't trust them even if I haven't used VirtualBox between failures?
Anyhow, I will unload them, lets hope for the best :)

 Jocke
