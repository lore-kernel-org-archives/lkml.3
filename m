Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3GYOnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:43:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47102 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609Ab3GYOna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:43:30 -0400
Message-ID: <1374763397.5374.30.camel@fourier>
Subject: Re: Linux 3.11-rc2 (acpi backlight, revert)
From: Kamal Mostafa <kamal@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Hogan <james@albanarts.com>, Aaron Lu <aaron.lu@intel.com>,
        Kalle Valo <kvalo@adurom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Thu, 25 Jul 2013 07:43:17 -0700
In-Reply-To: <2218913.HKGjJcYT1G@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan> <2218913.HKGjJcYT1G@vostro.rjw.lan>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-XKGbTPHwm9yG8MsZlw+G"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XKGbTPHwm9yG8MsZlw+G
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-25 at 15:00 +0200, Rafael J. Wysocki wrote:
> On Monday, July 22, 2013 09:54:21 PM Rafael J. Wysocki wrote:
> > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrot=
e:
> > > >
> > > > Linus, do you want me to send a pull request reverting 8c5bd7a and =
efaa14c?
> > >=20
> > > Yes, but let's wait a while. Not because I think we'll fix the proble=
m
> > > (hey, miracles might happen), but because I think it would be useful
> > > to couple the reverts with information about the particular machines
> > > that broke (and the people who reported it). So that when we
> > > inevitably try again, we can perhaps get some testing effort with
> > > those machines/people.
> > >=20
> > > It doesn't seem to be a show-stopped for a large number of people, so
> > > there's no huge hurry. I'd suggest doing the revert just in time for
> > > rc3, but waiting until then to gather info about people who see
> > > breakage.
> > >=20
> > > Sound like a plan?
> >=20
> > Yes, it does.
>=20
> OK, time to revert I guess.
>=20
> James, Kamal, Steven, J=C3=B6rg, Martin, Kalle, please check if the apppe=
nded patch
> fixes the backlight for you.

Yes, this revert patch does re-enable backlight control for the affected
Dell XPS13 models.

 -Kamal


> Aaron, please double check if acpi_video_backlight_quirks() will still wo=
rk as
> needed.
>=20
> Thanks,
> Rafael
>=20
>=20
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: Revert "ACPI / video / i915: No ACPI backlight if firmware expec=
ts Windows 8"
>=20
> We attempted to address a regression introduced by commit a57f7f9
> (ACPICA: Add Windows8/Server2012 string for _OSI method.) after which
> ACPI video backlight support doesn't work on a number of systems,
> because the relevant AML methods in the ACPI tables in their BIOSes
> become useless after the BIOS has been told that the OS is compatible
> with Windows 8.  That problem is tracked by the bug entry at:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D51231
>=20
> Commit 8c5bd7a (ACPI / video / i915: No ACPI backlight if firmware
> expects Windows 8) introduced for this purpose essentially prevented
> the ACPI backlight support from being used if the BIOS had been told
> that the OS was compatible with Windows 8 and the i915 driver was
> loaded, in which case the backlight would always be handled by i915.
> Unfortunately, however, that turned out to cause problems with
> backlight to appear on multiple systems with symptoms indicating that
> i915 was unable to control the backlight on those systems as
> expected.
>=20
> For this reason, revert commit 8c5bd7a, but leave the function
> acpi_video_backlight_quirks() introduced by it, because another
> commit on top of it uses that function.
>=20
> References: https://lkml.org/lkml/2013/7/21/119
> References: https://lkml.org/lkml/2013/7/22/261
> References: https://lkml.org/lkml/2013/7/23/429
> References: https://lkml.org/lkml/2013/7/23/459
> References: https://lkml.org/lkml/2013/7/23/81
> References: https://lkml.org/lkml/2013/7/24/27
> Reported-by: James Hogan <james@albanarts.com>
> Reported-by: Steven Newbury <steve@snewbury.org.uk>
> Reported-by: Kamal Mostafa <kamal@canonical.com>
> Reported-by: Martin Steigerwald <Martin@lichtvoll.de>
> Reported-by: J=C3=B6rg Otte <jrg.otte@gmail.com>
> Reported-by: Kalle Valo <kvalo@adurom.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/acpi/internal.h         |    2 -
>  drivers/acpi/video.c            |   67 ++++-----------------------------=
-------
>  drivers/acpi/video_detect.c     |   15 --------
>  drivers/gpu/drm/i915/i915_dma.c |    2 -
>  include/acpi/video.h            |   11 ------
>  include/linux/acpi.h            |    1=20
>  6 files changed, 11 insertions(+), 87 deletions(-)
>=20
> Index: linux-pm/drivers/acpi/video.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/acpi/video.c
> +++ linux-pm/drivers/acpi/video.c
> @@ -897,7 +897,7 @@ static void acpi_video_device_find_cap(s
>  	if (acpi_video_init_brightness(device))
>  		return;
> =20
> -	if (acpi_video_verify_backlight_support()) {
> +	if (acpi_video_backlight_support()) {
>  		struct backlight_properties props;
>  		struct pci_dev *pdev;
>  		acpi_handle acpi_parent;
> @@ -1344,8 +1344,8 @@ acpi_video_switch_brightness(struct acpi
>  	unsigned long long level_current, level_next;
>  	int result =3D -EINVAL;
> =20
> -	/* no warning message if acpi_backlight=3Dvendor or a quirk is used */
> -	if (!acpi_video_verify_backlight_support())
> +	/* no warning message if acpi_backlight=3Dvendor is used */
> +	if (!acpi_video_backlight_support())
>  		return 0;
> =20
>  	if (!device->brightness)
> @@ -1843,46 +1843,6 @@ static int acpi_video_bus_remove(struct
>  	return 0;
>  }
> =20
> -static acpi_status video_unregister_backlight(acpi_handle handle, u32 lv=
l,
> -					      void *context, void **rv)
> -{
> -	struct acpi_device *acpi_dev;
> -	struct acpi_video_bus *video;
> -	struct acpi_video_device *dev, *next;
> -
> -	if (acpi_bus_get_device(handle, &acpi_dev))
> -		return AE_OK;
> -
> -	if (acpi_match_device_ids(acpi_dev, video_device_ids))
> -		return AE_OK;
> -
> -	video =3D acpi_driver_data(acpi_dev);
> -	if (!video)
> -		return AE_OK;
> -
> -	acpi_video_bus_stop_devices(video);
> -	mutex_lock(&video->device_list_lock);
> -	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
> -		if (dev->backlight) {
> -			backlight_device_unregister(dev->backlight);
> -			dev->backlight =3D NULL;
> -			kfree(dev->brightness->levels);
> -			kfree(dev->brightness);
> -		}
> -		if (dev->cooling_dev) {
> -			sysfs_remove_link(&dev->dev->dev.kobj,
> -					  "thermal_cooling");
> -			sysfs_remove_link(&dev->cooling_dev->device.kobj,
> -					  "device");
> -			thermal_cooling_device_unregister(dev->cooling_dev);
> -			dev->cooling_dev =3D NULL;
> -		}
> -	}
> -	mutex_unlock(&video->device_list_lock);
> -	acpi_video_bus_start_devices(video);
> -	return AE_OK;
> -}
> -
>  static int __init is_i740(struct pci_dev *dev)
>  {
>  	if (dev->device =3D=3D 0x00D1)
> @@ -1914,25 +1874,14 @@ static int __init intel_opregion_present
>  	return opregion;
>  }
> =20
> -int __acpi_video_register(bool backlight_quirks)
> +int acpi_video_register(void)
>  {
> -	bool no_backlight;
> -	int result;
> -
> -	no_backlight =3D backlight_quirks ? acpi_video_backlight_quirks() : fal=
se;
> -
> +	int result =3D 0;
>  	if (register_count) {
>  		/*
> -		 * If acpi_video_register() has been called already, don't try
> -		 * to register acpi_video_bus, but unregister backlight devices
> -		 * if no backlight support is requested.
> +		 * if the function of acpi_video_register is already called,
> +		 * don't register the acpi_vide_bus again and return no error.
>  		 */
> -		if (no_backlight)
> -			acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
> -					    ACPI_UINT32_MAX,
> -					    video_unregister_backlight,
> -					    NULL, NULL, NULL);
> -
>  		return 0;
>  	}
> =20
> @@ -1948,7 +1897,7 @@ int __acpi_video_register(bool backlight
> =20
>  	return 0;
>  }
> -EXPORT_SYMBOL(__acpi_video_register);
> +EXPORT_SYMBOL(acpi_video_register);
> =20
>  void acpi_video_unregister(void)
>  {
> Index: linux-pm/drivers/gpu/drm/i915/i915_dma.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/gpu/drm/i915/i915_dma.c
> +++ linux-pm/drivers/gpu/drm/i915/i915_dma.c
> @@ -1648,7 +1648,7 @@ int i915_driver_load(struct drm_device *
>  	if (INTEL_INFO(dev)->num_pipes) {
>  		/* Must be done after probing outputs */
>  		intel_opregion_init(dev);
> -		acpi_video_register_with_quirks();
> +		acpi_video_register();
>  	}
> =20
>  	if (IS_GEN5(dev))
> Index: linux-pm/include/acpi/video.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/include/acpi/video.h
> +++ linux-pm/include/acpi/video.h
> @@ -17,21 +17,12 @@ struct acpi_device;
>  #define ACPI_VIDEO_DISPLAY_LEGACY_TV      0x0200
> =20
>  #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
> -extern int __acpi_video_register(bool backlight_quirks);
> -static inline int acpi_video_register(void)
> -{
> -	return __acpi_video_register(false);
> -}
> -static inline int acpi_video_register_with_quirks(void)
> -{
> -	return __acpi_video_register(true);
> -}
> +extern int acpi_video_register(void);
>  extern void acpi_video_unregister(void);
>  extern int acpi_video_get_edid(struct acpi_device *device, int type,
>  			       int device_id, void **edid);
>  #else
>  static inline int acpi_video_register(void) { return 0; }
> -static inline int acpi_video_register_with_quirks(void) { return 0; }
>  static inline void acpi_video_unregister(void) { return; }
>  static inline int acpi_video_get_edid(struct acpi_device *device, int ty=
pe,
>  				      int device_id, void **edid)
> Index: linux-pm/drivers/acpi/video_detect.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/acpi/video_detect.c
> +++ linux-pm/drivers/acpi/video_detect.c
> @@ -235,12 +235,7 @@ static void acpi_video_caps_check(void)
> =20
>  bool acpi_video_backlight_quirks(void)
>  {
> -	if (acpi_gbl_osi_data >=3D ACPI_OSI_WIN_8) {
> -		acpi_video_caps_check();
> -		acpi_video_support |=3D ACPI_VIDEO_SKIP_BACKLIGHT;
> -		return true;
> -	}
> -	return false;
> +	return acpi_gbl_osi_data >=3D ACPI_OSI_WIN_8;
>  }
>  EXPORT_SYMBOL(acpi_video_backlight_quirks);
> =20
> @@ -288,14 +283,6 @@ int acpi_video_backlight_support(void)
>  }
>  EXPORT_SYMBOL(acpi_video_backlight_support);
> =20
> -/* For the ACPI video driver use only. */
> -bool acpi_video_verify_backlight_support(void)
> -{
> -	return (acpi_video_support & ACPI_VIDEO_SKIP_BACKLIGHT) ?
> -		false : acpi_video_backlight_support();
> -}
> -EXPORT_SYMBOL(acpi_video_verify_backlight_support);
> -
>  /*
>   * Use acpi_backlight=3Dvendor/video to force that backlight switching
>   * is processed by vendor specific acpi drivers or video.ko driver.
> Index: linux-pm/include/linux/acpi.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/include/linux/acpi.h
> +++ linux-pm/include/linux/acpi.h
> @@ -191,7 +191,6 @@ extern bool wmi_has_guid(const char *gui
>  #define ACPI_VIDEO_BACKLIGHT_DMI_VIDEO			0x0200
>  #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VENDOR		0x0400
>  #define ACPI_VIDEO_OUTPUT_SWITCHING_DMI_VIDEO		0x0800
> -#define ACPI_VIDEO_SKIP_BACKLIGHT			0x1000
> =20
>  #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
> =20
> Index: linux-pm/drivers/acpi/internal.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/acpi/internal.h
> +++ linux-pm/drivers/acpi/internal.h
> @@ -169,10 +169,8 @@ int acpi_create_platform_device(struct a
>    ----------------------------------------------------------------------=
---- */
>  #if defined(CONFIG_ACPI_VIDEO) || defined(CONFIG_ACPI_VIDEO_MODULE)
>  bool acpi_video_backlight_quirks(void);
> -bool acpi_video_verify_backlight_support(void);
>  #else
>  static inline bool acpi_video_backlight_quirks(void) { return false; }
> -static inline bool acpi_video_verify_backlight_support(void) { return fa=
lse; }
>  #endif
> =20
>  #endif /* _ACPI_INTERNAL_H_ */
>=20


--=-XKGbTPHwm9yG8MsZlw+G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR8TmFAAoJEHqwmdxYrXhZydAP/0Eprr5yT1bz2q0KfBLkL9EY
ozS99wjplnEjmO0XV3B652a52jb1yKofjnK9Y8DTfz0DAcP7vRtR+DjJNIkFW7af
Zs16Pv07cetVHKD0wD5opxaMcm7mAj+mtvG3eb5xX5V1jvaSG807iBeLYzzhtqnC
EPh6jlvbT8ofghWg/028MOd1q1cmQG4R1tNjpukzsKyiErYpt0AWM4hvob+T85/1
8fbir1kb3trXJY9WunHkuUVbIzhC7XoNL1cXZ0NP3XsGoJmp8PAo9WeOurix7M2R
XClsMJyUBSRliCbUlI47G6g2m1rqxF5022bkAcQMjLgHkK2dzUDisZcBboEoZkWr
r3IzqHgSiHAio/8ug8oSEwIw0ENEqk/prHG4tEw0d0nZBSJjxbYnQ5gp0K+7W5o/
pE8I/SMapvKWi+OICAmMADzEyHACizxHVxEGQ+d8Ye2LwNmqNJeODWVo2IvIILiq
3+HtbDtBFia6Mgn7PbtIKsOSjYj7L0q5uoykvF4CEd51xOkqknkXgofZU7bX8C4q
Uhu71tYHBOVHpgmpoAUpOZVWws/fI1xbDihI7FJECy4+39vKGck3yKYmmoyuPXjp
v6bT5mp+fcWBoyCqG/1vO8TGNkLBHKHTjJ/+AGMF/y2zs2TuufVCrt4KOuthbb9u
dyfZRFMPynROZW+dNojm
=0p7V
-----END PGP SIGNATURE-----

--=-XKGbTPHwm9yG8MsZlw+G--

