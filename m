Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3HAPzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:55:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:46751 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756368Ab3HAPzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:55:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,795,1367996400"; 
   d="scan'208";a="340204319"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Pavel Machek <pavel@ucw.cz>
CC: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: RE: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Topic: /sys/module/pcie_aspm/parameters/policy not writable?
Thread-Index: AQHOfae/YJf6t4xSdkSmx+6rM4DMuJlhWxyAgAtunQCABzyS4IAGpr2AgAEsTUCABMj4wA==
Date: Thu, 1 Aug 2013 15:55:48 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B6264F92AC55@ORSMSX102.amr.corp.intel.com>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com> <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F921872@ORSMSX102.amr.corp.intel.com>
 <20130728135103.GC5382@amd.pavel.ucw.cz> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: multipart/mixed;
	boundary="_002_9BBC4E0CF881AA4299206E2E1412B6264F92AC55ORSMSX102amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AC55ORSMSX102amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Wyborny, Carolyn
> Sent: Thursday, August 01, 2013 7:56 AM
> To: 'Pavel Machek'
> Cc: Bjorn Helgaas; Greg KH; kernel list; Joe Lawrence; Myron Stowe; Kirsh=
er,
> Jeffrey T; Brandeburg, Jesse; Allan, Bruce W; Skidmore, Donald C; Rose, G=
regory
> V; Waskiewicz Jr, Peter P; Duyck, Alexander H; Ronciak, John; Dave, Tusha=
r N;
> e1000-devel@lists.sourceforge.net
> Subject: RE: /sys/module/pcie_aspm/parameters/policy not writable?
>=20
> [..]
> > If there's patch, I'll gladly try it :-). Thanks,
> >
> 								Pavel
> Thanks Pavel,

Minor fix.  Missed a bracket removal  Please use this  for your testing ins=
tead.

Thanks,

Carolyn
>=20
> It ended up taking more time than I thought.  The checking of whether ASP=
M is
> really enabled or not is, unfortunately, not as straightforward as I thou=
ght
> initially, so we ended up rewriting the function a bit.  In this patch we=
 try to use
> the pci_disable_link_state_locked() call, but if it fails, we then write =
to pci config
> space of the device to disable it.
>=20
> Please let me know if this actually disables the ASPM for your 82574 part=
s or
> not.  We can still continue the discussion on whether this is the best ap=
proach or
> not, or what else could be done.
>=20
> This patch attempts to work around a problem found with some systems wher=
e
> the call to pci_diable_link_state_locked() fails.  As a result, ASPM is n=
ot, in fact,
> disabled.  Changing disable aspm code to check if state actually is disab=
led after
> the call and, if not, try another way to disable it.
>=20
> Signed-off-by: Carolyn Wyborny <carolyn.wyborny@intel.com>
> ---
>=20
>  drivers/net/ethernet/intel/e1000e/netdev.c |   86 ++++++++++++++++++++--=
----
> --
>  1 files changed, 60 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
> b/drivers/net/ethernet/intel/e1000e/netdev.c
> index e6d2c0f..bc3025b 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -64,8 +64,6 @@ static int debug =3D -1;  module_param(debug, int, 0);
> MODULE_PARM_DESC(debug, "Debug level (0=3Dnone,...,16=3Dall)");
>=20
> -static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state);
> -
>  static const struct e1000_info *e1000_info_tbl[] =3D {
>  	[board_82571]		=3D &e1000_82571_info,
>  	[board_82572]		=3D &e1000_82572_info,
> @@ -6019,38 +6017,74 @@ static int __e1000_shutdown(struct pci_dev *pdev,
> bool runtime)
>  	return 0;
>  }
>=20
> -#ifdef CONFIG_PCIEASPM
> -static void __e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
> +/**
> + * e1000e_disable_aspm - Disable ASPM states
> + * @pdev: pointer to PCI device struct
> + * @state: bit-mask of ASPM states to disable
> + *
> + * Some devices *must* have certain ASPM states disabled per hardware
> errata.
> + **/
> +static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state)
>  {
> +	struct pci_dev *parent =3D pdev->bus->self;
> +	u16 aspm_dis_mask =3D 0;
> +	u16 pdev_aspmc, parent_aspmc;
> +
> +	switch (state) {
> +	case PCIE_LINK_STATE_L0S:
> +	case PCIE_LINK_STATE_L0S + PCIE_LINK_STATE_L1:
> +		aspm_dis_mask |=3D PCI_EXP_LNKCTL_ASPM_L0S;
> +		/* fall-through - can't have L1 without L0s */
> +	case PCIE_LINK_STATE_L1:
> +		aspm_dis_mask |=3D PCI_EXP_LNKCTL_ASPM_L1;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &pdev_aspmc);
> +	pdev_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
> +
> +	if (parent) {
> +		pcie_capability_read_word(parent, PCI_EXP_LNKCTL,
> +					  &parent_aspmc);
> +		parent_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
> +	}
> +
> +	/* Nothing to do if the ASPM states to be disabled already are */
> +	if (!(pdev_aspmc & aspm_dis_mask) &&
> +	    (!parent || !(parent_aspmc & aspm_dis_mask)))
> +		return;
> +
> +	dev_info(&pdev->dev, "Disabling ASPM %s %s\n",
> +		 (aspm_dis_mask & pdev_aspmc &
> PCI_EXP_LNKCTL_ASPM_L0S) ?
> +		 "L0s" : "",
> +		 (aspm_dis_mask & pdev_aspmc & PCI_EXP_LNKCTL_ASPM_L1)
> ?
> +		 "L1" : "");
> +
> +#ifdef CONFIG_PCIEASPM
>  	pci_disable_link_state_locked(pdev, state); -} -#else -static void
> __e1000e_disable_aspm(struct pci_dev *pdev, u16 state) -{
> -	u16 aspm_ctl =3D 0;
>=20
> -	if (state & PCIE_LINK_STATE_L0S)
> -		aspm_ctl |=3D PCI_EXP_LNKCTL_ASPM_L0S;
> -	if (state & PCIE_LINK_STATE_L1)
> -		aspm_ctl |=3D PCI_EXP_LNKCTL_ASPM_L1;
> +	/* Double-check ASPM control.  If not disabled by the above, the
> +	 * BIOS is preventing that from happening (or CONFIG_PCIEASPM is
> +	 * not enabled); override by writing PCI config space directly.
> +	 */
> +	pcie_capability_read_word(pdev, PCI_EXP_LNKCTL, &pdev_aspmc);
> +	pdev_aspmc &=3D PCI_EXP_LNKCTL_ASPMC;
> +
> +	if (!(aspm_dis_mask & pdev_aspmc))
> +		return;
> +#endif
>=20
>  	/* Both device and parent should have the same ASPM setting.
>  	 * Disable ASPM in downstream component first and then upstream.
>  	 */
> -	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_ctl);
> -
> -	if (pdev->bus->self)
> -		pcie_capability_clear_word(pdev->bus->self, PCI_EXP_LNKCTL,
> -					   aspm_ctl);
> -}
> -#endif
> -static void e1000e_disable_aspm(struct pci_dev *pdev, u16 state) -{
> -	dev_info(&pdev->dev, "Disabling ASPM %s %s\n",
> -		 (state & PCIE_LINK_STATE_L0S) ? "L0s" : "",
> -		 (state & PCIE_LINK_STATE_L1) ? "L1" : "");
> +	pcie_capability_clear_word(pdev, PCI_EXP_LNKCTL, aspm_dis_mask);
>=20
> -	__e1000e_disable_aspm(pdev, state);
> +	if (parent)
> +		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
> +					   aspm_dis_mask);
>  }
>=20
>  #ifdef CONFIG_PM


--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AC55ORSMSX102amrcor_
Content-Type: message/rfc822
Content-Disposition: attachment;
	creation-date="Thu, 01 Aug 2013 15:55:48 GMT";
	modification-date="Thu, 01 Aug 2013 15:55:48 GMT"

Received: from fmsmsx107.amr.corp.intel.com (10.19.9.54) by
 ORSMSX157.amr.corp.intel.com (10.22.240.23) with Microsoft SMTP Server (TLS)
 id 14.3.123.3; Thu, 1 Aug 2013 08:54:48 -0700
Received: from azsmga001.ch.intel.com (10.2.17.19) by FMSMSX107-2.fm.intel.com
 (10.19.9.16) with Microsoft SMTP Server id 14.3.123.3; Thu, 1 Aug 2013
 08:54:47 -0700
Received: from cmw-ivy.jf.intel.com (HELO localhost.localdomain)
 ([10.23.21.75])  by azsmga001.ch.intel.com with ESMTP; 01 Aug 2013 08:54:14
 -0700
Received: from localhost6.localdomain6 (cmw-ivy [127.0.0.1])	by
 localhost.localdomain (8.14.4/8.14.4) with ESMTP id r71FsAP4029101	for
 <carolyn.wyborny@intel.com>; Thu, 1 Aug 2013 08:54:10 -0700
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Subject: [NET-NEXT PATCH v2] e1000e: Add code to check for failure of
 pci_disable_link_state call
Thread-Topic: [NET-NEXT PATCH v2] e1000e: Add code to check for failure of
 pci_disable_link_state call
Thread-Index: AQHOjs9z05PSvKUZmECSQRgi5Mdu3g==
Date: Thu, 1 Aug 2013 15:54:10 +0000
Message-ID: <20130801155330.29064.92207.stgit@localhost6.localdomain6>
Content-Language: en-US
X-MS-Exchange-Organization-AuthAs: Internal
X-MS-Exchange-Organization-AuthMechanism: 10
X-MS-Exchange-Organization-AuthSource: FMSMSX107.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.89,795,1367996400";
    d="scan'208";a="340203585"
user-agent: StGIT/0.14.3
x-extloop1: 1
Content-Type: text/plain; charset="utf-8"
Content-ID: <68D0A3C98DD62F49A6A397CDA944BCEA@intel.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0

VGhpcyBwYXRjaCBhdHRlbXB0cyB0byB3b3JrIGFyb3VuZCBhIHByb2JsZW0gZm91bmQgd2l0aCBz
b21lIHN5c3RlbXMgd2hlcmUgdGhlIGNhbGwgdG8gcGNpX2RpYWJsZV9saW5rX3N0YXRlX2xvY2tl
ZCgpIGZhaWxzLiAgQXMgYSByZXN1bHQsIEFTUE0gaXMgbm90LCBpbiBmYWN0LCBkaXNhYmxlZC4g
IENoYW5naW5nIGRpc2FibGUgYXNwbSBjb2RlIHRvIGNoZWNrIGlmIHN0YXRlIGFjdHVhbGx5IGlz
IGRpc2FibGVkIGFmdGVyIHRoZSBjYWxsIGFuZCwgaWYgbm90LCB0cnkgYW5vdGhlciB3YXkgdG8g
ZGlzYWJsZSBpdC4NCg0KU2lnbmVkLW9mZi1ieTogQ2Fyb2x5biBXeWJvcm55IDxjYXJvbHluLnd5
Ym9ybnlAaW50ZWwuY29tPg0KLS0tDQp2MiAtIGZpeCBtaXN0YWtlbiBleHRyYSBicmFja2V0Lg0K
DQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jIHwgICA4NSArKysr
KysrKysrKysrKysrKysrLS0tLS0tLS0tDQogMSBmaWxlcyBjaGFuZ2VkLCA1OSBpbnNlcnRpb25z
KCspLCAyNiBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2UxMDAwZS9uZXRkZXYuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAw
ZS9uZXRkZXYuYw0KaW5kZXggZTZkMmMwZi4uYzMwMTQ2OCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9uZXRkZXYuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jDQpAQCAtNjQsOCArNjQsNiBAQCBzdGF0aWMgaW50
IGRlYnVnID0gLTE7DQogbW9kdWxlX3BhcmFtKGRlYnVnLCBpbnQsIDApOw0KIE1PRFVMRV9QQVJN
X0RFU0MoZGVidWcsICJEZWJ1ZyBsZXZlbCAoMD1ub25lLC4uLiwxNj1hbGwpIik7DQogDQotc3Rh
dGljIHZvaWQgZTEwMDBlX2Rpc2FibGVfYXNwbShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdTE2IHN0
YXRlKTsNCi0NCiBzdGF0aWMgY29uc3Qgc3RydWN0IGUxMDAwX2luZm8gKmUxMDAwX2luZm9fdGJs
W10gPSB7DQogCVtib2FyZF84MjU3MV0JCT0gJmUxMDAwXzgyNTcxX2luZm8sDQogCVtib2FyZF84
MjU3Ml0JCT0gJmUxMDAwXzgyNTcyX2luZm8sDQpAQCAtNjAxOSwzOCArNjAxNyw3MyBAQCBzdGF0
aWMgaW50IF9fZTEwMDBfc2h1dGRvd24oc3RydWN0IHBjaV9kZXYgKnBkZXYsIGJvb2wgcnVudGlt
ZSkNCiAJcmV0dXJuIDA7DQogfQ0KIA0KLSNpZmRlZiBDT05GSUdfUENJRUFTUE0NCi1zdGF0aWMg
dm9pZCBfX2UxMDAwZV9kaXNhYmxlX2FzcG0oc3RydWN0IHBjaV9kZXYgKnBkZXYsIHUxNiBzdGF0
ZSkNCisvKioNCisgKiBlMTAwMGVfZGlzYWJsZV9hc3BtIC0gRGlzYWJsZSBBU1BNIHN0YXRlcw0K
KyAqIEBwZGV2OiBwb2ludGVyIHRvIFBDSSBkZXZpY2Ugc3RydWN0DQorICogQHN0YXRlOiBiaXQt
bWFzayBvZiBBU1BNIHN0YXRlcyB0byBkaXNhYmxlDQorICoNCisgKiBTb21lIGRldmljZXMgKm11
c3QqIGhhdmUgY2VydGFpbiBBU1BNIHN0YXRlcyBkaXNhYmxlZCBwZXIgaGFyZHdhcmUgZXJyYXRh
Lg0KKyAqKi8NCitzdGF0aWMgdm9pZCBlMTAwMGVfZGlzYWJsZV9hc3BtKHN0cnVjdCBwY2lfZGV2
ICpwZGV2LCB1MTYgc3RhdGUpDQogew0KKwlzdHJ1Y3QgcGNpX2RldiAqcGFyZW50ID0gcGRldi0+
YnVzLT5zZWxmOw0KKwl1MTYgYXNwbV9kaXNfbWFzayA9IDA7DQorCXUxNiBwZGV2X2FzcG1jLCBw
YXJlbnRfYXNwbWM7DQorDQorCXN3aXRjaCAoc3RhdGUpIHsNCisJY2FzZSBQQ0lFX0xJTktfU1RB
VEVfTDBTOg0KKwljYXNlIFBDSUVfTElOS19TVEFURV9MMFMgKyBQQ0lFX0xJTktfU1RBVEVfTDE6
DQorCQlhc3BtX2Rpc19tYXNrIHw9IFBDSV9FWFBfTE5LQ1RMX0FTUE1fTDBTOw0KKwkJLyogZmFs
bC10aHJvdWdoIC0gY2FuJ3QgaGF2ZSBMMSB3aXRob3V0IEwwcyAqLw0KKwljYXNlIFBDSUVfTElO
S19TVEFURV9MMToNCisJCWFzcG1fZGlzX21hc2sgfD0gUENJX0VYUF9MTktDVExfQVNQTV9MMTsN
CisJCWJyZWFrOw0KKwlkZWZhdWx0Og0KKwkJcmV0dXJuOw0KKwl9DQorDQorCXBjaWVfY2FwYWJp
bGl0eV9yZWFkX3dvcmQocGRldiwgUENJX0VYUF9MTktDVEwsICZwZGV2X2FzcG1jKTsNCisJcGRl
dl9hc3BtYyAmPSBQQ0lfRVhQX0xOS0NUTF9BU1BNQzsNCisNCisJaWYgKHBhcmVudCkgew0KKwkJ
cGNpZV9jYXBhYmlsaXR5X3JlYWRfd29yZChwYXJlbnQsIFBDSV9FWFBfTE5LQ1RMLA0KKwkJCQkJ
ICAmcGFyZW50X2FzcG1jKTsNCisJCXBhcmVudF9hc3BtYyAmPSBQQ0lfRVhQX0xOS0NUTF9BU1BN
QzsNCisJfQ0KKw0KKwkvKiBOb3RoaW5nIHRvIGRvIGlmIHRoZSBBU1BNIHN0YXRlcyB0byBiZSBk
aXNhYmxlZCBhbHJlYWR5IGFyZSAqLw0KKwlpZiAoIShwZGV2X2FzcG1jICYgYXNwbV9kaXNfbWFz
aykgJiYNCisJICAgICghcGFyZW50IHx8ICEocGFyZW50X2FzcG1jICYgYXNwbV9kaXNfbWFzaykp
KQ0KKwkJcmV0dXJuOw0KKw0KKwlkZXZfaW5mbygmcGRldi0+ZGV2LCAiRGlzYWJsaW5nIEFTUE0g
JXMgJXNcbiIsDQorCQkgKGFzcG1fZGlzX21hc2sgJiBwZGV2X2FzcG1jICYgUENJX0VYUF9MTktD
VExfQVNQTV9MMFMpID8NCisJCSAiTDBzIiA6ICIiLA0KKwkJIChhc3BtX2Rpc19tYXNrICYgcGRl
dl9hc3BtYyAmIFBDSV9FWFBfTE5LQ1RMX0FTUE1fTDEpID8NCisJCSAiTDEiIDogIiIpOw0KKw0K
KyNpZmRlZiBDT05GSUdfUENJRUFTUE0NCiAJcGNpX2Rpc2FibGVfbGlua19zdGF0ZV9sb2NrZWQo
cGRldiwgc3RhdGUpOw0KLX0NCi0jZWxzZQ0KLXN0YXRpYyB2b2lkIF9fZTEwMDBlX2Rpc2FibGVf
YXNwbShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdTE2IHN0YXRlKQ0KLXsNCi0JdTE2IGFzcG1fY3Rs
ID0gMDsNCiANCi0JaWYgKHN0YXRlICYgUENJRV9MSU5LX1NUQVRFX0wwUykNCi0JCWFzcG1fY3Rs
IHw9IFBDSV9FWFBfTE5LQ1RMX0FTUE1fTDBTOw0KLQlpZiAoc3RhdGUgJiBQQ0lFX0xJTktfU1RB
VEVfTDEpDQotCQlhc3BtX2N0bCB8PSBQQ0lfRVhQX0xOS0NUTF9BU1BNX0wxOw0KKwkvKiBEb3Vi
bGUtY2hlY2sgQVNQTSBjb250cm9sLiAgSWYgbm90IGRpc2FibGVkIGJ5IHRoZSBhYm92ZSwgdGhl
DQorCSAqIEJJT1MgaXMgcHJldmVudGluZyB0aGF0IGZyb20gaGFwcGVuaW5nIChvciBDT05GSUdf
UENJRUFTUE0gaXMNCisJICogbm90IGVuYWJsZWQpOyBvdmVycmlkZSBieSB3cml0aW5nIFBDSSBj
b25maWcgc3BhY2UgZGlyZWN0bHkuDQorCSAqLw0KKwlwY2llX2NhcGFiaWxpdHlfcmVhZF93b3Jk
KHBkZXYsIFBDSV9FWFBfTE5LQ1RMLCAmcGRldl9hc3BtYyk7DQorCXBkZXZfYXNwbWMgJj0gUENJ
X0VYUF9MTktDVExfQVNQTUM7DQorDQorCWlmICghKGFzcG1fZGlzX21hc2sgJiBwZGV2X2FzcG1j
KSkNCisJCXJldHVybjsNCisjZW5kaWYNCiANCiAJLyogQm90aCBkZXZpY2UgYW5kIHBhcmVudCBz
aG91bGQgaGF2ZSB0aGUgc2FtZSBBU1BNIHNldHRpbmcuDQogCSAqIERpc2FibGUgQVNQTSBpbiBk
b3duc3RyZWFtIGNvbXBvbmVudCBmaXJzdCBhbmQgdGhlbiB1cHN0cmVhbS4NCiAJICovDQotCXBj
aWVfY2FwYWJpbGl0eV9jbGVhcl93b3JkKHBkZXYsIFBDSV9FWFBfTE5LQ1RMLCBhc3BtX2N0bCk7
DQotDQotCWlmIChwZGV2LT5idXMtPnNlbGYpDQotCQlwY2llX2NhcGFiaWxpdHlfY2xlYXJfd29y
ZChwZGV2LT5idXMtPnNlbGYsIFBDSV9FWFBfTE5LQ1RMLA0KLQkJCQkJICAgYXNwbV9jdGwpOw0K
LX0NCi0jZW5kaWYNCi1zdGF0aWMgdm9pZCBlMTAwMGVfZGlzYWJsZV9hc3BtKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2LCB1MTYgc3RhdGUpDQotew0KLQlkZXZfaW5mbygmcGRldi0+ZGV2LCAiRGlzYWJs
aW5nIEFTUE0gJXMgJXNcbiIsDQotCQkgKHN0YXRlICYgUENJRV9MSU5LX1NUQVRFX0wwUykgPyAi
TDBzIiA6ICIiLA0KLQkJIChzdGF0ZSAmIFBDSUVfTElOS19TVEFURV9MMSkgPyAiTDEiIDogIiIp
Ow0KKwlwY2llX2NhcGFiaWxpdHlfY2xlYXJfd29yZChwZGV2LCBQQ0lfRVhQX0xOS0NUTCwgYXNw
bV9kaXNfbWFzayk7DQogDQotCV9fZTEwMDBlX2Rpc2FibGVfYXNwbShwZGV2LCBzdGF0ZSk7DQor
CWlmIChwYXJlbnQpDQorCQlwY2llX2NhcGFiaWxpdHlfY2xlYXJfd29yZChwYXJlbnQsIFBDSV9F
WFBfTE5LQ1RMLA0KKwkJCQkJICAgYXNwbV9kaXNfbWFzayk7DQogfQ0KIA0KICNpZmRlZiBDT05G
SUdfUE0NCg0K

--_002_9BBC4E0CF881AA4299206E2E1412B6264F92AC55ORSMSX102amrcor_--
