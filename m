Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaKRMDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:03:43 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36134 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaKRMDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:03:41 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-53-546b35996935
Message-id: <546B3599.7080806@samsung.com>
Date: Tue, 18 Nov 2014 15:03:37 +0300
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Icedove/31.2.0
MIME-version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Makefile: sort list of defconfig targets in make help
 output
References: <20141028141820.14137.64256.stgit@buzz>
In-reply-to: <20141028141820.14137.64256.stgit@buzz>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7ozTbNDDB6dMrf4s2sHk8XlXXPY
	LFr2XWByYPY4s+AIu8fnTXIBTFFcNimpOZllqUX6dglcGSt33GAsWHiaseL2witMDYz9/Yxd
	jJwcEgImEqu+dLJD2GISF+6tZ+ti5OIQEljKKLHszC4o5xOjxL2OyywgVbwCWhIHL79gBbFZ
	BFQlGre0sYHYbAJmEtv23QabKioQIjHn6W0miHpBiR+T74H1igjES3Q0rGPuYuTgEBYIlviy
	2hckLCRgLPH0xUlmEJsT6KDtu76DlTMDjfzy8jArhC0vsXnNW+YJjPyzkEydhaRsFpKyBYzM
	qxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCQvHrDsalx6wOMQpwMCrx8DZszAoRYk0sK67M
	PcQowcGsJMJ7rhsoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdH/1s5jk/PUc76/t77yIcHt+M63
	baf83y/6/E/Y79RR3cDiqclL9/ImCzRXRpV5nP/9I7V81i32v2vvrpv0OHfh93qHrAXHwr5X
	3l/7Tm3+rxqDlNUCJ4SYco4+iuX/5LpoT+3/BjuHVpkal+fTq3zeH/b49C1gb+TCJ6GCbOcf
	m+0/s5Nn88J5SizFGYmGWsxFxYkAtjyvayMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-28 16:18, Konstantin Khlebnikov wrote:
> Without sorting this list is completely unreadable for ARCH=arm.

Bump.

Just feel the difference. Before:

khlebnikov@buzz:~/src/linux-arm$ make ARCH=arm help
Cleaning targets:
   clean          - Remove most generated files but keep the config and
                     enough build support to build external modules
   mrproper      - Remove all generated files + config + various backup 
files
   distclean      - mrproper + remove editor backup and patch files

Configuration targets:
   config      - Update current config utilising a line-oriented program
   nconfig         - Update current config utilising a ncurses menu 
based program
   menuconfig      - Update current config utilising a menu based program
   xconfig      - Update current config utilising a QT based front-end
   gconfig      - Update current config utilising a GTK based front-end
   oldconfig      - Update current config utilising a provided .config 
as base
   localmodconfig  - Update current config disabling modules not loaded
   localyesconfig  - Update current config converting local mods to core
   silentoldconfig - Same as oldconfig, but quietly, additionally update 
deps
   defconfig      - New config with default from ARCH supplied defconfig
   savedefconfig   - Save current config as ./defconfig (minimal config)
   allnoconfig      - New config where all options are answered with no
   allyesconfig      - New config where all options are accepted with yes
   allmodconfig      - New config selecting modules when possible
   alldefconfig    - New config with all symbols set to default
   randconfig      - New config with random answer to all options
   listnewconfig   - List new options
   olddefconfig      - Same as silentoldconfig but sets new symbols to 
their default value
   kvmconfig      - Enable additional options for guest kernel support
   tinyconfig      - Configure the tiniest possible kernel

Other generic targets:
   all          - Build all targets marked with [*]
* vmlinux      - Build the bare kernel
* modules      - Build all modules
   modules_install - Install all modules to INSTALL_MOD_PATH (default: /)
   firmware_install- Install all firmware to INSTALL_FW_PATH
                     (default: $(INSTALL_MOD_PATH)/lib/firmware)
   dir/            - Build all files in dir and below
   dir/file.[oisS] - Build specified target only
   dir/file.lst    - Build specified mixed source/assembly target only
                     (requires a recent binutils and recent build 
(System.map))
   dir/file.ko     - Build module including final link
   modules_prepare - Set up for building external modules
   tags/TAGS      - Generate tags file for editors
   cscope      - Generate cscope index
   gtags           - Generate GNU GLOBAL index
   kernelrelease      - Output the release version string (use with make -s)
   kernelversion      - Output the version stored in Makefile (use with 
make -s)
   image_name      - Output the image name (use with make -s)
   headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH
                     (default: ./usr)

Static analysers
   checkstack      - Generate a list of stack hogs
   namespacecheck  - Name space analysis on compiled kernel
   versioncheck    - Sanity check on version.h usage
   includecheck    - Check for duplicate included header files
   export_report   - List the usages of all exported symbols
   headers_check   - Sanity check on exported headers
   headerdep       - Detect inclusion cycles in headers
   coccicheck      - Check with Coccinelle.

Kernel selftest
   kselftest       - Build and run kernel selftest (run as root)
                     Build, install, and boot kernel before
                     running kselftest on it

Kernel packaging:
   rpm-pkg             - Build both source and binary RPM kernel packages
   binrpm-pkg          - Build only the binary kernel package
   deb-pkg             - Build the kernel as a deb package
   tar-pkg             - Build the kernel as an uncompressed tarball
   targz-pkg           - Build the kernel as a gzip compressed tarball
   tarbz2-pkg          - Build the kernel as a bzip2 compressed tarball
   tarxz-pkg           - Build the kernel as a xz compressed tarball
   perf-tar-src-pkg    - Build perf-3.18.0-rc5.tar source tarball
   perf-targz-src-pkg  - Build perf-3.18.0-rc5.tar.gz source tarball
   perf-tarbz2-src-pkg - Build perf-3.18.0-rc5.tar.bz2 source tarball
   perf-tarxz-src-pkg  - Build perf-3.18.0-rc5.tar.xz source tarball

Documentation targets:
  Linux kernel internal documentation in different formats:
   htmldocs        - HTML
   pdfdocs         - PDF
   psdocs          - Postscript
   xmldocs         - XML DocBook
   mandocs         - man pages
   installmandocs  - install man pages generated by mandocs
   cleandocs       - clean all generated DocBook files

Architecture specific targets (arm):
* zImage        - Compressed kernel image (arch/arm/boot/zImage)
   Image         - Uncompressed kernel image (arch/arm/boot/Image)
* xipImage      - XIP kernel image, if configured (arch/arm/boot/xipImage)
   uImage        - U-Boot wrapped zImage
   bootpImage    - Combined zImage and initial RAM disk
                   (supply initrd image via make variable INITRD=<path>)
* dtbs          - Build device tree blobs for enabled boards
   dtbs_install  - Install dtbs to /boot/dtbs/
   install       - Install uncompressed kernel
   zinstall      - Install compressed kernel
   uinstall      - Install U-Boot wrapped compressed kernel
                   Install using (your) ~/bin/installkernel or
                   (distribution) /sbin/installkernel or
                   install to $(INSTALL_PATH) and run lilo

   axm55xx_defconfig        - Build for axm55xx
   at91sam9261_9g10_defconfig - Build for at91sam9261_9g10
   clps711x_defconfig       - Build for clps711x
   mainstone_defconfig      - Build for mainstone
   mini2440_defconfig       - Build for mini2440
   koelsch_defconfig        - Build for koelsch
   at91x40_defconfig        - Build for at91x40
   lpd270_defconfig         - Build for lpd270
   sunxi_defconfig          - Build for sunxi
   nuc910_defconfig         - Build for nuc910
   mmp2_defconfig           - Build for mmp2
   integrator_defconfig     - Build for integrator
   mackerel_defconfig       - Build for mackerel
   vexpress_defconfig       - Build for vexpress
   at91sam9rl_defconfig     - Build for at91sam9rl
   trizeps4_defconfig       - Build for trizeps4
   cm_x300_defconfig        - Build for cm_x300
   multi_v7_defconfig       - Build for multi_v7
   prima2_defconfig         - Build for prima2
   omap1_defconfig          - Build for omap1
   cm_x2xx_defconfig        - Build for cm_x2xx
   hisi_defconfig           - Build for hisi
   keystone_defconfig       - Build for keystone
   em_x270_defconfig        - Build for em_x270
   collie_defconfig         - Build for collie
   pleb_defconfig           - Build for pleb
   cns3420vb_defconfig      - Build for cns3420vb
   netx_defconfig           - Build for netx
   palmz72_defconfig        - Build for palmz72
   eseries_pxa_defconfig    - Build for eseries_pxa
   u300_defconfig           - Build for u300
   badge4_defconfig         - Build for badge4
   spitz_defconfig          - Build for spitz
   s5pv210_defconfig        - Build for s5pv210
   davinci_all_defconfig    - Build for davinci_all
   ezx_defconfig            - Build for ezx
   jornada720_defconfig     - Build for jornada720
   viper_defconfig          - Build for viper
   imote2_defconfig         - Build for imote2
   pxa3xx_defconfig         - Build for pxa3xx
   am200epdkit_defconfig    - Build for am200epdkit
   pxa168_defconfig         - Build for pxa168
   cerfcube_defconfig       - Build for cerfcube
   shmobile_defconfig       - Build for shmobile
   colibri_pxa300_defconfig - Build for colibri_pxa300
   bcm2835_defconfig        - Build for bcm2835
   zeus_defconfig           - Build for zeus
   multi_v5_defconfig       - Build for multi_v5
   ebsa110_defconfig        - Build for ebsa110
   nuc960_defconfig         - Build for nuc960
   bockw_defconfig          - Build for bockw
   at91sam9260_9g20_defconfig - Build for at91sam9260_9g20
   iop13xx_defconfig        - Build for iop13xx
   tct_hammer_defconfig     - Build for tct_hammer
   dove_defconfig           - Build for dove
   shannon_defconfig        - Build for shannon
   lager_defconfig          - Build for lager
   colibri_pxa270_defconfig - Build for colibri_pxa270
   vt8500_v6_v7_defconfig   - Build for vt8500_v6_v7
   raumfeld_defconfig       - Build for raumfeld
   mxs_defconfig            - Build for mxs
   nuc950_defconfig         - Build for nuc950
   corgi_defconfig          - Build for corgi
   iop32x_defconfig         - Build for iop32x
   footbridge_defconfig     - Build for footbridge
   rpc_defconfig            - Build for rpc
   s3c6400_defconfig        - Build for s3c6400
   sama5_defconfig          - Build for sama5
   at91_dt_defconfig        - Build for at91_dt
   pcm027_defconfig         - Build for pcm027
   pxa910_defconfig         - Build for pxa910
   mv78xx0_defconfig        - Build for mv78xx0
   realview_defconfig       - Build for realview
   ks8695_defconfig         - Build for ks8695
   ape6evm_defconfig        - Build for ape6evm
   imx_v4_v5_defconfig      - Build for imx_v4_v5
   armadillo800eva_defconfig - Build for armadillo800eva
   marzen_defconfig         - Build for marzen
   lpc32xx_defconfig        - Build for lpc32xx
   assabet_defconfig        - Build for assabet
   kzm9g_defconfig          - Build for kzm9g
   h5000_defconfig          - Build for h5000
   mvebu_v7_defconfig       - Build for mvebu_v7
   lubbock_defconfig        - Build for lubbock
   nhk8815_defconfig        - Build for nhk8815
   at91rm9200_defconfig     - Build for at91rm9200
   netwinder_defconfig      - Build for netwinder
   qcom_defconfig           - Build for qcom
   iop33x_defconfig         - Build for iop33x
   xcep_defconfig           - Build for xcep
   efm32_defconfig          - Build for efm32
   tegra_defconfig          - Build for tegra
   realview-smp_defconfig   - Build for realview-smp
   orion5x_defconfig        - Build for orion5x
   acs5k_defconfig          - Build for acs5k
   ixp4xx_defconfig         - Build for ixp4xx
   at91sam9263_defconfig    - Build for at91sam9263
   s3c2410_defconfig        - Build for s3c2410
   magician_defconfig       - Build for magician
   acs5k_tiny_defconfig     - Build for acs5k_tiny
   socfpga_defconfig        - Build for socfpga
   moxart_defconfig         - Build for moxart
   hackkit_defconfig        - Build for hackkit
   msm_defconfig            - Build for msm
   h3600_defconfig          - Build for h3600
   u8500_defconfig          - Build for u8500
   imx_v6_v7_defconfig      - Build for imx_v6_v7
   at91sam9g45_defconfig    - Build for at91sam9g45
   simpad_defconfig         - Build for simpad
   versatile_defconfig      - Build for versatile
   exynos_defconfig         - Build for exynos
   spear13xx_defconfig      - Build for spear13xx
   omap2plus_defconfig      - Build for omap2plus
   mvebu_v5_defconfig       - Build for mvebu_v5
   bcm_defconfig            - Build for bcm
   spear3xx_defconfig       - Build for spear3xx
   lart_defconfig           - Build for lart
   pxa255-idp_defconfig     - Build for pxa255-idp
   neponset_defconfig       - Build for neponset
   ep93xx_defconfig         - Build for ep93xx
   spear6xx_defconfig       - Build for spear6xx

   make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build
   make V=2   [targets] 2 => give reason for rebuild of target
   make O=dir [targets] Locate all output files in "dir", including .config
   make C=1   [targets] Check all c source with $CHECK (sparse by default)
   make C=2   [targets] Force check of all c source with $CHECK
   make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections
   make W=n   [targets] Enable extra gcc checks, n=1,2,3 where
         1: warnings which may be relevant and do not occur too often
         2: warnings which occur quite often but may still be relevant
         3: more obscure warnings, can most likely be ignored
         Multiple levels can be combined with W=12 or W=123

Execute "make" or "make all" to build all targets marked with [*]
For further info see the ./README file




After:

khlebnikov@buzz:~/src/linux-arm$ make ARCH=arm help
Cleaning targets:
   clean          - Remove most generated files but keep the config and
                     enough build support to build external modules
   mrproper      - Remove all generated files + config + various backup 
files
   distclean      - mrproper + remove editor backup and patch files

Configuration targets:
   config      - Update current config utilising a line-oriented program
   nconfig         - Update current config utilising a ncurses menu 
based program
   menuconfig      - Update current config utilising a menu based program
   xconfig      - Update current config utilising a QT based front-end
   gconfig      - Update current config utilising a GTK based front-end
   oldconfig      - Update current config utilising a provided .config 
as base
   localmodconfig  - Update current config disabling modules not loaded
   localyesconfig  - Update current config converting local mods to core
   silentoldconfig - Same as oldconfig, but quietly, additionally update 
deps
   defconfig      - New config with default from ARCH supplied defconfig
   savedefconfig   - Save current config as ./defconfig (minimal config)
   allnoconfig      - New config where all options are answered with no
   allyesconfig      - New config where all options are accepted with yes
   allmodconfig      - New config selecting modules when possible
   alldefconfig    - New config with all symbols set to default
   randconfig      - New config with random answer to all options
   listnewconfig   - List new options
   olddefconfig      - Same as silentoldconfig but sets new symbols to 
their default value
   kvmconfig      - Enable additional options for guest kernel support
   tinyconfig      - Configure the tiniest possible kernel

Other generic targets:
   all          - Build all targets marked with [*]
* vmlinux      - Build the bare kernel
* modules      - Build all modules
   modules_install - Install all modules to INSTALL_MOD_PATH (default: /)
   firmware_install- Install all firmware to INSTALL_FW_PATH
                     (default: $(INSTALL_MOD_PATH)/lib/firmware)
   dir/            - Build all files in dir and below
   dir/file.[oisS] - Build specified target only
   dir/file.lst    - Build specified mixed source/assembly target only
                     (requires a recent binutils and recent build 
(System.map))
   dir/file.ko     - Build module including final link
   modules_prepare - Set up for building external modules
   tags/TAGS      - Generate tags file for editors
   cscope      - Generate cscope index
   gtags           - Generate GNU GLOBAL index
   kernelrelease      - Output the release version string (use with make -s)
   kernelversion      - Output the version stored in Makefile (use with 
make -s)
   image_name      - Output the image name (use with make -s)
   headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH
                     (default: ./usr)

Static analysers
   checkstack      - Generate a list of stack hogs
   namespacecheck  - Name space analysis on compiled kernel
   versioncheck    - Sanity check on version.h usage
   includecheck    - Check for duplicate included header files
   export_report   - List the usages of all exported symbols
   headers_check   - Sanity check on exported headers
   headerdep       - Detect inclusion cycles in headers
   coccicheck      - Check with Coccinelle.

Kernel selftest
   kselftest       - Build and run kernel selftest (run as root)
                     Build, install, and boot kernel before
                     running kselftest on it

Kernel packaging:
   rpm-pkg             - Build both source and binary RPM kernel packages
   binrpm-pkg          - Build only the binary kernel package
   deb-pkg             - Build the kernel as a deb package
   tar-pkg             - Build the kernel as an uncompressed tarball
   targz-pkg           - Build the kernel as a gzip compressed tarball
   tarbz2-pkg          - Build the kernel as a bzip2 compressed tarball
   tarxz-pkg           - Build the kernel as a xz compressed tarball
   perf-tar-src-pkg    - Build perf-3.18.0-rc5.tar source tarball
   perf-targz-src-pkg  - Build perf-3.18.0-rc5.tar.gz source tarball
   perf-tarbz2-src-pkg - Build perf-3.18.0-rc5.tar.bz2 source tarball
   perf-tarxz-src-pkg  - Build perf-3.18.0-rc5.tar.xz source tarball

Documentation targets:
  Linux kernel internal documentation in different formats:
   htmldocs        - HTML
   pdfdocs         - PDF
   psdocs          - Postscript
   xmldocs         - XML DocBook
   mandocs         - man pages
   installmandocs  - install man pages generated by mandocs
   cleandocs       - clean all generated DocBook files

Architecture specific targets (arm):
* zImage        - Compressed kernel image (arch/arm/boot/zImage)
   Image         - Uncompressed kernel image (arch/arm/boot/Image)
* xipImage      - XIP kernel image, if configured (arch/arm/boot/xipImage)
   uImage        - U-Boot wrapped zImage
   bootpImage    - Combined zImage and initial RAM disk
                   (supply initrd image via make variable INITRD=<path>)
* dtbs          - Build device tree blobs for enabled boards
   dtbs_install  - Install dtbs to /boot/dtbs/
   install       - Install uncompressed kernel
   zinstall      - Install compressed kernel
   uinstall      - Install U-Boot wrapped compressed kernel
                   Install using (your) ~/bin/installkernel or
                   (distribution) /sbin/installkernel or
                   install to $(INSTALL_PATH) and run lilo

   acs5k_defconfig          - Build for acs5k
   acs5k_tiny_defconfig     - Build for acs5k_tiny
   am200epdkit_defconfig    - Build for am200epdkit
   ape6evm_defconfig        - Build for ape6evm
   armadillo800eva_defconfig - Build for armadillo800eva
   assabet_defconfig        - Build for assabet
   at91_dt_defconfig        - Build for at91_dt
   at91rm9200_defconfig     - Build for at91rm9200
   at91sam9260_9g20_defconfig - Build for at91sam9260_9g20
   at91sam9261_9g10_defconfig - Build for at91sam9261_9g10
   at91sam9263_defconfig    - Build for at91sam9263
   at91sam9g45_defconfig    - Build for at91sam9g45
   at91sam9rl_defconfig     - Build for at91sam9rl
   at91x40_defconfig        - Build for at91x40
   axm55xx_defconfig        - Build for axm55xx
   badge4_defconfig         - Build for badge4
   bcm2835_defconfig        - Build for bcm2835
   bcm_defconfig            - Build for bcm
   bockw_defconfig          - Build for bockw
   cerfcube_defconfig       - Build for cerfcube
   clps711x_defconfig       - Build for clps711x
   cm_x2xx_defconfig        - Build for cm_x2xx
   cm_x300_defconfig        - Build for cm_x300
   cns3420vb_defconfig      - Build for cns3420vb
   colibri_pxa270_defconfig - Build for colibri_pxa270
   colibri_pxa300_defconfig - Build for colibri_pxa300
   collie_defconfig         - Build for collie
   corgi_defconfig          - Build for corgi
   davinci_all_defconfig    - Build for davinci_all
   dove_defconfig           - Build for dove
   ebsa110_defconfig        - Build for ebsa110
   efm32_defconfig          - Build for efm32
   em_x270_defconfig        - Build for em_x270
   ep93xx_defconfig         - Build for ep93xx
   eseries_pxa_defconfig    - Build for eseries_pxa
   exynos_defconfig         - Build for exynos
   ezx_defconfig            - Build for ezx
   footbridge_defconfig     - Build for footbridge
   h3600_defconfig          - Build for h3600
   h5000_defconfig          - Build for h5000
   hackkit_defconfig        - Build for hackkit
   hisi_defconfig           - Build for hisi
   imote2_defconfig         - Build for imote2
   imx_v4_v5_defconfig      - Build for imx_v4_v5
   imx_v6_v7_defconfig      - Build for imx_v6_v7
   integrator_defconfig     - Build for integrator
   iop13xx_defconfig        - Build for iop13xx
   iop32x_defconfig         - Build for iop32x
   iop33x_defconfig         - Build for iop33x
   ixp4xx_defconfig         - Build for ixp4xx
   jornada720_defconfig     - Build for jornada720
   keystone_defconfig       - Build for keystone
   koelsch_defconfig        - Build for koelsch
   ks8695_defconfig         - Build for ks8695
   kzm9g_defconfig          - Build for kzm9g
   lager_defconfig          - Build for lager
   lart_defconfig           - Build for lart
   lpc32xx_defconfig        - Build for lpc32xx
   lpd270_defconfig         - Build for lpd270
   lubbock_defconfig        - Build for lubbock
   mackerel_defconfig       - Build for mackerel
   magician_defconfig       - Build for magician
   mainstone_defconfig      - Build for mainstone
   marzen_defconfig         - Build for marzen
   mini2440_defconfig       - Build for mini2440
   mmp2_defconfig           - Build for mmp2
   moxart_defconfig         - Build for moxart
   msm_defconfig            - Build for msm
   multi_v5_defconfig       - Build for multi_v5
   multi_v7_defconfig       - Build for multi_v7
   mv78xx0_defconfig        - Build for mv78xx0
   mvebu_v5_defconfig       - Build for mvebu_v5
   mvebu_v7_defconfig       - Build for mvebu_v7
   mxs_defconfig            - Build for mxs
   neponset_defconfig       - Build for neponset
   netwinder_defconfig      - Build for netwinder
   netx_defconfig           - Build for netx
   nhk8815_defconfig        - Build for nhk8815
   nuc910_defconfig         - Build for nuc910
   nuc950_defconfig         - Build for nuc950
   nuc960_defconfig         - Build for nuc960
   omap1_defconfig          - Build for omap1
   omap2plus_defconfig      - Build for omap2plus
   orion5x_defconfig        - Build for orion5x
   palmz72_defconfig        - Build for palmz72
   pcm027_defconfig         - Build for pcm027
   pleb_defconfig           - Build for pleb
   prima2_defconfig         - Build for prima2
   pxa168_defconfig         - Build for pxa168
   pxa255-idp_defconfig     - Build for pxa255-idp
   pxa3xx_defconfig         - Build for pxa3xx
   pxa910_defconfig         - Build for pxa910
   qcom_defconfig           - Build for qcom
   raumfeld_defconfig       - Build for raumfeld
   realview-smp_defconfig   - Build for realview-smp
   realview_defconfig       - Build for realview
   rpc_defconfig            - Build for rpc
   s3c2410_defconfig        - Build for s3c2410
   s3c6400_defconfig        - Build for s3c6400
   s5pv210_defconfig        - Build for s5pv210
   sama5_defconfig          - Build for sama5
   shannon_defconfig        - Build for shannon
   shmobile_defconfig       - Build for shmobile
   simpad_defconfig         - Build for simpad
   socfpga_defconfig        - Build for socfpga
   spear13xx_defconfig      - Build for spear13xx
   spear3xx_defconfig       - Build for spear3xx
   spear6xx_defconfig       - Build for spear6xx
   spitz_defconfig          - Build for spitz
   sunxi_defconfig          - Build for sunxi
   tct_hammer_defconfig     - Build for tct_hammer
   tegra_defconfig          - Build for tegra
   trizeps4_defconfig       - Build for trizeps4
   u300_defconfig           - Build for u300
   u8500_defconfig          - Build for u8500
   versatile_defconfig      - Build for versatile
   vexpress_defconfig       - Build for vexpress
   viper_defconfig          - Build for viper
   vt8500_v6_v7_defconfig   - Build for vt8500_v6_v7
   xcep_defconfig           - Build for xcep
   zeus_defconfig           - Build for zeus

   make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build
   make V=2   [targets] 2 => give reason for rebuild of target
   make O=dir [targets] Locate all output files in "dir", including .config
   make C=1   [targets] Check all c source with $CHECK (sparse by default)
   make C=2   [targets] Force check of all c source with $CHECK
   make RECORDMCOUNT_WARN=1 [targets] Warn about ignored mcount sections
   make W=n   [targets] Enable extra gcc checks, n=1,2,3 where
         1: warnings which may be relevant and do not occur too often
         2: warnings which occur quite often but may still be relevant
         3: more obscure warnings, can most likely be ignored
         Multiple levels can be combined with W=12 or W=123

Execute "make" or "make all" to build all targets marked with [*]
For further info see the ./README file


>
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> ---
>   Makefile |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 52c1297..63f05dc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1234,7 +1234,7 @@ rpm: include/config/kernel.release FORCE
>   # ---------------------------------------------------------------------------
>   
>   boards := $(wildcard $(srctree)/arch/$(SRCARCH)/configs/*_defconfig)
> -boards := $(notdir $(boards))
> +boards := $(sort $(notdir $(boards)))
>   board-dirs := $(dir $(wildcard $(srctree)/arch/$(SRCARCH)/configs/*/*_defconfig))
>   board-dirs := $(sort $(notdir $(board-dirs:/=)))
>   
>
>

