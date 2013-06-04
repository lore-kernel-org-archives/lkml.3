Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759577Ab3FDBu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 21:50:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55208 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab3FDBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 21:50:26 -0400
Date: Tue, 4 Jun 2013 11:49:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>
Subject: linux-next: manual merge of the pci tree with Linus' tree
Message-Id: <20130604114955.753909b956c4f8e75ace86a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Jun_2013_11_49_55_+1000_BU+0X8bymfNj_iEW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jun_2013_11_49_55_+1000_BU+0X8bymfNj_iEW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
drivers/acpi/pci_root.c between commit 3f327e39b4b8 ("PCI: acpiphp:
Re-enumerate devices when host bridge receives Bus Check") from Linus'
tree and commit 6dc7d22c6738 ("PCI/ACPI: Use dev_printk(),
acpi_handle_print(), pr_xxx() when possible") from the pci tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/pci_root.c
index e427dc5,122b4dc..0000000
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@@ -639,11 -620,9 +620,11 @@@ static void _handle_hotplug_event_root(
  	switch (type) {
  	case ACPI_NOTIFY_BUS_CHECK:
  		/* bus enumerate */
- 		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
- 				 (char *)buffer.pointer);
+ 		acpi_handle_printk(KERN_DEBUG, handle,
+ 				   "Bus check notify on %s\n", __func__);
 -		if (!root)
 +		if (root)
 +			acpiphp_check_host_bridge(handle);
 +		else
  			handle_root_bridge_insertion(handle);
 =20
  		break;

--Signature=_Tue__4_Jun_2013_11_49_55_+1000_BU+0X8bymfNj_iEW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrUfWAAoJEECxmPOUX5FEo08QAKY6fBtD2iU88m70mKV1Ibri
O3u1L/Xa0Rr9fu3NY7EoYPGJCJpzPGUhy9LkY4LR42kWR8IA868acTWtE7tPWL1e
X5TvP5qnPVHpcIdT/S4q7COB0fQEC+u/yFVIkdlxV0ejI6HmRKOKXB1PA55DYmxE
CR+aiP6f8UWv9qf8apiEH/mll/FGFUtm1NIYNVUAKn5PYRBMY5aQ/4abY+2gej7q
xkZATvgftwC2jBRek3JyxClAtZcYbXL9E5dwhCq2CRHDLEHlST2jW9RIFGcWETwP
g/mQqf+OhsTY1pfcN2qwJUemV5ZFIEB1YlL9WM9DELbcgKwVz/Ug4OQjQhjlBFwe
nijwfosUqc0xoqJV9SBoxSUrYjwzwdvvMGTr9WEUlaVzSgFUDwNq+cMw1X9mWGwf
luLPLq1+nukCiNZ9InIqvv2y8Y193C6CWrBUjUiubUr9SVUPpy6WtfeyY1nbmVHm
WqSDEThSZx+imqOCr+O3zVdLKCC8r0XYAivgIFOt72/0Nc5cX/h9kE2PvM1C2Gi0
2qFhA80jpLV407/JkrAh2bTVFCym1fSRfk3Nj+1lh+48e1cgZrnJxueOOD4r6vU+
y9STNozelyj/fytCfvSI9yvRO1qLCG4XkfmYehpX2VvN5hCtExR6AUIFj5zuSuYL
XAI+rAQVbXrRXqkBjOk9
=fuxp
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jun_2013_11_49_55_+1000_BU+0X8bymfNj_iEW--
