Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaIYHPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:15:45 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:60282 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaIYHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:15:42 -0400
Date: Thu, 25 Sep 2014 09:15:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org,
        arnab.basu@freescale.com, Bharat.Bhushan@freescale.com, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 01/22] PCI/MSI: Clean up struct msi_chip argument
Message-ID: <20140925071536.GG12423@ulmo>
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com>
 <1411614872-4009-2-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EDJsL2R9iCFAt7IV"
Content-Disposition: inline
In-Reply-To: <1411614872-4009-2-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EDJsL2R9iCFAt7IV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 11:14:11AM +0800, Yijing Wang wrote:
> Msi_chip functions setup_irq/teardown_irq rarely use msi_chip
> argument.

That's not true. Out of the four drivers that you modify two use the
parameter. And the two that don't probably should be using it too.

50% is not "rarely". =3D)

>           We can look up msi_chip pointer by the device pointer
> or irq number, so clean up msi_chip argument.

I don't like this particular change. The idea was to keep the API object
oriented so that drivers wouldn't have to know where to get the MSI chip
=66rom. It also makes it more resilient against code reorganizations since
the core code is the only place that needs to know where to get the chip
=66rom.

Thierry

--EDJsL2R9iCFAt7IV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI8EYAAoJEN0jrNd/PrOhKe8P+wRzEsusQS8lMmL8zyqvg5wy
x0Q4+eSI5aEkUEQz6Mtcld6eIwACphFOHeoDrAFauuxrjVqWslHdYAIAKbYoxG0e
xV9PJoc5PY24v4vnR5BvWEHxBfzfJ8QmFlDZGRvy3lqTPhTBOzLIbNUMO1gaoH1Q
MIzSjgl631075wZns41KNNx1TjCaXNeDwjkAyyX4bjJ7SL6ymrsxGo/zhCRCpZSk
2ks9AFoqFQoIOFeziuAW7WAx8BM9ah1ba5tc3oVZ6LC3JHrvoHZ5KCjITV75Geqb
dFzQh7Rx0yFdXVmNOX+O6XtFVvb7hNFELV1SAzQQXWl0Hyid6Dp0ZShKLSumNdG8
WvJFtUil25Prid9JVvpq+PrRGlbOucv0U+wi2cbdrE9/7UwtYoxAHNj/aTXdWwIv
d6ble8v0UT7l5Sk8QIFMI3VbatPqL/i+Mz8NijIKaMRug9/XmXZIN0Q05JhlbJ2b
/AWyYKLGAwYMrZcDU2v8CajO/NGUQ9D+mkqcN0NDsxmvP5woL6GC2tQzZABaAipF
LlbM5T6PfjxRfOvYNAIOJnttoirlQ4UI8CjVEeotPrchQalN7ZESvaHK0z2/Wrv1
kSvUiqTvOPtRaQn4rIs5MTi7tw5NBsG2MyWfy90WkITpn5vEYrX4JQITTUpa/x9B
IKT68Y/8ZFK3ksbjHtIe
=LSxe
-----END PGP SIGNATURE-----

--EDJsL2R9iCFAt7IV--
