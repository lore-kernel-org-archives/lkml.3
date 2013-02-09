Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab3BIVqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 16:46:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36479 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947398Ab3BIVqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 16:46:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI / PM: Candidate material for the v3.9 merge window
Date: Sat, 09 Feb 2013 22:53:09 +0100
Message-ID: <3791674.DRIMSY8bnF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Below is the summary of ACPI and power management material I'm going to include
into my first pull request during the upcoming merge window.  I also would like
to add the following two patches two that:

https://patchwork.kernel.org/patch/2120281/
https://patchwork.kernel.org/patch/2120251/

if there are no major objections against them.  I'm not considering any other
patches for v3.9 at the moment, so please let me know if you have any.

As usual, the commits are available from the tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next

Please let me know ASAP if you have any problems with any of them.

Thanks,
Rafael


 .../ABI/testing/sysfs-devices-power_resources_D0        |   13 +
 .../ABI/testing/sysfs-devices-power_resources_D1        |   14 +
 .../ABI/testing/sysfs-devices-power_resources_D2        |   14 +
 .../ABI/testing/sysfs-devices-power_resources_D3hot     |   14 +
 Documentation/ABI/testing/sysfs-devices-power_state     |   20 +
 .../ABI/testing/sysfs-devices-real_power_state          |   23 +
 Documentation/ABI/testing/sysfs-devices-resource_in_use |   12 +
 Documentation/acpi/enumeration.txt                      |    4 +-
 Documentation/acpi/scan_handlers.txt                    |   77 ++
 Documentation/cpu-freq/cpu-drivers.txt                  |    6 +
 Documentation/cpu-freq/user-guide.txt                   |    8 +-
 Documentation/devicetree/bindings/arm/kirkwood.txt      |   27 +
 Documentation/power/freezing-of-tasks.txt               |    5 +
 Documentation/power/runtime_pm.txt                      |    4 +
 Documentation/trace/events-power.txt                    |   27 +-
 arch/arm/boot/dts/highbank.dts                          |   10 +
 arch/arm/kernel/smp_twd.c                               |   53 +-
 arch/arm/mach-highbank/Kconfig                          |    4 +
 arch/arm/mach-omap2/pm34xx.c                            |    2 -
 arch/arm/mach-tegra/cpu-tegra.c                         |    3 +-
 arch/ia64/hp/common/aml_nfw.c                           |    2 +-
 arch/ia64/include/asm/acpi.h                            |    4 -
 arch/x86/Kconfig                                        |   10 +
 arch/x86/include/asm/acpi.h                             |    4 -
 arch/x86/kernel/process.c                               |    6 -
 arch/x86/platform/olpc/olpc-xo15-sci.c                  |    2 +-
 drivers/Kconfig                                         |    2 +
 drivers/Makefile                                        |    1 +
 drivers/acpi/Kconfig                                    |    7 +-
 drivers/acpi/Makefile                                   |    3 +-
 drivers/acpi/ac.c                                       |    4 +-
 drivers/acpi/acpi_memhotplug.c                          |   30 +-
 drivers/acpi/acpi_pad.c                                 |    3 +-
 drivers/acpi/acpi_platform.c                            |   72 +-
 drivers/acpi/acpica/Makefile                            |    8 +-
 drivers/acpi/acpica/accommon.h                          |    3 +-
 drivers/acpi/acpica/acdebug.h                           |   19 +-
 drivers/acpi/acpica/acdispat.h                          |    2 +-
 drivers/acpi/acpica/acevents.h                          |   23 +-
 drivers/acpi/acpica/acglobal.h                          |   43 +-
 drivers/acpi/acpica/achware.h                           |    2 +-
 drivers/acpi/acpica/acinterp.h                          |    4 +-
 drivers/acpi/acpica/aclocal.h                           |   47 +-
 drivers/acpi/acpica/acmacros.h                          |  173 +----
 drivers/acpi/acpica/acnamesp.h                          |   16 +-
 drivers/acpi/acpica/acobject.h                          |    4 +-
 drivers/acpi/acpica/acopcode.h                          |    2 +-
 drivers/acpi/acpica/acparser.h                          |   27 +-
 drivers/acpi/acpica/acpredef.h                          |   31 +-
 drivers/acpi/acpica/acresrc.h                           |    8 +-
 drivers/acpi/acpica/acstruct.h                          |    2 +-
 drivers/acpi/acpica/actables.h                          |    2 +-
 drivers/acpi/acpica/acutils.h                           |   59 +-
 drivers/acpi/acpica/amlcode.h                           |    2 +-
 drivers/acpi/acpica/amlresrc.h                          |    8 +-
 drivers/acpi/acpica/dsargs.c                            |    2 +-
 drivers/acpi/acpica/dscontrol.c                         |    2 +-
 drivers/acpi/acpica/dsfield.c                           |    2 +-
 drivers/acpi/acpica/dsinit.c                            |    2 +-
 drivers/acpi/acpica/dsmethod.c                          |    8 +-
 drivers/acpi/acpica/dsmthdat.c                          |    2 +-
 drivers/acpi/acpica/dsobject.c                          |   20 +-
 drivers/acpi/acpica/dsopcode.c                          |   16 +-
 drivers/acpi/acpica/dsutils.c                           |   12 +-
 drivers/acpi/acpica/dswexec.c                           |    6 +-
 drivers/acpi/acpica/dswload.c                           |    7 +-
 drivers/acpi/acpica/dswload2.c                          |    4 +-
 drivers/acpi/acpica/dswscope.c                          |    2 +-
 drivers/acpi/acpica/dswstate.c                          |    2 +-
 drivers/acpi/acpica/evevent.c                           |    2 +-
 drivers/acpi/acpica/evglock.c                           |    2 +-
 drivers/acpi/acpica/evgpe.c                             |   14 +-
 drivers/acpi/acpica/evgpeblk.c                          |   24 +-
 drivers/acpi/acpica/evgpeinit.c                         |    5 +-
 drivers/acpi/acpica/evgpeutil.c                         |    2 +-
 drivers/acpi/acpica/evhandler.c                         |  529 +++++++++++++
 drivers/acpi/acpica/evmisc.c                            |    2 +-
 drivers/acpi/acpica/evregion.c                          |  584 ++------------
 drivers/acpi/acpica/evrgnini.c                          |    2 +-
 drivers/acpi/acpica/evsci.c                             |    6 +-
 drivers/acpi/acpica/evxface.c                           |   36 +-
 drivers/acpi/acpica/evxfevnt.c                          |    7 +-
 drivers/acpi/acpica/evxfgpe.c                           |   11 +-
 drivers/acpi/acpica/evxfregn.c                          |    2 +-
 drivers/acpi/acpica/exconfig.c                          |   22 +-
 drivers/acpi/acpica/exconvrt.c                          |    4 +-
 drivers/acpi/acpica/excreate.c                          |    2 +-
 drivers/acpi/acpica/exdebug.c                           |    2 +-
 drivers/acpi/acpica/exdump.c                            |   21 +-
 drivers/acpi/acpica/exfield.c                           |    2 +-
 drivers/acpi/acpica/exfldio.c                           |    3 +-
 drivers/acpi/acpica/exmisc.c                            |    2 +-
 drivers/acpi/acpica/exmutex.c                           |    5 +-
 drivers/acpi/acpica/exnames.c                           |    2 +-
 drivers/acpi/acpica/exoparg1.c                          |   10 +-
 drivers/acpi/acpica/exoparg2.c                          |    2 +-
 drivers/acpi/acpica/exoparg3.c                          |    2 +-
 drivers/acpi/acpica/exoparg6.c                          |    2 +-
 drivers/acpi/acpica/exprep.c                            |    6 +-
 drivers/acpi/acpica/exregion.c                          |   25 +-
 drivers/acpi/acpica/exresnte.c                          |    2 +-
 drivers/acpi/acpica/exresolv.c                          |    2 +-
 drivers/acpi/acpica/exresop.c                           |    2 +-
 drivers/acpi/acpica/exstore.c                           |   31 +-
 drivers/acpi/acpica/exstoren.c                          |    4 +-
 drivers/acpi/acpica/exstorob.c                          |    2 +-
 drivers/acpi/acpica/exsystem.c                          |    2 +-
 drivers/acpi/acpica/exutils.c                           |   24 +-
 drivers/acpi/acpica/hwacpi.c                            |   13 +-
 drivers/acpi/acpica/hwesleep.c                          |    3 +-
 drivers/acpi/acpica/hwgpe.c                             |   10 +-
 drivers/acpi/acpica/hwpci.c                             |    2 +-
 drivers/acpi/acpica/hwregs.c                            |    8 +-
 drivers/acpi/acpica/hwsleep.c                           |    8 +-
 drivers/acpi/acpica/hwtimer.c                           |    9 +-
 drivers/acpi/acpica/hwvalid.c                           |   20 +-
 drivers/acpi/acpica/hwxface.c                           |  137 ++--
 drivers/acpi/acpica/hwxfsleep.c                         |   13 +-
 drivers/acpi/acpica/nsaccess.c                          |    2 +-
 drivers/acpi/acpica/nsalloc.c                           |    2 +-
 drivers/acpi/acpica/nsdump.c                            |   14 +-
 drivers/acpi/acpica/nsdumpdv.c                          |    3 +-
 drivers/acpi/acpica/nseval.c                            |    2 +-
 drivers/acpi/acpica/nsinit.c                            |   29 +-
 drivers/acpi/acpica/nsload.c                            |    2 +-
 drivers/acpi/acpica/nsnames.c                           |    5 +-
 drivers/acpi/acpica/nsobject.c                          |    2 +-
 drivers/acpi/acpica/nsparse.c                           |    2 +-
 drivers/acpi/acpica/nspredef.c                          |  586 +--------------
 drivers/acpi/acpica/nsprepkg.c                          |  621 +++++++++++++++
 drivers/acpi/acpica/nsrepair.c                          |    2 +-
 drivers/acpi/acpica/nsrepair2.c                         |    5 +-
 drivers/acpi/acpica/nssearch.c                          |    7 +-
 drivers/acpi/acpica/nsutils.c                           |   88 +--
 drivers/acpi/acpica/nswalk.c                            |    6 +-
 drivers/acpi/acpica/nsxfeval.c                          |   19 +-
 drivers/acpi/acpica/nsxfname.c                          |   20 +-
 drivers/acpi/acpica/nsxfobj.c                           |    2 +-
 drivers/acpi/acpica/psargs.c                            |    9 +-
 drivers/acpi/acpica/psloop.c                            |  623 +--------------
 drivers/acpi/acpica/psobject.c                          |  647 ++++++++++++++++
 drivers/acpi/acpica/psopcode.c                          |  174 +----
 drivers/acpi/acpica/psopinfo.c                          |  223 ++++++
 drivers/acpi/acpica/psparse.c                           |    2 +-
 drivers/acpi/acpica/psscope.c                           |    2 +-
 drivers/acpi/acpica/pstree.c                            |    2 +-
 drivers/acpi/acpica/psutils.c                           |   10 +-
 drivers/acpi/acpica/pswalk.c                            |    2 +-
 drivers/acpi/acpica/psxface.c                           |    2 +-
 drivers/acpi/acpica/rsaddr.c                            |    2 +-
 drivers/acpi/acpica/rscalc.c                            |    8 +-
 drivers/acpi/acpica/rscreate.c                          |    9 +-
 drivers/acpi/acpica/rsdump.c                            |  424 +----------
 drivers/acpi/acpica/rsdumpinfo.c                        |  454 +++++++++++
 drivers/acpi/acpica/rsinfo.c                            |    2 +-
 drivers/acpi/acpica/rsio.c                              |    2 +-
 drivers/acpi/acpica/rsirq.c                             |   40 +-
 drivers/acpi/acpica/rslist.c                            |    9 +-
 drivers/acpi/acpica/rsmemory.c                          |    8 +-
 drivers/acpi/acpica/rsmisc.c                            |   76 +-
 drivers/acpi/acpica/rsserial.c                          |   10 +-
 drivers/acpi/acpica/rsutils.c                           |   14 +-
 drivers/acpi/acpica/rsxface.c                           |  107 ++-
 drivers/acpi/acpica/tbfadt.c                            |    7 +-
 drivers/acpi/acpica/tbfind.c                            |    2 +-
 drivers/acpi/acpica/tbinstal.c                          |    2 +-
 drivers/acpi/acpica/tbutils.c                           |    4 +-
 drivers/acpi/acpica/tbxface.c                           |    7 +-
 drivers/acpi/acpica/tbxfload.c                          |    4 +-
 drivers/acpi/acpica/tbxfroot.c                          |    2 +-
 drivers/acpi/acpica/utaddress.c                         |    6 +-
 drivers/acpi/acpica/utalloc.c                           |    2 +-
 drivers/acpi/acpica/utcache.c                           |    2 +-
 drivers/acpi/acpica/utcopy.c                            |    6 +-
 drivers/acpi/acpica/utdebug.c                           |  120 ++-
 drivers/acpi/acpica/utdecode.c                          |    2 +-
 drivers/acpi/acpica/utdelete.c                          |   70 +-
 drivers/acpi/acpica/uteval.c                            |    4 +-
 drivers/acpi/acpica/utexcep.c                           |    2 +-
 drivers/acpi/acpica/utglobal.c                          |   11 +-
 drivers/acpi/acpica/utids.c                             |    2 +-
 drivers/acpi/acpica/utinit.c                            |    2 +-
 drivers/acpi/acpica/utlock.c                            |   16 +-
 drivers/acpi/acpica/utmath.c                            |    2 +-
 drivers/acpi/acpica/utmisc.c                            |  830 ++------------------
 drivers/acpi/acpica/utmutex.c                           |    2 +-
 drivers/acpi/acpica/utobject.c                          |    4 +-
 drivers/acpi/acpica/utosi.c                             |    2 +-
 drivers/acpi/acpica/utownerid.c                         |  218 ++++++
 drivers/acpi/acpica/utresrc.c                           |   83 +-
 drivers/acpi/acpica/utstate.c                           |   42 +-
 drivers/acpi/acpica/utstring.c                          |  574 ++++++++++++++
 drivers/acpi/acpica/uttrack.c                           |   18 +-
 drivers/acpi/acpica/utxface.c                           |    6 +-
 drivers/acpi/acpica/utxferror.c                         |    6 +-
 drivers/acpi/acpica/utxfinit.c                          |    2 +-
 drivers/acpi/acpica/utxfmutex.c                         |    2 +-
 drivers/acpi/battery.c                                  |    2 +-
 drivers/acpi/bus.c                                      |  270 -------
 drivers/acpi/button.c                                   |    4 +-
 drivers/acpi/container.c                                |  199 ++---
 drivers/acpi/csrt.c                                     |  159 ++++
 drivers/acpi/custom_method.c                            |    2 +-
 drivers/acpi/device_pm.c                                |  359 ++++++++-
 drivers/acpi/dock.c                                     |   25 +-
 drivers/acpi/ec.c                                       |    2 +-
 drivers/acpi/fan.c                                      |    4 +-
 drivers/acpi/glue.c                                     |   85 ++-
 drivers/acpi/hed.c                                      |    2 +-
 drivers/acpi/internal.h                                 |   36 +-
 drivers/acpi/numa.c                                     |    8 +-
 drivers/acpi/osl.c                                      |    2 +-
 drivers/acpi/pci_bind.c                                 |  122 ---
 drivers/acpi/pci_link.c                                 |   47 +-
 drivers/acpi/pci_root.c                                 |  101 +--
 drivers/acpi/pci_slot.c                                 |   20 +-
 drivers/acpi/power.c                                    |  730 +++++++++---------
 drivers/acpi/proc.c                                     |    9 +-
 drivers/acpi/processor_driver.c                         |   38 +-
 drivers/acpi/processor_idle.c                           |    5 +-
 drivers/acpi/sbs.c                                      |    6 +-
 drivers/acpi/sbshc.c                                    |    4 +-
 drivers/acpi/scan.c                                     |  920 +++++++++++------------
 drivers/acpi/sleep.c                                    |   97 ++-
 drivers/acpi/sleep.h                                    |    2 +
 drivers/acpi/sysfs.c                                    |    2 +-
 drivers/acpi/tables.c                                   |    6 +-
 drivers/acpi/thermal.c                                  |   10 +-
 drivers/acpi/video.c                                    |    8 +-
 drivers/ata/libata-acpi.c                               |   18 +-
 drivers/base/power/domain.c                             |    3 +-
 drivers/base/power/opp.c                                |   19 +-
 drivers/base/power/wakeup.c                             |    6 +
 drivers/char/hpet.c                                     |    2 +-
 drivers/char/sonypi.c                                   |    2 +-
 drivers/clk/Makefile                                    |    1 +
 drivers/clk/clk-highbank.c                              |    2 +
 drivers/clk/mvebu/clk-gating-ctrl.c                     |    1 +
 drivers/clk/x86/Makefile                                |    2 +
 drivers/clk/x86/clk-lpss.c                              |   99 +++
 drivers/clk/x86/clk-lpss.h                              |   36 +
 drivers/clk/x86/clk-lpt.c                               |   86 +++
 drivers/cpufreq/Kconfig                                 |    2 +-
 drivers/cpufreq/Kconfig.arm                             |   30 +
 drivers/cpufreq/Kconfig.x86                             |   18 +
 drivers/cpufreq/Makefile                                |   11 +-
 drivers/cpufreq/acpi-cpufreq.c                          |    8 +-
 drivers/cpufreq/cpufreq-cpu0.c                          |   42 +-
 drivers/cpufreq/cpufreq.c                               |  460 ++++++------
 drivers/cpufreq/cpufreq_conservative.c                  |   19 +-
 drivers/cpufreq/cpufreq_governor.c                      |  131 ++--
 drivers/cpufreq/cpufreq_governor.h                      |    6 +-
 drivers/cpufreq/cpufreq_ondemand.c                      |   70 +-
 drivers/cpufreq/cpufreq_stats.c                         |   49 +-
 drivers/cpufreq/cpufreq_userspace.c                     |    2 -
 drivers/cpufreq/db8500-cpufreq.c                        |    4 +-
 drivers/cpufreq/exynos-cpufreq.c                        |   14 +-
 drivers/cpufreq/freq_table.c                            |   15 +-
 drivers/cpufreq/highbank-cpufreq.c                      |  120 +++
 drivers/cpufreq/imx6q-cpufreq.c                         |  336 +++++++++
 drivers/cpufreq/intel_pstate.c                          |  806 ++++++++++++++++++++
 drivers/cpufreq/kirkwood-cpufreq.c                      |  259 +++++++
 drivers/cpufreq/maple-cpufreq.c                         |    2 +-
 drivers/cpufreq/omap-cpufreq.c                          |    4 +-
 drivers/cpufreq/powernow-k8.c                           |   46 +-
 drivers/cpufreq/spear-cpufreq.c                         |   12 +-
 drivers/cpuidle/cpuidle.c                               |    2 -
 drivers/hwmon/acpi_power_meter.c                        |    2 +-
 drivers/hwmon/asus_atk0110.c                            |    4 +-
 drivers/i2c/busses/i2c-scmi.c                           |    2 +-
 drivers/input/misc/atlas_btns.c                         |    2 +-
 drivers/mailbox/Kconfig                                 |   19 +
 drivers/mailbox/Makefile                                |    1 +
 drivers/mailbox/pl320-ipc.c                             |  199 +++++
 drivers/pci/hotplug/acpiphp_glue.c                      |   50 +-
 drivers/pci/hotplug/sgi_hotplug.c                       |   10 +-
 drivers/pci/pci-acpi.c                                  |   56 +-
 drivers/pci/pci.c                                       |   26 +-
 drivers/pci/pci.h                                       |    5 -
 drivers/pci/probe.c                                     |    1 -
 drivers/platform/x86/asus-laptop.c                      |    2 +-
 drivers/platform/x86/classmate-laptop.c                 |   10 +-
 drivers/platform/x86/eeepc-laptop.c                     |    2 +-
 drivers/platform/x86/fujitsu-laptop.c                   |    4 +-
 drivers/platform/x86/fujitsu-tablet.c                   |    2 +-
 drivers/platform/x86/hp_accel.c                         |    2 +-
 drivers/platform/x86/ideapad-laptop.c                   |    2 +-
 drivers/platform/x86/intel_menlow.c                     |    2 +-
 drivers/platform/x86/panasonic-laptop.c                 |    4 +-
 drivers/platform/x86/sony-laptop.c                      |    4 +-
 drivers/platform/x86/topstar-laptop.c                   |    2 +-
 drivers/platform/x86/toshiba_acpi.c                     |    4 +-
 drivers/platform/x86/toshiba_bluetooth.c                |    4 +-
 drivers/platform/x86/wmi.c                              |    4 +-
 drivers/platform/x86/xo15-ebook.c                       |    2 +-
 drivers/pnp/pnpacpi/core.c                              |   10 +-
 drivers/pnp/pnpbios/Kconfig                             |    4 +-
 drivers/staging/quickstart/quickstart.c                 |    2 +-
 drivers/video/backlight/apple_bl.c                      |    2 +-
 drivers/xen/xen-acpi-pad.c                              |    3 +-
 fs/sysfs/group.c                                        |   42 ++
 fs/sysfs/symlink.c                                      |   45 +-
 fs/sysfs/sysfs.h                                        |    2 +
 include/acpi/acbuffer.h                                 |    2 +-
 include/acpi/acconfig.h                                 |   27 +-
 include/acpi/acexcep.h                                  |    2 +-
 include/acpi/acnames.h                                  |    2 +-
 include/acpi/acoutput.h                                 |  159 +++-
 include/acpi/acpi.h                                     |    2 +-
 include/acpi/acpi_bus.h                                 |   97 ++-
 include/acpi/acpiosxf.h                                 |   13 +-
 include/acpi/acpixf.h                                   |   68 +-
 include/acpi/acrestyp.h                                 |   17 +-
 include/acpi/actbl.h                                    |    9 +-
 include/acpi/actbl1.h                                   |    8 +-
 include/acpi/actbl2.h                                   |   25 +-
 include/acpi/actbl3.h                                   |   34 +-
 include/acpi/actypes.h                                  |   38 +-
 include/acpi/container.h                                |   12 -
 include/acpi/platform/acenv.h                           |  319 ++++----
 include/acpi/platform/acgcc.h                           |    6 +-
 include/acpi/platform/aclinux.h                         |    3 +-
 include/linux/acpi.h                                    |   22 +-
 include/linux/cpufreq.h                                 |   34 +-
 include/linux/freezer.h                                 |    5 +
 include/linux/mailbox.h                                 |   17 +
 include/linux/pm_runtime.h                              |    7 +
 include/linux/suspend.h                                 |    6 +-
 include/linux/sysfs.h                                   |   16 +
 include/trace/events/power.h                            |   92 ---
 kernel/power/autosleep.c                                |    2 +-
 kernel/power/main.c                                     |   29 +-
 kernel/power/process.c                                  |    4 +-
 kernel/power/qos.c                                      |    9 +-
 kernel/power/suspend.c                                  |   69 +-
 kernel/trace/Kconfig                                    |   15 -
 kernel/trace/power-traces.c                             |    3 -
 tools/power/acpi/Makefile                               |    2 +-
 338 files changed, 9968 insertions(+), 6813 deletions(-)

---------------

Aaron Lu (2):
      ACPICA: Resource manager: Add support for ACPI 5 wake bit in IRQ descriptor.
      ACPICA: Resources: Support for ACPI 5 wake bit in ExtendedInterrupt descriptor.

Andreas Fleig (1):
      ACPI / PM: Fix /proc/acpi/wakeup for devices w/o bus or parent

Andrew Lunn (1):
      cpufreq: kirkwood: Add a cpufreq driver for Marvell Kirkwood SoCs

Bjorn Helgaas (1):
      ACPI: Remove unused struct acpi_pci_root.id member

Bob Moore (36):
      ACPICA: Performance: Remove function tracing from critical allocation functions.
      ACPICA: Debugger: Major update for the Disassemble<method> command.
      ACPICA: Disassembler: Add new ACPI 5 interrupt sharing flags.
      ACPICA: Add macros to extract flag bits from resource descriptors.
      ACPICA: AcpiGetObjectInfo: optimize exit for mutex failure.
      ACPICA: Update version to 20121114.
      ACPICA: Resources: New interface, AcpiWalkResourceBuffer.
      ACPICA: Change exception code for LoadTable operator.
      ACPICA: Eliminate some small unnecessary pathname functions.
      ACPICA: Add root node optimization to internal get namespace node function.
      ACPICA: Lint changes, no functional change.
      ACPICA: Add time macros for various timer/time manipulation.
      ACPICA: Add header file support for the ACPI 5 TPM2 ACPI table.
      ACPICA: DEBUG_PRINT macros: Update to improve performance.
      ACPICA: FUNCTION_TRACE macros: Check if debug is enabled up-front.
      ACPICA: Eliminate superfluous return_UINT8 and return_UINT32 macros.
      ACPICA: Update ACPI_IS_DEBUG_ENABLED macro.
      ACPICA: Deploy new ACPI_IS_DEBUG_ENABLED macro in debug output code.
      ACPICA: Merge all debug output macros into a single file, acoutput.
      ACPICA: iASL: Finish support for CSRT table.
      ACPICA: iASL: Finish support for the TPM2 table.
      ACPICA: Update for non-configured ACPI_IS_DEBUG_ENABLED macro.
      ACPICA: Namespace: Eliminate dot...dot output during initialization.
      ACPICA: Update ACPICA initialization messages.
      ACPICA: Interpreter: Add warning if 64-bit constant appears in 32-bit table.
      ACPICA: Resources: Split interrupt share/wake bits into two fields.
      ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
      ACPICA: Update version to 20121220.
      ACPICA: Cleanup ACPI_DEBUG_PRINT macros to fix potential build breakages.
      ACPICA: Source restructuring: split large files into 8 new files.
      ACPICA: Update ACPICA copyrights to 2013
      ACPICA: AcpiGetSleepTypeData: Allow \_Sx to return either 1 or 2 integers
      ACPICA: iASL/Disassembler: Add option to ignore NOOP opcodes/operators
      ACPICA: Remove some extraneous newlines in ACPI_ERROR type calls
      ACPICA: Update predefined info table for _MLS method
      ACPICA: Update version to 20130117

Borislav Petkov (5):
      cpufreq: Make acpi-cpufreq link first
      cpufreq: Add a get_current_driver helper
      powernow-k8: Cleanup module request
      powernow-k8: Cleanup init function
      cpufreq: Sort function prototypes properly

Chao Guan (1):
      ACPICA: Performance enhancement for ACPI package objects.

Colin Ian King (3):
      ACPI video: remove unnecessary newline from error messages
      ACPI sysfs: remove unnecessary newline from exception
      ACPI thermal: remove unnecessary newline from exception message

Davidlohr Bueso (1):
      ACPI: SRAT: report non-volatile memory in debug

Dirk Brandewie (6):
      cpufreq: handle cpufreq being disabled for all exported function.
      cpufreq: Retrieve current frequency from scaling drivers with internal governors
      cpufreq: Only call cpufreq_out_of_sync() for driver that implement cpufreq_driver.target()
      cpufreq: Do not track governor name for scaling drivers with internal governors.
      cpufreq_stats: do not remove sysfs files if frequency table is not present
      cpufreq/x86: Add P-state driver for sandy bridge.

Fabio Baltieri (6):
      cpufreq: ondemand: call dbs_check_cpu only when necessary
      cpufreq: conservative: call dbs_check_cpu only when necessary
      cpufreq: ondemand: use all CPUs in update_sampling_rate
      cpufreq: governors: clean timer init and exit code
      cpufreq: governors: implement generic policy_is_shared
      cpufreq: governors: fix misuse of cdbs.cpu

Jesper Juhl (1):
      ACPICA: Fix possible memory leak.

Jiang Liu (3):
      ACPI: remove unused acpi_op_bind and acpi_op_unbind
      ACPI / PCI: avoid building pci_slot as module
      ACPI / PCI: pci_slot: replace printk(KERN_xxx) with pr_xxx()

Joseph Salisbury (1):
      ACPI: Add DMI entry for Sony VGN-FW41E_H

Kees Cook (1):
      drivers/pnp/pnpbios: remove depends on CONFIG_EXPERIMENTAL

Li Fei (1):
      suspend: enable freeze timeout configuration through sys

Lv Zheng (14):
      ACPICA: Cleanup updated comments.
      ACPICA: Update compilation environment settings.
      ACPICA: Update codes under disabled build options.
      ACPICA: Cleanup source to reduce differences between Linux and ACPICA.
      ACPICA: Cleanup indentation to reduce differences between Linux and ACPICA.
      ACPICA: Cleanup coding style to reduce differences between Linux and ACPICA.
      ACPICA: Fix broken call depth tracing logic.
      ACPICA: Enhance error messages.
      ACPICA: Update initialization codes.
      ACPICA: Enhance the ACPI_GETx and ACPI_SETx macros.
      ACPICA: Resource Manager: update template walking with ACPI_NEXT_RESOURCE.
      ACPICA: Cleanup PM_TIMER_FREQUENCY definition.
      ACPICA: Cleanup table handler naming conflicts.
      ACPICA: Update predefined info table

Mark Langsdorf (3):
      clk / highbank: Prevent glitches in non-bypass reset mode
      cpufreq / highbank: add support for highbank cpufreq
      PM / OPP: Export more symbols for module usage

Matthew Garrett (1):
      acpi-cpufreq: Do not load on K8

Mika Westerberg (8):
      ACPI / scan: Fix check of device_attach() return value.
      ACPI / PM: remove leading whitespace from #ifdef
      ACPI: add support for CSRT table
      ACPI / platform: fix comment about the platform device name
      x86: add support for Intel Low Power Subsystem
      clk: x86: add support for Lynxpoint LPSS clocks
      ACPI / platform: create LPSS clocks if Lynxpoint devices are found during scan
      ACPI / Documentation: refer to correct file for acpi_platform_device_ids[] table

Nishanth Menon (1):
      PM / OPP: switch exported symbols to GPL variant

Paul Gortmaker (1):
      PM / tracing: remove deprecated power trace API

Rafael J. Wysocki (72):
      ACPI: Separate adding ACPI device objects from probing ACPI drivers
      ACPI: Change the ordering of PCI root bridge driver registrarion
      ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
      ACPI: Reduce the usage of struct acpi_bus_ops
      ACPI: Replace struct acpi_bus_ops with enum type
      ACPI: Change the ordering of acpi_bus_check_add()
      ACPI / PCI: Fold acpi_pci_root_start() into acpi_pci_root_add()
      ACPI: Remove acpi_start_single_object() and acpi_bus_start()
      ACPI: Remove the arguments of acpi_bus_add() that are not used
      ACPI: Drop the second argument of acpi_bus_scan()
      ACPI: Replace ACPI device add_type field with a match_driver flag
      ACPI: Make acpi_bus_scan() and acpi_bus_add() take only one argument
      ACPI: Add .setup() and .cleanup() callbacks to struct acpi_bus_type
      ACPI / PCI: Rework the setup and cleanup of device wakeup
      ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
      ACPI: Drop ACPI device .bind() and .unbind() callbacks
      ACPI / scan: Treat power resources in a special way
      ACPICA: Resource Manager: Add a pointer cast for a namespace node.
      ACPI: Remove the ops field from struct acpi_device
      ACPI / scan: Drop the second argument of acpi_device_unregister()
      ACPI / scan: Drop the second argument of acpi_bus_trim()
      ACPI / scan: Change the implementation of acpi_bus_trim()
      ACPI / scan: Add second pass to acpi_bus_trim()
      ACPI / PM: Rework the handling of devices depending on power resources
      ACPI / scan: More straightforward preparation of ACPI device objects
      ACPI / scan: Treat power resources in a special way
      ACPI: Drop power resources driver
      ACPI: Do not use device power states of power resources
      ACPI / PM: Take order attribute of power resources into account
      ACPI / PM: Take order attribute of wakeup power resources into account
      ACPI / scan: Move power state initialization to a separate routine
      ACPI / scan: Remove unnecessary initialization of local variables
      ACPI / scan: Consolidate extraction of power resources lists
      ACPI: Take power resource initialization errors into account
      ACPI: Use system level attribute of wakeup power resources
      ACPI / PM: Change the way power transitions to D3cold are carried out
      ACPI / PM: More visible function for retrieving device power states
      ACPI / PM: Common string representations of device power states
      ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead
      ACPI / PM: Move device power management functions to device_pm.c
      ACPI / PM: Consolidate suspend-specific and hibernate-specific code
      ACPI / PM: Fix build for unusual combination of Kconfig options
      ACPI / PM: Make acpi_bus_init_power() more robust
      ACPI / PM: Introduce helper for executing _PSn methods
      ACPI / PM: Always evaluate _PSn after setting power resources
      ACPI / PM: Sanitize checks in acpi_power_on_resources()
      ACPI / PM: Use string "D3cold" to represent ACPI_STATE_D3_COLD
      ACPI / PM: Fix device power state value after transitions to D3cold
      ACPI / scan: Prevent device add uevents from racing with user space
      ACPI / PM: Expose power states of ACPI devices to user space
      ACPI / PM: Expose current status of ACPI power resources
      sysfs: Functions for adding/removing symlinks to/from attribute groups
      ACPI / PM: Expose lists of device power resources to user space
      ACPI / PM: Fix consistency check for power resources during resume
      ACPI / scan: Make it clear that acpi_bus_trim() cannot fail
      ACPI: Rework acpi_get_child() to be more efficient
      ACPI: Remove useless type argument of driver .remove() operation
      ACPI: Drop device start operation that is not used
      ACPI / scan: Make namespace scanning and trimming mutually exclusive
      ACPI / scan: Make scanning of fixed devices follow the general scheme
      ACPI / scan: Introduce struct acpi_scan_handler
      ACPI / PCI: Make PCI root driver use struct acpi_scan_handler
      ACPI / PCI: Make PCI IRQ link driver use struct acpi_scan_handler
      ACPI / platform: Use struct acpi_scan_handler for creating devices
      ACPI / scan: Fix acpi_bus_get_device() check in acpi_match_device()
      ACPI / scan: Clean up acpi_bus_get_parent()
      ACPI / PM: Do not power manage devices in unknown initial states
      ACPI / PM: Handle missing _PSC in acpi_bus_update_power()
      ACPI / scan: Follow priorities of IDs when matching scan handlers
      ACPI / scan: Remove useless #ifndef from acpi_eject_store()
      ACPI / scan: Make container driver use struct acpi_scan_handler
      ACPI: Drop the container.h header file

Rickard Andersson (1):
      cpufreq: handle SW coordinated CPUs

Rob Herring (2):
      ARM: use device tree to get smp_twd clock
      ARM / highbank: add support for pl320 IPC

Shawn Guo (2):
      cpufreq: instantiate cpufreq-cpu0 as a platform_driver
      cpufreq: add imx6q-cpufreq driver

ShuoX Liu (1):
      PM / Runtime: Add new helper function: pm_runtime_active()

Srinivas Pandruvada (1):
      ACPI / thermal: Use mode to enable/disable kernel thermal processing

Stratos Karafotis (3):
      cpufreq: ondemand: Replace down_differential tuner with adj_up_threshold
      cpufreq: ondemand: Fix typos in comments
      cpufreq: conservative: Fix typos in comments

Tejun Heo (2):
      PM / Domains: don't use [delayed_]work_pending()
      PM: don't use [delayed_]work_pending()

Thomas Renninger (1):
      ACPI tools / acpidump: must be run as root - install it into /usr/sbin

Tim Gardner (1):
      ACPICA: Fix possible memory leak in dispatcher error path.

Toshi Kani (2):
      ACPI: sysfs eject support for ACPI scan handlers
      ACPI: Unbind ACPI drv when probe failed

Viresh Kumar (23):
      cpufreq: Manage only online cpus
      cpufreq: Notify governors when cpus are hot-[un]plugged
      cpufreq: Don't use cpu removed during cpufreq_driver_unregister
      cpufreq: SPEAr: Fix sparse warning for cpufreq driver
      cpufreq: Simplify __cpufreq_remove_dev()
      cpufreq: Revert "cpufreq: Don't use cpu removed during cpufreq_driver_unregister"
      cpufreq: Simplify cpufreq_add_dev()
      cpufreq: Update Documentation for cpus and related_cpus
      cpufreq: SPEAr: Notify all policy->cpus of frequency change
      cpufreq: governors: Get rid of dbs_data->enable field
      cpufreq: governors: Remove code redundancy between governors
      cpufreq: governors: Reset tunables only for cpufreq_unregister_governor()
      cpufreq: TEGRA: Set policy->cpus from driver->init()
      cpufreq: Set all cpus in policy->cpus for single cluster SoCs
      cpufreq: Remove unnecessary use of policy->shared_type
      cpufreq: Don't remove sysfs link for policy->cpu
      cpufreq: Don't check cpu_online(policy->cpu)
      cpufreq / stats: Get rid of CPUFREQ_STATDEVICE_ATTR
      cpufreq: governors: Fix WARN_ON() for multi-policy platforms
      cpufreq: Remove unused HOTPLUG_CPU code
      cpufreq: Create a macro for unlock_policy_rwsem{read,write}
      cpufreq: Fix locking issues
      cpufreq: exynos: simplify .init() for setting policy->cpus

Yasuaki Ishimatsu (3):
      ACPI / PM: Fix acpi_bus_get_device() check in drivers/acpi/device_pm.c
      PNPACPI: Fix acpi_bus_get_device() check in drivers/pnp/pnpacpi/core.c
      ACPI / dock: Fix acpi_bus_get_device() check in drivers/acpi/dock.c

Yinghai Lu (1):
      ACPI: update ej_event interface to take acpi_device

Zhang Rui (3):
      ACPI: fix obsolete comment in custom_method.c
      PM: Introduce suspend state PM_SUSPEND_FREEZE
      ACPI: enable ACPI SCI during suspend


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
