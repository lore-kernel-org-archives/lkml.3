Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3JDQ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 12:28:31 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45327 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3JDQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 12:28:27 -0400
Message-ID: <524EECA7.7040409@monstr.eu>
Date: Fri, 04 Oct 2013 18:28:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH v2] fpga: Introduce new fpga subsystem
References: <cover.1380727889.git.michal.simek@xilinx.com> <fe4f34387011339efe9f5868a7eec9d549462d8f.1380727889.git.michal.simek@xilinx.com> <20131002174640.GA10287@obsidianresearch.com>
In-Reply-To: <20131002174640.GA10287@obsidianresearch.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="gvw260H7fc685utWm2HlaBSPv0WUBCtuv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gvw260H7fc685utWm2HlaBSPv0WUBCtuv
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/02/2013 07:46 PM, Jason Gunthorpe wrote:
> On Wed, Oct 02, 2013 at 05:35:58PM +0200, Michal Simek wrote:
>=20
>> +What:		/sys/class/fpga_manager/fpga<dev-id>/fpga_config_state
>> +Date:		October 2013
>> +KernelVersion:	3.12
>> +Contact:	Michal Simek <michal.simek@xilinx.com>
>> +Description:
>> +		By reading this file you will get current fpga manager state.
>> +		Flag bits are present in include/linux/fpga.h (FPGA_MGR_XX).
>> +		By writing to this file you can change fpga manager state.
>> +		Valid options are: write_init, write_complete, read_init,
>> +		read_complete.
>=20
> This shouldn't be asymmetric - read/write should be in the same
> format.
>=20
> I strongly encourage you to use text strings to indicate the state of
> the configuration FSM, and I *really* think you should rework things
> to have an explicit configuration FSM rather than trying to bodge one
> together with a bunch of bit flags.

Any favourite names for states?
Or ready, write_init, write_complete is enough for now?

Alan: This should be unified way for user to get proper states from the
driver. It means from my point of view will be better to have set of stat=
es
which this function can return instead of calling origin status function
where we can't control states for all these drivers.

> Plus error handling is missing, failures need to be reported back.

Will fix this.

> Noticed several typos:

Ah yeah c&p. :-(

>=20
>> +
>> +	if (mgr->mops->read_init) {
>> +		ret =3D mgr->mops->read_init(mgr);
>> +		if (ret) {
>> +			dev_dbg(mgr->dev, "Failed to write_init\n");
>                                                     ^^^^^^^^
> read_init
>=20
>> +	if (mgr->mops->write) {
>                    ^^^^^^^^^^
> read
>=20
>> +		ret =3D mgr->mops->read(mgr, buf, count);
>> +		if (ret) {
>> +			dev_dbg(mgr->dev, "Failed to write\n");
>                                              ^^^^^^^^^^^^^^^^^
> read
>=20
>> +
>> +	if (mgr->mops->write_complete) {
>                     ^^^^^^^^^^
> read
>> +		ret =3D mgr->mops->read_complete(mgr);
>> +		if (ret) {
>> +			dev_dbg(mgr->dev, "Failed to write_complete\n");
>   					  	  ^^^^^^^^^^^^
> read
>=20
>> +static inline int fpga_mgr_write(struct fpga_manager *mgr, const u8 *=
buf,
>> +				 ssize_t count)
>> +{
>> +	int bit, ret;
>> +
>> +	dev_dbg(mgr->dev, "%s %lx\n", __func__, mgr->flags);
>> +
>> +	/* FPGE init has to be done to be able to continue */
>            ^^^^^^
> FPGA
>=20
>> +static struct device_attribute fpga_mgr_attrs[] =3D {
>> +	__ATTR(name, S_IRUGO, fpga_mgr_name_show, NULL),
>> +	__ATTR(firmware, S_IWUSR, NULL, fpga_mgr_attr_write),
>> +	__ATTR(fpga_config_state, S_IRUSR | S_IWUSR,
>> +	       fpga_mgr_status_read, fpga_mgr_status_write),
>> +	__ATTR_NULL
>> +};
>=20
> AFAIK it is preferred to use DEVICE_ATTR_RO(), ATTRIBUTE_GROUPS()
> and struct class.dev_groups
>=20
> eg see this note in linux/device.h
>=20
> struct class {
>         struct device_attribute         *dev_attrs;     /* use dev_grou=
ps instead */
>         const struct attribute_group    **dev_groups;
> }
>=20

This will be fixed in v3. I have already changed this.

>> +	struct fpga_manager *mgr;
>> +	int ret;
>> +
>> +	if (!mops) {
>> +		dev_dbg(&pdev->dev, "Register failed: NO fpga_manager_ops\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!name || !strlen(name)) {
>> +		dev_dbg(&pdev->dev, "Register failed: NO name specific\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	mgr =3D devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
>> +	if (!mgr)
>> +		return -ENOMEM;
>=20
> I wonder if this is right, it seems like a strange way to make a class
> subsystem, usually the struct fpga_manager would contain the 'struct
> device' (not a pointer, so you can use container_of) and drvdata would
> be reserved for something else.

I am not following you here. mrg structure is connected with the driver
it means when driver is removed then this structure is freed.


>=20
> This seems to create lifetime issues since the devm above will be
> free'd when the platform driver is released, but the class device will
> live on with the stray pointer. Better to allocate everything against
> the class device below.

device in unregistered before this structure is freed.
fpga_mgr_unregister() is called in the platform driver in remove function=
=2E

>=20
> Plus you need to ensure the device is fully functionally before
> device_register is called, otherwise you race with notifications to
> userspace.

fpga_mgr_register() should be called as the latest function in the probe
in platform_driver. At least it is what I have for zynq.

>> +/**
>> + * fpga_mgr_unregister: Remove fpga manager
>> + * @pdev: Pointer to the platform device of fpga manager
>> + *
>> + * Function unregister fpga manager and release all temporary structu=
res
>> + *
>> + * Returns 0 for all cases
>> + */
>> +int fpga_mgr_unregister(struct platform_device *pdev)
>> +{
>> +	struct fpga_manager *mgr =3D platform_get_drvdata(pdev);
>> +
>> +	if (mgr && mgr->mops && mgr->mops->fpga_remove)
>> +		mgr->mops->fpga_remove(mgr);
>> +
>> +	device_unregister(mgr->dev);
>> +
>> +	spin_lock(&fpga_mgr_idr_lock);
>> +	idr_remove(&fpga_mgr_idr, mgr->nr);
>> +	spin_unlock(&fpga_mgr_idr_lock);
>=20
> What happens when userspace is holding one of the sysfs files open and
> you unload the module? Looks like bad things?

I didn't test this but feel free to check it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--gvw260H7fc685utWm2HlaBSPv0WUBCtuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJO7KcACgkQykllyylKDCG1PACfcXTljibE4Dr/s4hwlMKFDWfF
F8cAn1XcHL5x69LP9ttDK15zTl+5ndBl
=iOZz
-----END PGP SIGNATURE-----

--gvw260H7fc685utWm2HlaBSPv0WUBCtuv--
