Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3F0GOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:14:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46263 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab3F0GOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:14:43 -0400
Date: Thu, 27 Jun 2013 09:14:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: regression caused by commit 8357b48549e17b3e4e402c7f977b65708922e60f
Message-ID: <20130627061419.GE15455@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after commit 8357b48549e17b3e4e402c7f977b65708922e60f,
omap2plus_defconfig doesn't 'hold' the answer to USB Gadget Drivers
anymore. Everytime I run oldconfig, it asks me again and again what USB
Gadget Drivers should be (M/y/?).

That's certainly not expected considering it wasn't like that before.

Here's what happens:

$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" omap2plus_defconfig
  GEN     /home/build/arm/Makefile
#
# configuration written to .config
#
$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" oldconfig
  GEN     /home/build/arm/Makefile
scripts/kconfig/conf --oldconfig Kconfig
*
* Restart config...
*
*
* USB Gadget Support
*
USB Gadget Support (USB_GADGET) [Y/n/m/?] y
  Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
  Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [Y/n/?=
] y
  Debugging information files in debugfs (DEVELOPMENT) (USB_GADGET_DEBUG_FS=
) [Y/n/?] y
  Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
  Number of storage pipeline buffers (USB_GADGET_STORAGE_NUM_BUFFERS) [2] 2
  *
  * USB Peripheral Controller
  *
  Faraday FUSB300 USB Peripheral Controller (USB_FUSB300) [N/m/y/?] n
  Faraday FOTG210 USB Peripheral Controller (USB_FOTG210_UDC) [N/m/y/?] n
  Renesas R8A66597 USB Peripheral Controller (USB_R8A66597) [N/m/y/?] n
  PXA 27x (USB_PXA27X) [N/m/y/?] n
  Marvell USB2.0 Device Controller (USB_MV_UDC) [N/m/y/?] n
  MARVELL PXA2128 USB 3.0 controller (USB_MV_U3D) [N/m/y/?] n
  Renesas M66592 USB Peripheral Controller (USB_M66592) [N/m/y/?] n
  PLX NET2272 (USB_NET2272) [N/m/y/?] n
  Dummy HCD (DEVELOPMENT) (USB_DUMMY_HCD) [N/m/y/?] n
  USB Gadget Drivers [M/y/?] (NEW) m
    USB functions configurable through configfs (USB_CONFIGFS) [N/m/?] n
    Gadget Zero (DEVELOPMENT) (USB_ZERO) [M/n/?] m
    Audio Gadget (USB_AUDIO) [N/m/?] n
    Ethernet Gadget (with CDC Ethernet support) (USB_ETH) [N/m/?] n
    Network Control Model (NCM) support (USB_G_NCM) [N/m/?] n
    Gadget Filesystem (USB_GADGETFS) [N/m/?] n
    Function Filesystem (USB_FUNCTIONFS) [N/m/?] n
    Mass Storage Gadget (USB_MASS_STORAGE) [N/m/?] n
    Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL) [N/m/?=
] n
    MIDI Gadget (USB_MIDI_GADGET) [N/m/?] n
    Printer Gadget (USB_G_PRINTER) [N/m/?] n
    CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE) [N/m/?] n
    CDC Composite Device (ACM and mass storage) (USB_G_ACM_MS) [N/m/?] n
    Multifunction Composite Gadget (USB_G_MULTI) [N/m/?] n
    HID Gadget (USB_G_HID) [N/m/?] n
    EHCI Debug Device Gadget (USB_G_DBGP) [N/m/?] n
#
# configuration written to .config
#
$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" oldconfig
  GEN     /home/build/arm/Makefile
scripts/kconfig/conf --oldconfig Kconfig
*
* Restart config...
*
*
* USB Gadget Support
*
USB Gadget Support (USB_GADGET) [Y/n/m/?] y
  Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [Y/n/?] y
  Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [Y/n/?=
] y
  Debugging information files in debugfs (DEVELOPMENT) (USB_GADGET_DEBUG_FS=
) [Y/n/?] y
  Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
  Number of storage pipeline buffers (USB_GADGET_STORAGE_NUM_BUFFERS) [2] 2
  *
  * USB Peripheral Controller
  *
  Faraday FUSB300 USB Peripheral Controller (USB_FUSB300) [N/m/y/?] n
  Faraday FOTG210 USB Peripheral Controller (USB_FOTG210_UDC) [N/m/y/?] n
  Renesas R8A66597 USB Peripheral Controller (USB_R8A66597) [N/m/y/?] n
  PXA 27x (USB_PXA27X) [N/m/y/?] n
  Marvell USB2.0 Device Controller (USB_MV_UDC) [N/m/y/?] n
  MARVELL PXA2128 USB 3.0 controller (USB_MV_U3D) [N/m/y/?] n
  Renesas M66592 USB Peripheral Controller (USB_M66592) [N/m/y/?] n
  PLX NET2272 (USB_NET2272) [N/m/y/?] n
  Dummy HCD (DEVELOPMENT) (USB_DUMMY_HCD) [N/m/y/?] n
  USB Gadget Drivers [M/y/?] (NEW) m
    USB functions configurable through configfs (USB_CONFIGFS) [N/m/?] n
    Gadget Zero (DEVELOPMENT) (USB_ZERO) [M/n/?] m
    Audio Gadget (USB_AUDIO) [N/m/?] n
    Ethernet Gadget (with CDC Ethernet support) (USB_ETH) [N/m/?] n
    Network Control Model (NCM) support (USB_G_NCM) [N/m/?] n
    Gadget Filesystem (USB_GADGETFS) [N/m/?] n
    Function Filesystem (USB_FUNCTIONFS) [N/m/?] n
    Mass Storage Gadget (USB_MASS_STORAGE) [N/m/?] n
    Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL) [N/m/?=
] n
    MIDI Gadget (USB_MIDI_GADGET) [N/m/?] n
    Printer Gadget (USB_G_PRINTER) [N/m/?] n
    CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE) [N/m/?] n
    CDC Composite Device (ACM and mass storage) (USB_G_ACM_MS) [N/m/?] n
    Multifunction Composite Gadget (USB_G_MULTI) [N/m/?] n
    HID Gadget (USB_G_HID) [N/m/?] n
    EHCI Debug Device Gadget (USB_G_DBGP) [N/m/?] n
#
# configuration written to .config
#

Reverting that patch alone on linux-next helps:

$ git show
commit ddbf0162837ce7ada497f9bf2143f20c73e96c20
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Wed Jun 26 17:57:47 2013 +1000

    Add linux-next specific files for 20130626
   =20
    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

$ git revert 8357b48549e17b3e4e402c7f977b65708922e60f

$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" omap2plus_defconfig
  GEN     /home/build/arm/Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
#
# configuration written to .config
#
$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" oldconfig
  GEN     /home/build/arm/Makefile
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#
$ make -j18 O=3D/home/build/arm ARCH=3Darm CONFIG_DEBUG_SECTION_MISMATCH=3D=
y CROSS_COMPILE=3D"ccache arm-linux-" oldconfig
  GEN     /home/build/arm/Makefile
scripts/kconfig/conf --oldconfig Kconfig
#
# configuration written to .config
#

Here's bisection log:

8357b48549e17b3e4e402c7f977b65708922e60f is the first bad commit
commit 8357b48549e17b3e4e402c7f977b65708922e60f
Author: Yann E. MORIN <yann.morin.1998@free.fr>
Date:   Tue Jun 18 19:35:29 2013 +0200

    kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
   =20
    Currently, randconfig does randomise choice entries, unless KCONFIG_ALL=
CONFIG
    is specified.
   =20
    For example, given those two files (Thomas' test-case):
   =20
        ---8<--- Config.test.in
        config OPTIONA
            bool "Option A"
   =20
        choice
            prompt "This is a choice"
   =20
        config CHOICE_OPTIONA
            bool "Choice Option A"
   =20
        config CHOICE_OPTIONB
            bool "Choice Option B"
   =20
        endchoice
   =20
        config OPTIONB
            bool "Option B"
        ---8<--- Config.test.in
   =20
        ---8<--- config.defaults
        CONFIG_OPTIONA=3Dy
        ---8<--- config.defaults
   =20
    And running:
        ./scripts/kconfig/conf --randconfig Config.test.in
   =20
    does properly randomise the two choice symbols (and the two booleans).
   =20
    However, running:
        KCONFIG_ALLCONFIG=3Dconfig.defaults \
        ./scripts/kconfig/conf --randconfig Config.test.in
   =20
    does *not* reandomise the two choice entries, and only CHOICE_OPTIONA
    will ever be selected. (OPTIONA will always be set (expected), and
    OPTIONB will be be properly randomised (expected).)
   =20
    This patch defers setting that a choice has a value until a symbol for
    that choice is indeed set, so that choices are properly randomised when
    KCONFIG_ALLCONFIG is set, but not if a symbol for that choice is set.
   =20
    Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
    Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Cc: Michal Marek <mmarek@suse.cz>
    Cc: Sam Ravnborg <sam@ravnborg.org>
    Cc: Sedat Dilek <sedat.dilek@gmail.com>
    Cc: Arnd Bergmann <arnd@arndb.de>
    Cc: Stephen Rothwell <sfr@canb.auug.org.au>
   =20
    ---
    Changes v3 -> v4
      - fix previous issue where some choices would not be set, which would
        cause silentoldconfig to ask for them and was then breaking this
        workflow (as reported by Arnd and Sedat):
            KCONFIG_ALLCONFIG=3Dfoo.defconfig make randconfig
            make silentoldconfig </dev/nullo
        which I have tested (3h28min!) with:
            touch defconfig
            for(( i=3D0; i<10000; i++ )); do
                KCONFIG_ALLCONFIG=3D$(pwd)/defconfig make randconfig >/dev/=
null 2>&1
                make silentoldconfig </dev/null >/dev/null 2>&1 || break
            done
        which did not break at all.
      - change done in v3 (below) is already fixed by a previous patch
   =20
    Changes v2 -> v3
      - ensure only one symbol is set in a choice
   =20
    Changes v1 -> v2:
      - further postpone setting that a choice has a value until
        one is indeed set
      - do not print symbols that are part of an invisible choice
:040000 040000 cf18e4740ade73c191d8905f35b2c97abdf4bfcf be417fef0c309c2301b=
671ca8c19ca5b27ce8486 M      scripts


$ git bisect log
git bisect start
# good: [9e895ace5d82df8929b16f58e9f515f6d54ab82d] Linux 3.10-rc7
git bisect good 9e895ace5d82df8929b16f58e9f515f6d54ab82d
# bad: [ddbf0162837ce7ada497f9bf2143f20c73e96c20] Add linux-next specific f=
iles for 20130626
git bisect bad ddbf0162837ce7ada497f9bf2143f20c73e96c20
# bad: [68f1af44fb82f16925e50ef4f15998c9933759a2] Merge remote-tracking bra=
nch 'md/for-next'
git bisect bad 68f1af44fb82f16925e50ef4f15998c9933759a2
# bad: [dcef7c4c971c7f299f097cc78776b4845a7f5bb2] Merge remote-tracking bra=
nch 'slave-dma/next'
git bisect bad dcef7c4c971c7f299f097cc78776b4845a7f5bb2
# good: [5fafb18bbf542079abfaf91bf405a9ede33c511a] Merge remote-tracking br=
anch 'vfs/for-next'
git bisect good 5fafb18bbf542079abfaf91bf405a9ede33c511a
# good: [563709c0f179278edfa4518e9b53ae3054d1cb36] Merge remote-tracking br=
anch 'v4l-dvb/master'
git bisect good 563709c0f179278edfa4518e9b53ae3054d1cb36
# bad: [1e701aae3f0cbe714ee3e5feb84e830fc4688634] Merge remote-tracking bra=
nch 'pm/linux-next'
git bisect bad 1e701aae3f0cbe714ee3e5feb84e830fc4688634
# good: [414ca3e0fdfbb18b7871bf526fc94c3ca8220d6e] Merge branch 'fixes' int=
o linux-next
git bisect good 414ca3e0fdfbb18b7871bf526fc94c3ca8220d6e
# good: [6c685e78be5ea91c7e938e29d7ba1fcaa77bd58f] Merge branch 'pm-cpufreq=
-next' into linux-next
git bisect good 6c685e78be5ea91c7e938e29d7ba1fcaa77bd58f
# good: [930ed52c88da2229040caabe975fc5f2e4350d22] Merge branch 'for-3.11' =
into for-next
git bisect good 930ed52c88da2229040caabe975fc5f2e4350d22
# bad: [8357b48549e17b3e4e402c7f977b65708922e60f] kconfig: fix randomising =
choice entries in presence of KCONFIG_ALLCONFIG
git bisect bad 8357b48549e17b3e4e402c7f977b65708922e60f
# good: [1278ebdbc3167883f32095491990fbdc7cdf8b5e] mconf/nconf: mark empty =
menus/menuconfigs different from non-empty ones
git bisect good 1278ebdbc3167883f32095491990fbdc7cdf8b5e
# good: [a5f6d795f5941e97e757b643a6482968a66c6150] kconfig/conf: print the =
seed used to initialise the RNG for randconfig
git bisect good a5f6d795f5941e97e757b643a6482968a66c6150
# good: [a1ce636f560336ba007bfabb15b167ff31b592cf] kconfig/[mn]conf: make i=
t explicit in the search box that a regexp is possible
git bisect good a1ce636f560336ba007bfabb15b167ff31b592cf
# good: [3b9a19e08960e5cdad5253998637653e592a3c29] kconfig: loop as long as=
 we changed some symbols in randconfig
git bisect good 3b9a19e08960e5cdad5253998637653e592a3c29

--=20
balbi

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRy9g6AAoJEIaOsuA1yqREGkgQAK+vo4f0HgRtAJHzROo8zSKT
fUIhALZwYK5mC6Z3WsQtZNt0npzXU1ndM+r6VYjQ4lZ+PSSarBl9F+waVeJRA3lt
WVT5G2bSVj8xqS5UXuLmwDmXcFlha/o9cw51fACTO+Fg++U7bJZykAQh4sqyAiC9
u8CPobEXQSeOXbfzxQ+wb5DfOFPwiwHGa1V8iK3sdFPMC9D7ss7GxeToU5xGcmXL
D+wBOI+bmPejHU+7h3FpCq5mL1k/8KfRUO0qZQ9o3IHCoHXCiHQlQj3oXbxKLTG1
QZiZupT+Q6GTFJ2GQf3Jqzh1S1/grbFIxiexi2YOpCJ3JiYG2dfbbHdNeEHqvFPc
lARpr+/YqAzLsT+r4vO5vF8S92SRTrrnpWYyYwJrJl/SBi6oBsAA3NN0Juv+1DPg
m0+sVP7zwCou4zvWWhXZhOmRMlODiM6Qi8Ic5k6RjBYwi/kvm3QhklpqZ+eOfbDy
nFhUD80CwJ3x5lITPC3IKU6t9DR/cv/lZyuQn0tIlz44pllbx6jBoeEIuY9AXdl7
c50UUByEPR0KAbQQEbqXZeLVq5hOr623Cd75rjUaM4EcplBc9kBAe/t+e5tyY8ly
PmRWpmQHYV0XQGgN67guxdn5BQ0imt+ZOJ5lXvHLuEG3t+yRXoTZD3bEzKjafKuW
GbIpPje2Dm+x7xjD6BTW
=XS2U
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
