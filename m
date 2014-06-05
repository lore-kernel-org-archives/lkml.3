Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaFEVL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:11:27 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56203 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:11:25 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: linux-next crash in xhci_add_ep_to_interval
In-Reply-To: Your message of "Thu, 05 Jun 2014 12:05:56 -0700."
             <1401995156.30026.2.camel@dwillia2-mobl2.amr.corp.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <18529.1401981749@turing-police.cc.vt.edu> <CAA9_cmfje+8qAh7NqjHi1zcRAPZgJ0xdOK2nM7TKN9NRgqcRfw@mail.gmail.com> <23223.1401985468@turing-police.cc.vt.edu> <CAPcyv4gYnvF4Nt5itkDsD=DzL8sfETZUBmQqZwiHE1SOZvtsbw@mail.gmail.com> <33745.1401989394@turing-police.cc.vt.edu>
            <1401995156.30026.2.camel@dwillia2-mobl2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1402002643_3162P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 05 Jun 2014 17:10:43 -0400
Message-ID: <3417.1402002643@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1402002643_3162P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Jun 2014 12:05:56 -0700, Dan Williams said:

> Subject: usb: fix ->update_hub_device() vs hdev->maxchild
>
> From: Dan Williams <dan.j.williams@intel.com>
>
> Commit d8521afe3586 "usb: assign default peer ports for root hubs"
> delayed marking a hub valid (set hdev->maxchild) until it had been fully
> configured and to enable the publishing of valid hubs to be serialized
> by usb_port_peer_mutex.
>
> However, xhci_update_hub_device() in some cases depends on
> hdev->maxchild already being set.  Do the minimal fix and move it after
> the setting of hdev->maxchild.
>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Applied cleanly, booted without complaint, the keyboard that's behind
the PS2-USB converter works.

uname -r reports 3.15.0-rc8-next-20140605-dirty as expected.

So feel free to stick a Tested-By: on there. :)

--==_Exmh_1402002643_3162P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU5Dc0gdmEQWDXROgAQLNKA/9E7c6Xf2cKkmDGI8Y6xs1XWK1PC7+xAq7
0UwNxREOyCEmSIt2D50LoU5c+rLfllHDCFCuyQX1yGbDT0/Vcr7ZpVbWUToObR1/
gjBj3rQlxaGYCBkLaQNoDuTqm6s7koaksOaft1iFiNL/7l1MgzKOGCbPhnxpNF/M
lj+te8ol6ZUS6FoNKlOzHo/Z/V/AfUlGczmL9iCJO3+I/GQqDyRjrG4oyNEMBPGH
eK6v6HYdYQ8r7xf14ekyG9mAF1kGpYDkDfqWeJl8YBwl1lgRDTpY+1BfEJY2kzuX
dgt2eUgSUmxvW4f7Kz84H0fziduyrCRuEG7p9dECTtqxNeKJZ60XooMThEmmw3SR
SwpjMzWACMjGjYuCSfrZV7rEo9w+7kFOjyxirUE+YBgd8DaoKYfcclFp54X7uLLq
yi6TJ3UUuze2yipArB5aVhGucnimRrqdNYh/Q16ySC1POfieTokvZHAaNcIyvrXl
ge1neblqrFJi/rnWbT7tuKDn/sDkzB3f3tC5ly2Z0wVI+ggoVSPsJzZlDC8RaTmk
1J3EwMt69BAgoLb3oNde3Cc0YgC/3mizMkMC4RLMU4dgGE73Hb/pMBUBbpSjx+r5
Vbzl+5H5oHffa2HO5LTAIVr4TsN6AcIsGIHxBTxE5fxySUa+8frw3Egmg5Q829ro
FEZdMmNyMIE=
=eoHi
-----END PGP SIGNATURE-----

--==_Exmh_1402002643_3162P--
