Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab3GPWIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 18:08:42 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57354 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab3GPWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 18:08:40 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Ingo Molnar <mingo@kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: next-20130709 DMAR issues
In-Reply-To: Your message of "Fri, 12 Jul 2013 14:14:20 +0200."
             <20130712121419.GA22945@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <29624.1373475702@turing-police.cc.vt.edu>
            <20130712121419.GA22945@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1374012421_1500P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 16 Jul 2013 18:07:01 -0400
Message-ID: <21949.1374012421@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1374012421_1500P
Content-Type: text/plain; charset=us-ascii

On Fri, 12 Jul 2013 14:14:20 +0200, Ingo Molnar said:
>
> (Cc:-ed a few DMAR people.)

Sorry for the slow reply, missed this in the lkml firehose.

For whatever reason, the damned problem seems to have evaporated:

% egrep -i 'dmar|Linux vers' /var/log/messages-20130714
....
Jul 11 18:54:15 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130709 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #100 SMP PREEMPT Tue Jul 9 16:01:59 EDT 2013
Jul 11 18:54:15 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
Jul 11 18:54:15 turing-police kernel: [    0.021632] dmar: Host address width 36
Jul 11 18:54:15 turing-police kernel: [    0.021638] dmar: DRHD base: 0x000000fed90000 flags: 0x1
Jul 11 18:54:15 turing-police kernel: [    0.021669] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
Jul 11 18:54:15 turing-police kernel: [    0.021677] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
Jul 11 18:54:15 turing-police kernel: [    0.021775] dmar: DRHD: handling fault status reg 2
Jul 11 18:54:15 turing-police kernel: [    0.021782] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr ce71d000
Jul 11 18:54:15 turing-police kernel: [    0.021782] DMAR:[fault reason 06] PTE Read access is not set
Jul 11 18:54:15 turing-police kernel: [    1.002171] DMAR: No ATSR found
Jul 11 22:12:39 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130709 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #100 SMP PREEMPT Tue Jul 9 16:01:59 EDT 2013
Jul 11 22:12:39 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
Jul 11 22:12:39 turing-police kernel: [    0.021376] dmar: Host address width 36
Jul 11 22:12:39 turing-police kernel: [    0.021382] dmar: DRHD base: 0x000000fed90000 flags: 0x1
Jul 11 22:12:39 turing-police kernel: [    0.021414] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
Jul 11 22:12:39 turing-police kernel: [    0.021422] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
Jul 11 22:12:39 turing-police kernel: [    1.034107] DMAR: No ATSR found

Damned if I know what changed - same kernel booted at 18:54 hit the issue, but
at 22:12 it had gone into hiding, and I haven't seen it since.  (And the
laptop gets booted twice a day most days - once at arrival at office, and
once when I get home, and it had been doing it consistently at both locations
for several days.)

Definitely well into "things that go bump in the night" category.

--==_Exmh_1374012421_1500P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUeXEBQdmEQWDXROgAQLuKA//Xnw/MjghD8U0ATU/fOkhlMqZC1bEJRwj
5tZ+IHNQEwTMSSqLCRzmCHssU7B2+yg/m8/vmaKk2xdgNn8BOvLXOjDOJyWOuPFK
XtiZDcNqDRIEzzbHPtPJbErD2y81qBlTNG8b4r8YFJpzWhHljHg9p2pYovMS6wGk
m5jSlLR2jgG606tRe35TpHwghp8ptj2890w5r1rr4PF5HQf1N9eDTSetgPZLf8Z1
ir17xOIkAy0JLIvbA+K9Z39Zwozy1Cj3kTiKA/HdONmk/sacIAXUhg5A6CkbAkZR
m8jnkOuma1MCO84yDXbuA/C7rupIqtvMm+SRijP25O0AOdpbqowDa0KBu2W683+h
QPRrBmrCZWtwDsX/ogCimx7aADgWBV8sdYUQopMHZwlihW4y8S2HR/3vitn/r0SH
RQI1HsvuZY9+fgC5fQnwKXTK+tpsDwy2vmc0LHmGIZ75oVZKq/HcFjkfdsuDlC/Z
tmdagaxiARfxw2o5wvVwOaDW93lb5BVKp/6YlaPeWDrqof4Sw9a6wtC5AvXKYikD
4B6t0DyK9pNgwg4IKrkqqahsFhtgl0KzUJO8+japoehbeQYni/2zDYf7Y/ox3et8
vhO5Z9oiJz5peDZdUOIC8z46vgMXdF/+e6FBiBJNVrqlevMdk1sYiC/uKRslnqci
XUBDvxPGhhQ=
=6495
-----END PGP SIGNATURE-----

--==_Exmh_1374012421_1500P--
