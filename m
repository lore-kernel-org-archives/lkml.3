Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaLBXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 18:23:45 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:39455 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbaLBXXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 18:23:41 -0500
Date: Tue, 2 Dec 2014 15:23:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [rcu] BUG: scheduling while atomic: swapper/0/0x00000015
Message-ID: <20141202232330.GD25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141202225923.GA1196@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20141202225923.GA1196@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120223-0025-0000-0000-000006927F20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 02:59:23PM -0800, Fengguang Wu wrote:
> Hi Paul,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git Fraga1.2014.12.02a

Bad version of a test commit -- abandoning this one.

Forgot to use experimental.  :-/

							Thanx, Paul

> commit aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Tue Dec 2 11:33:18 2014 -0800
> Commit:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CommitDate: Tue Dec 2 11:33:18 2014 -0800
> 
>     Fraga: Preemptible RCU that disables preemption
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> +--------------------------------------------------------------------------+------------+------------+------------+
> |                                                                          | 3bbb0a8d64 | aee27dfbc1 | aee27dfbc1 |
> +--------------------------------------------------------------------------+------------+------------+------------+
> | boot_successes                                                           | 79         | 0          | 0          |
> | boot_failures                                                            | 1          | 12         | 12         |
> | BUG:kernel_early_hang_without_any_printk_output                          | 1          | 1          | 1          |
> | BUG:scheduling_while_atomic                                              | 0          | 11         | 11         |
> | WARNING:at_init/main.c:#do_one_initcall()                                | 0          | 11         | 11         |
> | initcall_set_real_mode_permissions_returned_with_preemption_imbalance    | 0          | 11         | 11         |
> | initcall_regulator_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_bdi_class_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_pcibus_class_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_pci_driver_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_backlight_class_init_returned_with_preemption_imbalance         | 0          | 11         | 11         |
> | initcall_anatop_regulator_init_returned_with_preemption_imbalance        | 0          | 11         | 11         |
> | initcall_tty_class_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_regmap_initcall_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_sram_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_syscon_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_spi_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_spmi_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_i2c_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_arch_kdebugfs_init_returned_with_preemption_imbalance           | 0          | 11         | 11         |
> | initcall_dmi_id_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_topology_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | WARNING:at_kernel/sched/core.c:#preempt_count_add()                      | 0          | 11         | 11         |
> | initcall_param_sysfs_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | INFO:lockdep_is_turned_off                                               | 0          | 11         | 11         |
> | initcall_default_bdi_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | initcall_genhd_device_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_fbmem_init_returned_with_preemption_imbalance                   | 0          | 11         | 11         |
> | initcall_acpi_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_pnp_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_regulator_fixed_voltage_init_returned_with_preemption_imbalance | 0          | 11         | 11         |
> | initcall_pm8607_regulator_init_returned_with_preemption_imbalance        | 0          | 11         | 11         |
> | initcall_ad5398_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_as3711_regulator_init_returned_with_preemption_imbalance        | 0          | 11         | 11         |
> | initcall_da9052_regulator_init_returned_with_preemption_imbalance        | 0          | 11         | 11         |
> | initcall_isl6271a_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_lp3972_module_init_returned_with_preemption_imbalance           | 0          | 11         | 11         |
> | initcall_lp8755_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_max1586_pmic_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_max8952_pmic_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_max8973_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_max8998_pmic_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_palmas_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_tps51632_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_rc5t583_regulator_init_returned_with_preemption_imbalance       | 0          | 11         | 11         |
> | initcall_tps62360_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_tps_65023_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_tps65217_regulator_init_returned_with_preemption_imbalance      | 0          | 11         | 11         |
> | initcall_tps80031_regulator_init_returned_with_preemption_imbalance      | 0          | 11         | 11         |
> | initcall_twlreg_init_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_wm831x_dcdc_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | initcall_wm831x_isink_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_wm831x_ldo_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_wm8350_regulator_init_returned_with_preemption_imbalance        | 0          | 11         | 11         |
> | initcall_misc_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_vga_arb_device_init_returned_with_preemption_imbalance          | 0          | 11         | 11         |
> | initcall_pm860x_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_pm800_i2c_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_pm805_i2c_init_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_wm831x_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_wm8350_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_tps6507x_i2c_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_tps65217_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_tps80031_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_mc13xxx_i2c_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | initcall_da9052_spi_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_da9052_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_max14577_i2c_init_returned_with_preemption_imbalance            | 0          | 11         | 11         |
> | initcall_max8998_i2c_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | initcall_palmas_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_rc5t583_i2c_init_returned_with_preemption_imbalance             | 0          | 11         | 11         |
> | initcall_lm3533_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_as3711_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_dma_buf_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_init_scsi_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_ata_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_usb_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_usb_phy_generic_init_returned_with_preemption_imbalance         | 0          | 11         | 11         |
> | initcall_serio_init_returned_with_preemption_imbalance                   | 0          | 11         | 11         |
> | initcall_gameport_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_input_init_returned_with_preemption_imbalance                   | 0          | 11         | 11         |
> | initcall_tca8418_keypad_init_returned_with_preemption_imbalance          | 0          | 11         | 11         |
> | initcall_vprbrd_i2c_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_pps_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_power_supply_class_init_returned_with_preemption_imbalance      | 0          | 11         | 11         |
> | initcall_hwmon_init_returned_with_preemption_imbalance                   | 0          | 11         | 11         |
> | initcall_watchdog_init_returned_with_preemption_imbalance                | 0          | 11         | 11         |
> | initcall_leds_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | initcall_iio_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_init_soundcore_returned_with_preemption_imbalance               | 0          | 11         | 11         |
> | initcall_net_dev_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_bt_init_returned_with_preemption_imbalance                      | 0          | 11         | 11         |
> | initcall_nfc_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | initcall_nmi_warning_debugfs_returned_with_preemption_imbalance          | 0          | 11         | 11         |
> | initcall_pnp_system_init_returned_with_preemption_imbalance              | 0          | 11         | 11         |
> | initcall_pnpacpi_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_chr_dev_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_firmware_class_init_returned_with_preemption_imbalance          | 0          | 11         | 11         |
> | initcall_thermal_init_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_ssb_modinit_returned_with_preemption_imbalance                  | 0          | 11         | 11         |
> | initcall_bcma_modinit_returned_with_preemption_imbalance                 | 0          | 11         | 11         |
> | initcall_mcb_init_returned_with_preemption_imbalance                     | 0          | 11         | 11         |
> | BUG:workqueue_leaked_lock_or_atomic:kworker                              | 0          | 11         | 11         |
> | initcall_inet_init_returned_with_preemption_imbalance                    | 0          | 11         | 11         |
> | backtrace:schedule_preempt_disabled                                      | 0          | 11         | 11         |
> | backtrace:warn_slowpath_fmt                                              | 0          | 11         | 11         |
> | backtrace:kernel_init_freeable                                           | 0          | 11         | 11         |
> | backtrace:devtmpfsd                                                      | 0          | 11         | 11         |
> | backtrace:regulator_init                                                 | 0          | 11         | 11         |
> | backtrace:bdi_class_init                                                 | 0          | 11         | 11         |
> | backtrace:pcibus_class_init                                              | 0          | 11         | 11         |
> | backtrace:pci_driver_init                                                | 0          | 11         | 11         |
> | backtrace:backlight_class_init                                           | 0          | 11         | 11         |
> | backtrace:anatop_regulator_init                                          | 0          | 11         | 11         |
> | backtrace:tty_class_init                                                 | 0          | 11         | 11         |
> | backtrace:sram_init                                                      | 0          | 11         | 11         |
> | backtrace:syscon_init                                                    | 0          | 11         | 11         |
> | backtrace:spi_init                                                       | 0          | 11         | 11         |
> | backtrace:spmi_init                                                      | 0          | 11         | 11         |
> | backtrace:i2c_init                                                       | 0          | 11         | 11         |
> | backtrace:cpu_startup_entry                                              | 0          | 11         | 11         |
> | backtrace:arch_kdebugfs_init                                             | 0          | 11         | 11         |
> | backtrace:dmi_id_init                                                    | 0          | 11         | 11         |
> | backtrace:topology_init                                                  | 0          | 11         | 11         |
> | backtrace:kobject_uevent                                                 | 0          | 11         | 11         |
> | backtrace:param_sysfs_init                                               | 0          | 11         | 11         |
> | backtrace:default_bdi_init                                               | 0          | 11         | 11         |
> | backtrace:__alloc_workqueue_key                                          | 0          | 11         | 11         |
> | backtrace:blk_dev_init                                                   | 0          | 11         | 11         |
> | backtrace:genhd_device_init                                              | 0          | 11         | 11         |
> | backtrace:fbmem_init                                                     | 0          | 11         | 11         |
> | backtrace:acpi_init                                                      | 0          | 11         | 11         |
> | backtrace:pnp_init                                                       | 0          | 11         | 11         |
> | backtrace:regulator_fixed_voltage_init                                   | 0          | 11         | 11         |
> | backtrace:pm8607_regulator_init                                          | 0          | 11         | 11         |
> | backtrace:ad5398_init                                                    | 0          | 11         | 11         |
> | backtrace:as3711_regulator_init                                          | 0          | 11         | 11         |
> | backtrace:da9052_regulator_init                                          | 0          | 11         | 11         |
> | backtrace:isl6271a_init                                                  | 0          | 11         | 11         |
> | backtrace:lp3972_module_init                                             | 0          | 11         | 11         |
> | backtrace:lp8755_init                                                    | 0          | 11         | 11         |
> | backtrace:max1586_pmic_init                                              | 0          | 11         | 11         |
> | backtrace:max8952_pmic_init                                              | 0          | 11         | 11         |
> | backtrace:max8973_init                                                   | 0          | 11         | 11         |
> | backtrace:max8998_pmic_init                                              | 0          | 11         | 11         |
> | backtrace:palmas_init                                                    | 0          | 11         | 11         |
> | backtrace:tps51632_init                                                  | 0          | 11         | 11         |
> | backtrace:rc5t583_regulator_init                                         | 0          | 11         | 11         |
> | backtrace:tps62360_init                                                  | 0          | 11         | 11         |
> | backtrace:tps_65023_init                                                 | 0          | 11         | 11         |
> | backtrace:tps65217_regulator_init                                        | 0          | 11         | 11         |
> | backtrace:tps80031_regulator_init                                        | 0          | 11         | 11         |
> | backtrace:twlreg_init                                                    | 0          | 11         | 11         |
> | backtrace:wm831x_dcdc_init                                               | 0          | 11         | 11         |
> | backtrace:wm831x_isink_init                                              | 0          | 11         | 11         |
> | backtrace:wm831x_ldo_init                                                | 0          | 11         | 11         |
> | backtrace:wm8350_regulator_init                                          | 0          | 11         | 11         |
> | backtrace:misc_init                                                      | 0          | 11         | 11         |
> | backtrace:vga_arb_device_init                                            | 0          | 11         | 11         |
> | backtrace:pm860x_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:pm800_i2c_init                                                 | 0          | 11         | 11         |
> | backtrace:pm805_i2c_init                                                 | 0          | 11         | 11         |
> | backtrace:wm831x_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:wm8350_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:tps6507x_i2c_init                                              | 0          | 11         | 11         |
> | backtrace:tps65217_init                                                  | 0          | 11         | 11         |
> | backtrace:tps80031_init                                                  | 0          | 11         | 11         |
> | backtrace:mc13xxx_i2c_init                                               | 0          | 11         | 11         |
> | backtrace:da9052_spi_init                                                | 0          | 11         | 11         |
> | backtrace:da9052_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:max14577_i2c_init                                              | 0          | 11         | 11         |
> | backtrace:max8998_i2c_init                                               | 0          | 11         | 11         |
> | backtrace:palmas_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:rc5t583_i2c_init                                               | 0          | 11         | 11         |
> | backtrace:lm3533_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:as3711_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:dma_buf_init                                                   | 0          | 11         | 11         |
> | backtrace:init_scsi                                                      | 0          | 11         | 11         |
> | backtrace:ata_init                                                       | 0          | 11         | 11         |
> | backtrace:usb_init                                                       | 0          | 11         | 11         |
> | backtrace:usb_phy_generic_init                                           | 0          | 11         | 11         |
> | backtrace:serio_init                                                     | 0          | 11         | 11         |
> | backtrace:gameport_init                                                  | 0          | 11         | 11         |
> | backtrace:input_init                                                     | 0          | 11         | 11         |
> | backtrace:tca8418_keypad_init                                            | 0          | 11         | 11         |
> | backtrace:vprbrd_i2c_init                                                | 0          | 11         | 11         |
> | backtrace:pps_init                                                       | 0          | 11         | 11         |
> | backtrace:power_supply_class_init                                        | 0          | 11         | 11         |
> | backtrace:hwmon_init                                                     | 0          | 11         | 11         |
> | backtrace:watchdog_init                                                  | 0          | 11         | 11         |
> | backtrace:leds_init                                                      | 0          | 11         | 11         |
> | backtrace:iio_init                                                       | 0          | 11         | 11         |
> | backtrace:init_soundcore                                                 | 0          | 11         | 11         |
> | backtrace:net_dev_init                                                   | 0          | 11         | 11         |
> | backtrace:bt_init                                                        | 0          | 11         | 11         |
> | backtrace:nfc_init                                                       | 0          | 11         | 11         |
> | backtrace:pnp_system_init                                                | 0          | 11         | 11         |
> | backtrace:pnpacpi_init                                                   | 0          | 11         | 11         |
> | backtrace:device_create                                                  | 0          | 11         | 11         |
> | backtrace:chr_dev_init                                                   | 0          | 11         | 11         |
> | backtrace:tty_init                                                       | 0          | 11         | 11         |
> | backtrace:firmware_class_init                                            | 0          | 11         | 11         |
> | backtrace:thermal_init                                                   | 0          | 11         | 11         |
> | backtrace:mcb_init                                                       | 0          | 11         | 11         |
> | backtrace:dump_stack                                                     | 0          | 11         | 11         |
> | backtrace:ret_from_fork                                                  | 0          | 11         | 11         |
> | backtrace:inet_init                                                      | 0          | 11         | 11         |
> | initcall_populate_rootfs_returned_with_preemption_imbalance              | 0          | 10         | 10         |
> | initcall_msr_init_returned_with_preemption_imbalance                     | 0          | 10         | 10         |
> | initcall_cpuid_init_returned_with_preemption_imbalance                   | 0          | 10         | 10         |
> | initcall_add_pcspkr_returned_with_preemption_imbalance                   | 0          | 10         | 10         |
> | initcall_sysfb_init_returned_with_preemption_imbalance                   | 0          | 10         | 10         |
> | initcall_init_clocksource_sysfs_returned_with_preemption_imbalance       | 0          | 10         | 10         |
> | initcall_alarmtimer_init_returned_with_preemption_imbalance              | 0          | 10         | 10         |
> | initcall_clockevents_init_sysfs_returned_with_preemption_imbalance       | 0          | 10         | 10         |
> | initcall_udelay_test_init_returned_with_preemption_imbalance             | 0          | 10         | 10         |
> | initcall_audit_init_returned_with_preemption_imbalance                   | 0          | 10         | 10         |
> | initcall_gcov_fs_init_returned_with_preemption_imbalance                 | 0          | 10         | 10         |
> | initcall_perf_event_sysfs_init_returned_with_preemption_imbalance        | 0          | 10         | 10         |
> | initcall_extfrag_debug_init_returned_with_preemption_imbalance           | 0          | 10         | 10         |
> | initcall_init_autofs4_fs_returned_with_preemption_imbalance              | 0          | 10         | 10         |
> | initcall_fuse_init_returned_with_preemption_imbalance                    | 0          | 10         | 10         |
> | initcall_cuse_init_returned_with_preemption_imbalance                    | 0          | 10         | 10         |
> | initcall_ocfs2_init_returned_with_preemption_imbalance                   | 0          | 10         | 10         |
> | initcall_init_o2nm_returned_with_preemption_imbalance                    | 0          | 10         | 10         |
> | initcall_dlm_init_returned_with_preemption_imbalance                     | 0          | 10         | 10         |
> | initcall_bsg_init_returned_with_preemption_imbalance                     | 0          | 10         | 10         |
> | initcall_test_firmware_init_returned_with_preemption_imbalance           | 0          | 10         | 10         |
> | initcall_err_inject_init_returned_with_preemption_imbalance              | 0          | 10         | 10         |
> | kernel_BUG_at_kernel/sched/core.c                                        | 0          | 10         | 10         |
> | invalid_opcode                                                           | 0          | 10         | 10         |
> | RIP:__sched_setscheduler                                                 | 0          | 10         | 10         |
> | Kernel_panic-not_syncing:Fatal_exception_in_interrupt                    | 0          | 10         | 10         |
> | backtrace:msr_init                                                       | 0          | 10         | 10         |
> | backtrace:cpuid_init                                                     | 0          | 10         | 10         |
> | backtrace:sysfb_init                                                     | 0          | 10         | 10         |
> | backtrace:init_clocksource_sysfs                                         | 0          | 10         | 10         |
> | backtrace:alarmtimer_init                                                | 0          | 10         | 10         |
> | backtrace:clockevents_init_sysfs                                         | 0          | 10         | 10         |
> | backtrace:udelay_test_init                                               | 0          | 10         | 10         |
> | backtrace:audit_init                                                     | 0          | 10         | 10         |
> | backtrace:gcov_fs_init                                                   | 0          | 10         | 10         |
> | backtrace:perf_event_sysfs_init                                          | 0          | 10         | 10         |
> | backtrace:extfrag_debug_init                                             | 0          | 10         | 10         |
> | backtrace:init_autofs4_fs                                                | 0          | 10         | 10         |
> | backtrace:fuse_init                                                      | 0          | 10         | 10         |
> | backtrace:misc_register                                                  | 0          | 10         | 10         |
> | backtrace:cuse_init                                                      | 0          | 10         | 10         |
> | backtrace:schedule                                                       | 0          | 10         | 10         |
> | backtrace:ocfs2_init                                                     | 0          | 10         | 10         |
> | backtrace:init_o2nm                                                      | 0          | 10         | 10         |
> | backtrace:dlm_init                                                       | 0          | 10         | 10         |
> | backtrace:bsg_init                                                       | 0          | 10         | 10         |
> | backtrace:test_firmware_init                                             | 0          | 10         | 10         |
> | backtrace:err_inject_init                                                | 0          | 10         | 10         |
> | backtrace:clocksource_watchdog_work                                      | 0          | 10         | 10         |
> | WARNING:at_kernel/time/timer.c:#call_timer_fn()                          | 0          | 2          | 2          |
> | initcall_pm860x_backlight_driver_init_returned_with_preemption_imbalance | 0          | 2          | 2          |
> | backtrace:pm860x_backlight_driver_init                                   | 0          | 2          | 2          |
> +--------------------------------------------------------------------------+------------+------------+------------+
> 
> [    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.020004] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.023514] BUG: scheduling while atomic: swapper/0/0x00000015
> [    0.024022] no locks held by swapper/0.
> [    0.024361] Preemption disabled at:[<ffffffff81b593e3>] printk+0x48/0x4a
> [    0.024949] 
> [    0.025087] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc6-00066-gaee27dfb #526
> [    0.025743] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.026610]  ffff880013fd9a80 ffffffff81fb3e98 ffffffff81b5b203 ffffffff81fb3eb8
> [    0.027300]  ffffffff810b88f7 0000000000000015 0000000000000002 ffffffff81fb3f18
> [    0.027984]  ffffffff81b5e5a5 ffffffff81fb3ed8 ffffffff81fc9580 ffffffff81fb3fd8
> [    0.028671] Call Trace:
> [    0.028892]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.029341]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.030007]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.030474]  [<ffffffff81b63c65>] ? _raw_spin_unlock_irqrestore+0x45/0x80
> [    0.031052]  [<ffffffff81b5e86d>] schedule_preempt_disabled+0x2d/0x80
> [    0.031606]  [<ffffffff81b55d8b>] rest_init+0xab/0xc0
> [    0.032045]  [<ffffffff82104e83>] start_kernel+0x430/0x43d
> [    0.032523]  [<ffffffff82104120>] ? early_idt_handlers+0x120/0x120
> [    0.033055]  [<ffffffff82104463>] x86_64_start_reservations+0x2a/0x2c
> [    0.033614]  [<ffffffff82104541>] x86_64_start_kernel+0xdc/0xeb
> [    0.034153] ------------[ cut here ]------------
> [    0.034563] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.035342] initcall set_real_mode_permissions+0x0/0x99 returned with preemption imbalance 
> [    0.036053] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.036800] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.037664]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.038343]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff88001343ab98
> [    0.039026]  0000000000000000 ffffffff821066aa 0000000000000000 ffff88001344be88
> [    0.039708] Call Trace:
> [    0.040007]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.040452]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.040970]  [<ffffffff821066aa>] ? lpj_setup+0x1b/0x1b
> [    0.041433]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.041926]  [<ffffffff82106738>] ? set_real_mode_permissions+0x8e/0x99
> [    0.042493]  [<ffffffff821066aa>] ? lpj_setup+0x1b/0x1b
> [    0.042944]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.043441]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    0.043940]  [<ffffffff81b63cdc>] ? _raw_spin_unlock_irq+0x3c/0x60
> [    0.044472]  [<ffffffff82105092>] kernel_init_freeable+0x5c/0x19d
> [    0.044989]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.045439]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.045880]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.046339]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.046792] ---[ end trace 16f8d1a3aab8f9b6 ]---
> [    0.047192] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> 
> git bisect start aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d f114040e3ea6e07372334ade75d1ee0775c355e1 --
> git bisect good 159b49f14228ea08208bae5f7acc4fc3007855a1  # 04:42     20+      0  rcu: Don't spawn rcub kthreads on root rcu_node structure
> git bisect good 37ef2c826f085707478eb83383491728b2a09bf9  # 04:51     20+      0  rcu: Make _batches_completed() functions return unsigned long
> git bisect good 0101bc908a4951f3ee423fe0d911ac33af31ace8  # 04:54     20+      3  rcutorture: Drop rcu_torture_completed() and friends
> git bisect good 9dc5383c080bbbc7450ed35f480c210019b71d4f  # 05:02     20+      0  rcutorture: Check from beginning to end of grace period
> git bisect good e59f95320525a690019daa1c1293b7834c2ec47d  # 05:08     20+      0  rcu: Expand SRCU ->completed to 64 bits
> git bisect good 3bbb0a8d640cbdd5d9fa2e3d61292bcae8a29466  # 05:14     20+      1  rcu: Combine DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> # first bad commit: [aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d] Fraga: Preemptible RCU that disables preemption
> git bisect good 3bbb0a8d640cbdd5d9fa2e3d61292bcae8a29466  # 05:15     60+      1  rcu: Combine DEFINE_SRCU() and DEFINE_STATIC_SRCU()
> # extra tests on HEAD of rcu/Fraga1.2014.12.02a
> git bisect  bad aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d  # 05:15      0-     12  Fraga: Preemptible RCU that disables preemption
> # extra tests on tree/branch rcu/Fraga1.2014.12.02a
> git bisect  bad aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d  # 05:15      0-     12  Fraga: Preemptible RCU that disables preemption
> # extra tests on tree/branch linus/master
> git bisect good 3a18ca061311f2f1ee9c44012f89c7436d392117  # 05:17     60+      0  Merge tag 'ext4_for_linus_urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
> # extra tests on tree/branch next/master
> git bisect good e85db7e77c6801b854864ee65c264be164dd02c1  # 05:19     60+      0  Add linux-next specific files for 20141201
> 
> 
> This script may reproduce the error.
> 
> ----------------------------------------------------------------------------
> #!/bin/bash
> 
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
> 
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd
> 
> kvm=(
> 	qemu-system-x86_64
> 	-cpu kvm64
> 	-enable-kvm
> 	-kernel $kernel
> 	-initrd $initrd
> 	-m 320
> 	-smp 1
> 	-net nic,vlan=1,model=e1000
> 	-net user,vlan=1
> 	-boot order=nc
> 	-no-reboot
> 	-watchdog i6300esb
> 	-rtc base=localtime
> 	-serial stdio
> 	-display none
> 	-monitor null 
> )
> 
> append=(
> 	hung_task_panic=1
> 	earlyprintk=ttyS0,115200
> 	debug
> 	apic=debug
> 	sysrq_always_enabled
> 	rcupdate.rcu_cpu_stall_timeout=100
> 	panic=-1
> 	softlockup_panic=1
> 	nmi_watchdog=panic
> 	oops=panic
> 	load_ramdisk=2
> 	prompt_ramdisk=0
> 	console=ttyS0,115200
> 	console=tty0
> 	vga=normal
> 	root=/dev/ram0
> 	rw
> 	drbd.minor_count=8
> )
> 
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
> 
> Thanks,
> Fengguang

> early console in setup code
> [    0.000000] Linux version 3.18.0-rc6-00066-gaee27dfb (kbuild@roam) (gcc version 4.9.1 (Debian 4.9.1-19) ) #526 PREEMPT Wed Dec 3 04:31:16 CST 2014
> [    0.000000] Command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-r0-12011352/rcu:Fraga1.2014.12.02a:aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d:bisect-linux-8/.vmlinuz-aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d-20141203043402-5-client8 branch=rcu/Fraga1.2014.12.02a BOOT_IMAGE=/kernel/x86_64-randconfig-r0-12011352/aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d/vmlinuz-3.18.0-rc6-00066-gaee27dfb drbd.minor_count=8
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.8 present.
> [    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.000000] Hypervisor detected: KVM
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] e820: last_pfn = 0x13fe0 max_arch_pfn = 0x400000000
> [    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
> [    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
> [    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
> [    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at [ffff8800000f0ed0]
> [    0.000000]   mpc: f0ee0-f0fb0
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x02f86000, 0x02f86fff] PGTABLE
> [    0.000000] BRK [0x02f87000, 0x02f87fff] PGTABLE
> [    0.000000] BRK [0x02f88000, 0x02f88fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
> [    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
> [    0.000000] BRK [0x02f89000, 0x02f89fff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
> [    0.000000]  [mem 0x10000000-0x139fffff] page 4k
> [    0.000000] BRK [0x02f8a000, 0x02f8afff] PGTABLE
> [    0.000000] BRK [0x02f8b000, 0x02f8bfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
> [    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
> [    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
> [    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
> [    0.000000] RAMDISK: [mem 0x13cce000-0x13fd7fff]
> [    0.000000] ACPI: Early table checksum verification disabled
> [    0.000000] ACPI: RSDP 0x00000000000F0CF0 000014 (v00 BOCHS )
> [    0.000000] ACPI: RSDT 0x0000000013FE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACP 0x0000000013FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
> [    0.000000] ACPI: DSDT 0x0000000013FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: FACS 0x0000000013FE0000 000040
> [    0.000000] ACPI: SSDT 0x0000000013FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
> [    0.000000] ACPI: APIC 0x0000000013FE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
> [    0.000000] ACPI: HPET 0x0000000013FE181C 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:13fdf001, primary cpu clock
> [    0.000000]  [ffffea0000000000-ffffea00005fffff] PMD -> [ffff880012c00000-ffff8800131fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   empty
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009efff]
> [    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
> [    0.000000] Initmem setup node 0 [mem 0x00001000-0x13fdffff]
> [    0.000000] On node 0 totalpages: 81790
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 21 pages reserved
> [    0.000000]   DMA zone: 3998 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 1216 pages used for memmap
> [    0.000000]   DMA32 zone: 77792 pages, LIFO batch:15
> [    0.000000] ACPI: PM-Timer IO Port: 0x608
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] mapped APIC to ffffffffff5fc000 (        fee00000)
> [    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC INT 02
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC INT 05
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC INT 09
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC INT 0a
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
> [    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC INT 0b
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC INT 01
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC INT 03
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC INT 04
> [    0.000000] ACPI: IRQ5 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC INT 06
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC INT 07
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC INT 08
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] ACPI: IRQ10 used by override.
> [    0.000000] ACPI: IRQ11 used by override.
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC INT 0c
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC INT 0d
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC INT 0e
> [    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC INT 0f
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
> [    0.000000] KVM setup async PF for cpu 0
> [    0.000000] kvm-stealtime: cpu 0, msr 1fe7f40
> [    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on KVM
> [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
> [    0.000000] pcpu-alloc: [0] 0 
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 80489
> [    0.000000] Kernel command line: hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-r0-12011352/rcu:Fraga1.2014.12.02a:aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d:bisect-linux-8/.vmlinuz-aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d-20141203043402-5-client8 branch=rcu/Fraga1.2014.12.02a BOOT_IMAGE=/kernel/x86_64-randconfig-r0-12011352/aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d/vmlinuz-3.18.0-rc6-00066-gaee27dfb drbd.minor_count=8
> [    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
> [    0.000000] Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> [    0.000000] Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> [    0.000000] Memory: 284008K/327160K available (11675K kernel code, 1359K rwdata, 4380K rodata, 888K init, 13964K bss, 43152K reserved)
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000] NR_IRQS:4352 nr_irqs:256 0
> [    0.000000] console [ttyS0] enabled
> [    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.000000] ... MAX_LOCK_DEPTH:          48
> [    0.000000] ... MAX_LOCKDEP_KEYS:        8191
> [    0.000000] ... CLASSHASH_SIZE:          4096
> [    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.000000] ... CHAINHASH_SIZE:          32768
> [    0.000000]  memory used by lock dependency info: 8159 kB
> [    0.000000]  per task-struct memory footprint: 1920 bytes
> [    0.000000] ------------------------
> [    0.000000] | Locking API testsuite:
> [    0.000000] ----------------------------------------------------------------------------
> [    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
> [    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
> [    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
> [    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [    0.000000]       hard-irq read-recursion/123:  ok  |
> [    0.000000]       soft-irq read-recursion/123:  ok  |
> [    0.000000]       hard-irq read-recursion/132:  ok  |
> [    0.000000]       soft-irq read-recursion/132:  ok  |
> [    0.000000]       hard-irq read-recursion/213:  ok  |
> [    0.000000]       soft-irq read-recursion/213:  ok  |
> [    0.000000]       hard-irq read-recursion/231:  ok  |
> [    0.000000]       soft-irq read-recursion/231:  ok  |
> [    0.000000]       hard-irq read-recursion/312:  ok  |
> [    0.000000]       soft-irq read-recursion/312:  ok  |
> [    0.000000]       hard-irq read-recursion/321:  ok  |
> [    0.000000]       soft-irq read-recursion/321:  ok  |
> [    0.000000]   --------------------------------------------------------------------------
> [    0.000000]   | Wound/wait tests |
> [    0.000000]   ---------------------
> [    0.000000]                   ww api failures:  ok  |  ok  |  ok  |
> [    0.000000]                ww contexts mixing:  ok  |  ok  |
> [    0.000000]              finishing ww context:  ok  |  ok  |  ok  |  ok  |
> [    0.000000]                locking mismatches:  ok  |  ok  |  ok  |
> [    0.000000]                  EDEADLK handling:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [    0.000000]            spinlock nest unlocked:  ok  |
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                                  |block | try  |context|
> [    0.000000]   -----------------------------------------------------
> [    0.000000]                           context:  ok  |  ok  |  ok  |
> [    0.000000]                               try:  ok  |  ok  |  ok  |
> [    0.000000]                             block:  ok  |  ok  |  ok  |
> [    0.000000]                          spinlock:  ok  |  ok  |  ok  |
> [    0.000000] -------------------------------------------------------
> [    0.000000] Good, all 253 testcases passed! |
> [    0.000000] ---------------------------------
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Detected 2925.998 MHz processor
> [    0.020000] Calibrating delay loop (skipped) preset value.. 5851.99 BogoMIPS (lpj=29259980)
> [    0.020000] pid_max: default: 32768 minimum: 301
> [    0.020000] ACPI: Core revision 20140926
> [    0.020000] ACPI: All ACPI Tables successfully acquired
> [    0.020000] Security Framework initialized
> [    0.020000] Yama: becoming mindful.
> [    0.020000] Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.020000] Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> [    0.020000] mce: CPU supports 10 MCE banks
> [    0.020000] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> [    0.020000] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> [    0.020004] CPU: Intel Common KVM processor (fam: 0f, model: 06, stepping: 01)
> [    0.023514] BUG: scheduling while atomic: swapper/0/0x00000015
> [    0.024022] no locks held by swapper/0.
> [    0.024361] Preemption disabled at:[<ffffffff81b593e3>] printk+0x48/0x4a
> [    0.024949] 
> [    0.025087] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc6-00066-gaee27dfb #526
> [    0.025743] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.026610]  ffff880013fd9a80 ffffffff81fb3e98 ffffffff81b5b203 ffffffff81fb3eb8
> [    0.027300]  ffffffff810b88f7 0000000000000015 0000000000000002 ffffffff81fb3f18
> [    0.027984]  ffffffff81b5e5a5 ffffffff81fb3ed8 ffffffff81fc9580 ffffffff81fb3fd8
> [    0.028671] Call Trace:
> [    0.028892]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.029341]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.030007]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.030474]  [<ffffffff81b63c65>] ? _raw_spin_unlock_irqrestore+0x45/0x80
> [    0.031052]  [<ffffffff81b5e86d>] schedule_preempt_disabled+0x2d/0x80
> [    0.031606]  [<ffffffff81b55d8b>] rest_init+0xab/0xc0
> [    0.032045]  [<ffffffff82104e83>] start_kernel+0x430/0x43d
> [    0.032523]  [<ffffffff82104120>] ? early_idt_handlers+0x120/0x120
> [    0.033055]  [<ffffffff82104463>] x86_64_start_reservations+0x2a/0x2c
> [    0.033614]  [<ffffffff82104541>] x86_64_start_kernel+0xdc/0xeb
> [    0.034153] ------------[ cut here ]------------
> [    0.034563] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.035342] initcall set_real_mode_permissions+0x0/0x99 returned with preemption imbalance 
> [    0.036053] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.036800] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.037664]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.038343]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff88001343ab98
> [    0.039026]  0000000000000000 ffffffff821066aa 0000000000000000 ffff88001344be88
> [    0.039708] Call Trace:
> [    0.040007]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.040452]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.040970]  [<ffffffff821066aa>] ? lpj_setup+0x1b/0x1b
> [    0.041433]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.041926]  [<ffffffff82106738>] ? set_real_mode_permissions+0x8e/0x99
> [    0.042493]  [<ffffffff821066aa>] ? lpj_setup+0x1b/0x1b
> [    0.042944]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.043441]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    0.043940]  [<ffffffff81b63cdc>] ? _raw_spin_unlock_irq+0x3c/0x60
> [    0.044472]  [<ffffffff82105092>] kernel_init_freeable+0x5c/0x19d
> [    0.044989]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.045439]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.045880]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.046339]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.046792] ---[ end trace 16f8d1a3aab8f9b6 ]---
> [    0.047192] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
> [    0.048070] BUG: scheduling while atomic: kthreadd/2/0x00000007
> [    0.048589] no locks held by kthreadd/2.
> [    0.048931] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.049587] 
> [    0.049725] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.050004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.050868]  ffff88001343ab98 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.051554]  ffffffff810b88f7 0000000000000007 ffffffff81ff35e0 ffff88001344fef8
> [    0.052241]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.052925] Call Trace:
> [    0.053145]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.053589]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.054065]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.054522]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.054954]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.055398]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.055869]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.056337]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.056902] BUG: scheduling while atomic: kthreadd/2/0x0000000d
> [    0.057422] no locks held by kthreadd/2.
> [    0.057760] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.058414] 
> [    0.058552] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.060004] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.060871]  ffff88001343ae38 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.061553]  ffffffff810b88f7 000000000000000d ffffffff81ff35e0 ffff88001344fef8
> [    0.062240]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.062927] Call Trace:
> [    0.063147]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.063593]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.064065]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.064523]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.064956]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.065398]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.065872]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.066335]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.066883] BUG: scheduling while atomic: kthreadd/2/0x00000013
> [    0.067401] no locks held by kthreadd/2.
> [    0.067745] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.068395] 
> [    0.068532] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.069287] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.070005]  ffff8800134600a0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.070692]  ffffffff810b88f7 0000000000000013 ffffffff81ff35e0 ffff88001344fef8
> [    0.071376]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.072063] Call Trace:
> [    0.072283]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.072734]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.073207]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.073671]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.074099]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.074548]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.075021]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.075489]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.076066] BUG: scheduling while atomic: kthreadd/2/0x00000019
> [    0.076584] no locks held by kthreadd/2.
> [    0.076923] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.077578] 
> [    0.077716] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.078472] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.079330]  ffff8800134603c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.080306]  ffffffff810b88f7 0000000000000019 ffffffff81ff35e0 ffff88001344fef8
> [    0.080995]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.081680] Call Trace:
> [    0.081900]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.082344]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.082819]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.083276]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.083708]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.084151]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.084626]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.085094]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.085651] BUG: scheduling while atomic: kthreadd/2/0x0000001f
> [    0.086163] no locks held by kthreadd/2.
> [    0.086503] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.087158] 
> [    0.087295] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.088049] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.088916]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.089598]  ffffffff810b88f7 000000000000001f ffffffff81ff35e0 ffff88001344fef8
> [    0.090308]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.090997] Call Trace:
> [    0.091216]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.091663]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.092134]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.092594]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.093023]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.093465]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.093942]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.094407]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.094916] BUG: scheduling while atomic: kthreadd/2/0x00000025
> [    0.095425] no locks held by kthreadd/2.
> [    0.095769] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.096429] 
> [    0.096567] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.097325] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.098198]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.098902]  ffffffff810b88f7 0000000000000025 ffffffff81ff35e0 ffff88001344fef8
> [    0.099603]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.100316] Call Trace:
> [    0.100549]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.100997]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.101475]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.101943]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.102379]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.102836]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.103314]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.103791]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.104331] BUG: scheduling while atomic: kthreadd/2/0x0000002b
> [    0.104873] no locks held by kthreadd/2.
> [    0.105219] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.105888] 
> [    0.106031] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.106792] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.107666]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.108349]  ffffffff810b88f7 000000000000002b ffffffff81ff35e0 ffff88001344fef8
> [    0.109036]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.109726] Call Trace:
> [    0.110015]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.110468]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.110951]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.111407]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.111842]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.112293]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.112774]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.113240]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.113786] BUG: scheduling while atomic: kthreadd/2/0x00000031
> [    0.114301] no locks held by kthreadd/2.
> [    0.114653] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.115307] 
> [    0.115445] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.116210] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.117099]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.117787]  ffffffff810b88f7 0000000000000031 ffffffff81ff35e0 ffff88001344fef8
> [    0.118473]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.119161] Call Trace:
> [    0.119383]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.119831]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.120009]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.120476]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.120904]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.121348]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.121828]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.122297]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.122828] BUG: scheduling while atomic: kthreadd/2/0x00000037
> [    0.123344] no locks held by kthreadd/2.
> [    0.123682] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.124333] 
> [    0.124471] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.125224] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.126077]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.126759]  ffffffff810b88f7 0000000000000037 ffffffff81ff35e0 ffff88001344fef8
> [    0.127441]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.128122] Call Trace:
> [    0.128346]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.128787]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.129261]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.130008]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.130443]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.130884]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.131354]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.131818]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.132326] BUG: scheduling while atomic: kthreadd/2/0x0000003d
> [    0.132841] no locks held by kthreadd/2.
> [    0.133180] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.133835] 
> [    0.133974] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.134732] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.135601]  ffff880013460238 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.136288]  ffffffff810b88f7 000000000000003d ffffffff81ff35e0 ffff88001344fef8
> [    0.136969]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.137652] Call Trace:
> [    0.137870]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.138311]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.138785]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.139241]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.139672]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.140006]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.140485]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.140948]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.141482] Getting VERSION: 1050014
> [    0.141798] Getting VERSION: 1050014
> [    0.142112] Getting ID: 0
> [    0.142354] Getting ID: ff000000
> [    0.142643] Getting LVT0: 8700
> [    0.142912] Getting LVT1: 8400
> [    0.143222] enabled ExtINT on CPU#0
> [    0.144169] ENABLING IO-APIC IRQs
> [    0.144473] init IO_APIC IRQs
> [    0.144735]  apic 0 pin 0 not connected
> [    0.145091] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    0.145793] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.146482] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
> [    0.147170] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
> [    0.147858] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    0.148549] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
> [    0.149233] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    0.150024] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    0.150718] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    0.151413] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.152099] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
> [    0.152829] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
> [    0.153865] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    0.154639] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
> [    0.155340] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
> [    0.156036] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
> [    0.156733]  apic 0 pin 16 not connected
> [    0.157070]  apic 0 pin 17 not connected
> [    0.157410]  apic 0 pin 18 not connected
> [    0.157745]  apic 0 pin 19 not connected
> [    0.158081]  apic 0 pin 20 not connected
> [    0.158421]  apic 0 pin 21 not connected
> [    0.158757]  apic 0 pin 22 not connected
> [    0.159091]  apic 0 pin 23 not connected
> [    0.159566] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.160034] Using local APIC timer interrupts.
> [    0.160034] calibrating APIC timer ...
> [    0.170000] ... lapic delta = 6249816
> [    0.170000] ... PM-Timer delta = 357973
> [    0.170000] ... PM-Timer result ok
> [    0.170000] ..... delta 6249816
> [    0.170000] ..... mult: 268427553
> [    0.170000] ..... calibration result: 9999705
> [    0.170000] ..... CPU clock speed is 2926.1228 MHz.
> [    0.170000] ..... host bus clock speed is 999.9705 MHz.
> [    0.170000] BUG: scheduling while atomic: kthreadd/2/0x00000043
> [    0.170000] no locks held by kthreadd/2.
> [    0.170000] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.170000] 
> [    0.170000] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.170000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.170000]  ffff880013460df0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.170000]  ffffffff810b88f7 0000000000000043 ffffffff81ff35e0 ffff88001344fef8
> [    0.170000]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.170000] Call Trace:
> [    0.170000]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.170000]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.170000]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.170000]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.170000]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.170000]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.170000]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.170000]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.170000] BUG: scheduling while atomic: kthreadd/2/0x00000049
> [    0.170000] no locks held by kthreadd/2.
> [    0.170000] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.170353] 
> [    0.170485] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.171218] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.172054]  ffff880013460fb0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.172714]  ffffffff810b88f7 0000000000000049 ffffffff81ff35e0 ffff88001344fef8
> [    0.173375]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.174036] Call Trace:
> [    0.174248]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.174673]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.175129]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.175569]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.175984]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.176408]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.176865]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.177311]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.177976] BUG: scheduling while atomic: kdevtmpfs/14/0x00000017
> [    0.178484] no locks held by kdevtmpfs/14.
> [    0.178827] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    0.179463] 
> [    0.179595] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.180002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.180835]  ffff88001344bee4 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    0.181496]  ffffffff810b88f7 0000000000000017 0000000000000000 ffff8800134c3df8
> [    0.182154]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    0.182816] Call Trace:
> [    0.183027]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.183451]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.183909]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.184349]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.184764]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    0.185198]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    0.185723]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    0.186134]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    0.186618]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.187067]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    0.187582] devtmpfs: initialized
> [    0.188666] BUG: scheduling while atomic: kthreadd/2/0x0000004f
> [    0.189161] no locks held by kthreadd/2.
> [    0.189492] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.190352] 
> [    0.190485] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.191215] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.192097]  ffff8800134b6f30 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.192756]  ffffffff810b88f7 000000000000004f ffffffff81ff35e0 ffff88001344fef8
> [    0.193404]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.194050] Call Trace:
> [    0.194253]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.194662]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.195101]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.195521]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.195923]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.196335]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.196890]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.197319]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.197812] prandom: seed boundary self test passed
> [    0.198720] prandom: 100 self tests passed
> [    0.199052] atomic64_test: passed for x86-64 platform with CX8 and with SSE
> [    0.200213] regulator-dummy: no parameters
> [    0.200623] ------------[ cut here ]------------
> [    0.201119] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.201847] initcall regulator_init+0x0/0x6d returned with preemption imbalance 
> [    0.202446] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.203155] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.203992]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.204650]  ffffffff8109b88b 0000000000000000 0000000000000000 ffff8800134b7368
> [    0.205364]  0000000000000000 ffffffff82129272 0000000000000000 ffff88001344be88
> [    0.206028] Call Trace:
> [    0.206241]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.206670]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.207169]  [<ffffffff82129272>] ? pnpacpi_parse_resource_option_data+0x8c/0x8c
> [    0.207775]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.208254]  [<ffffffff821294a6>] ? regulator_dummy_init+0x65/0x87
> [    0.208764]  [<ffffffff82129272>] ? pnpacpi_parse_resource_option_data+0x8c/0x8c
> [    0.209419]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.209893]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.210004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.210440]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.210869]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.211316]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.211750] ---[ end trace 16f8d1a3aab8f9b7 ]---
> [    0.212309] NET: Registered protocol family 16
> [    0.212890] ------------[ cut here ]------------
> [    0.213284] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.214041] initcall bdi_class_init+0x0/0x49 returned with preemption imbalance 
> [    0.214650] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.215365] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.216200]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.216909]  ffffffff8109b88b 00000003716ffe5a 0000000000000000 ffff8800134c6370
> [    0.217616]  0000000000000000 ffffffff8211aa78 0000000000000000 ffff88001344be88
> [    0.218271] Call Trace:
> [    0.218482]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.218960]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.219454]  [<ffffffff8211aa78>] ? extfrag_debug_init+0x7a/0x7a
> [    0.220004]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.220479]  [<ffffffff8211aa78>] ? extfrag_debug_init+0x7a/0x7a
> [    0.220981]  [<ffffffff8211aa78>] ? extfrag_debug_init+0x7a/0x7a
> [    0.221472]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.221950]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.222458]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.222891]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.223314]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.223762]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.224192] ---[ end trace 16f8d1a3aab8f9b8 ]---
> [    0.224612] ------------[ cut here ]------------
> [    0.225001] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.225756] initcall pcibus_class_init+0x0/0x19 returned with preemption imbalance 
> [    0.226382] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.227102] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.227943]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.228607]  ffffffff8109b88b ffffffff82125585 0000000000000000 ffff8800134c6650
> [    0.229266]  0000000000000000 ffffffff82125585 0000000000000000 ffff88001344be88
> [    0.230294] Call Trace:
> [    0.230505]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.230932]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.231429]  [<ffffffff82125585>] ? pci_sort_bf_cmp+0x57/0x57
> [    0.231904]  [<ffffffff82125585>] ? pci_sort_bf_cmp+0x57/0x57
> [    0.232381]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.232855]  [<ffffffff82125585>] ? pci_sort_bf_cmp+0x57/0x57
> [    0.233331]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.233804]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.234314]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.234745]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.235221]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.235666]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.236099] ---[ end trace 16f8d1a3aab8f9b9 ]---
> [    0.236522] ------------[ cut here ]------------
> [    0.236912] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.237672] initcall pci_driver_init+0x0/0x12 returned with preemption imbalance 
> [    0.238290] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.239009] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.239835]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.240423]  ffffffff8109b88b ffffffff820170d0 0000000000000000 ffff8800134c6708
> [    0.241085]  0000000000000000 ffffffff82125904 0000000000000000 ffff88001344be88
> [    0.241742] Call Trace:
> [    0.241959]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.242385]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.242885]  [<ffffffff82125904>] ? pci_register_set_vga_state+0xd/0xd
> [    0.243423]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.243900]  [<ffffffff82125904>] ? pci_register_set_vga_state+0xd/0xd
> [    0.244434]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.244909]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.245416]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.245846]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.246272]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.246716]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.247201] ---[ end trace 16f8d1a3aab8f9ba ]---
> [    0.247602] ------------[ cut here ]------------
> [    0.247993] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.248745] initcall backlight_class_init+0x0/0xaa returned with preemption imbalance 
> [    0.249397] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.250002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.250830]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.251484]  ffffffff8109b88b ffffffff81e96374 0000000000000000 ffff8800134c6cc0
> [    0.252141]  0000000000000000 ffffffff82125bd8 0000000000000000 ffff88001344be88
> [    0.252800] Call Trace:
> [    0.253011]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.253436]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.253932]  [<ffffffff82125bd8>] ? as3711_backlight_driver_init+0x14/0x14
> [    0.254494]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.254970]  [<ffffffff82125bd8>] ? as3711_backlight_driver_init+0x14/0x14
> [    0.255532]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.256008]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.256513]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.256995]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.257418]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.257876]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.258308] ---[ end trace 16f8d1a3aab8f9bb ]---
> [    0.258724] ------------[ cut here ]------------
> [    0.259117] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.260003] initcall anatop_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.260657] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.261378] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.262211]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.262873]  ffffffff8109b88b ffff8800134d1138 0000000000000000 ffff8800134c6e08
> [    0.263535]  0000000000000000 ffffffff8212952c 0000000000000000 ffff88001344be88
> [    0.264195] Call Trace:
> [    0.264406]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.264833]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.265333]  [<ffffffff8212952c>] ? ad5398_init+0x14/0x14
> [    0.265781]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.266259]  [<ffffffff8212952c>] ? ad5398_init+0x14/0x14
> [    0.266703]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.267180]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.267687]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.268123]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.268548]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.268997]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.269429] ---[ end trace 16f8d1a3aab8f9bc ]---
> [    0.269828] ------------[ cut here ]------------
> [    0.270004] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.270763] initcall tty_class_init+0x0/0x34 returned with preemption imbalance 
> [    0.271368] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.272089] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.272952]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.273612]  ffffffff8109b88b ffff8800134d0628 0000000000000000 ffff8800134d1138
> [    0.274273]  0000000000000000 ffffffff8212989c 0000000000000000 ffff88001344be88
> [    0.274933] Call Trace:
> [    0.275144]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.275569]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.276070]  [<ffffffff8212989c>] ? wm8994_ldo_driver_init+0x14/0x14
> [    0.276593]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.277071]  [<ffffffff8212989c>] ? wm8994_ldo_driver_init+0x14/0x14
> [    0.277593]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.278070]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.278577]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.279064]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.279489]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.280004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.280436] ---[ end trace 16f8d1a3aab8f9bd ]---
> [    0.280843] ------------[ cut here ]------------
> [    0.281229] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.281987] initcall regmap_initcall+0x0/0xd returned with preemption imbalance 
> [    0.282595] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.283316] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.284149]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.284859]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff8800134d1270
> [    0.285512]  0000000000000000 ffffffff8212cc5e 0000000000000000 ffff88001344be88
> [    0.286171] Call Trace:
> [    0.286382]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.286813]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.287306]  [<ffffffff8212cc5e>] ? firmware_class_init+0x5e/0x5e
> [    0.287816]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.288292]  [<ffffffff8212cc5e>] ? firmware_class_init+0x5e/0x5e
> [    0.288802]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.289276]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.290004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.290439]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.290863]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.291314]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.291748] ---[ end trace 16f8d1a3aab8f9be ]---
> [    0.292165] ------------[ cut here ]------------
> [    0.292553] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.293308] initcall sram_init+0x0/0x14 returned with preemption imbalance 
> [    0.293881] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.294604] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.295441]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.296103]  ffffffff8109b88b ffff8800134d15c0 0000000000000000 ffff8800134d1270
> [    0.296759]  0000000000000000 ffffffff8212edac 0000000000000000 ffff88001344be88
> [    0.297421] Call Trace:
> [    0.297632]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.298062]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.298557]  [<ffffffff8212edac>] ? fsa9480_i2c_driver_init+0x14/0x14
> [    0.299090]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.299567]  [<ffffffff8212edac>] ? fsa9480_i2c_driver_init+0x14/0x14
> [    0.300004]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.300480]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.300994]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.301427]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.301858]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.302303]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.302734] ---[ end trace 16f8d1a3aab8f9bf ]---
> [    0.303149] ------------[ cut here ]------------
> [    0.303539] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.304303] initcall syscon_init+0x0/0x14 returned with preemption imbalance 
> [    0.304898] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.305623] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.306460]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.307124]  ffffffff8109b88b ffff8800134d1910 0000000000000000 ffff8800134d15c0
> [    0.307784]  0000000000000000 ffffffff8212f09b 0000000000000000 ffff88001344be88
> [    0.308447] Call Trace:
> [    0.308658]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.309089]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.309585]  [<ffffffff8212f09b>] ? rn5t618_i2c_driver_init+0x14/0x14
> [    0.310003]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.310479]  [<ffffffff8212f09b>] ? rn5t618_i2c_driver_init+0x14/0x14
> [    0.311015]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.311489]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.312001]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.312436]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.312865]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.313311]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.313747] ---[ end trace 16f8d1a3aab8f9c0 ]---
> [    0.314180] ------------[ cut here ]------------
> [    0.314568] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.315326] initcall spi_init+0x0/0x7f returned with preemption imbalance 
> [    0.315897] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.316615] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.317451]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.318118]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff8800134d1910
> [    0.318781]  0000000000000000 ffffffff82130f47 0000000000000000 ffff88001344be88
> [    0.319443] Call Trace:
> [    0.319656]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.320004]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.320505]  [<ffffffff82130f47>] ? tcmu_module_init+0xae/0xae
> [    0.320993]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.321469]  [<ffffffff82130f47>] ? tcmu_module_init+0xae/0xae
> [    0.321955]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.322430]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.322943]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.323377]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.323805]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.324253]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.324688] ---[ end trace 16f8d1a3aab8f9c1 ]---
> [    0.325116] ------------[ cut here ]------------
> [    0.325506] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.326265] initcall spmi_init+0x0/0x12 returned with preemption imbalance 
> [    0.326840] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.327559] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.328395]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.329086]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff8800134d1f40
> [    0.330030]  0000000000000000 ffffffff821310d1 0000000000000000 ffff88001344be88
> [    0.330691] Call Trace:
> [    0.330907]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.331334]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.331830]  [<ffffffff821310d1>] ? xilinx_spi_driver_init+0x14/0x14
> [    0.332358]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.332834]  [<ffffffff821310d1>] ? xilinx_spi_driver_init+0x14/0x14
> [    0.333361]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.333838]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.334351]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.334784]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.335214]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.335660]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.336096] ---[ end trace 16f8d1a3aab8f9c2 ]---
> [    0.336549] ------------[ cut here ]------------
> [    0.336945] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.337704] initcall i2c_init+0x0/0x44 returned with preemption imbalance 
> [    0.338275] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.339000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.339836]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.340427]  ffffffff8109b88b ffff8800134d2a70 0000000000000000 ffff8800134d3470
> [    0.341091]  0000000000000000 ffffffff82134733 0000000000000000 ffff88001344be88
> [    0.341753] Call Trace:
> [    0.341969]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.342397]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.342898]  [<ffffffff82134733>] ? i2c_register_board_info+0xa1/0xa1
> [    0.343430]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.343910]  [<ffffffff82134733>] ? i2c_register_board_info+0xa1/0xa1
> [    0.344442]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.344921]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.345432]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.345870]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.346296]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.346743]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.347178] ---[ end trace 16f8d1a3aab8f9c3 ]---
> [    0.350009] BUG: scheduling while atomic: swapper/0/0x00000019
> [    0.350503] no locks held by swapper/0.
> [    0.350828] Preemption disabled at:[<ffffffff81b593e3>] printk+0x48/0x4a
> [    0.351403] 
> [    0.351537] CPU: 0 PID: 0 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.352266] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.353107]  ffffffff81fb0000 ffffffff81fb3e28 ffffffff81b5b203 ffffffff81fb3e48
> [    0.353769]  ffffffff810b88f7 0000000000000019 0000000000000000 ffffffff81fb3ea8
> [    0.354433]  ffffffff81b5e5a5 0000000000000000 ffffffff81fc9580 ffffffff81fb3fd8
> [    0.355095] Call Trace:
> [    0.355307]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.355734]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.356191]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.356633]  [<ffffffff810c7974>] ? trace_hardirqs_on_caller+0x114/0x260
> [    0.357192]  [<ffffffff81b5e86d>] schedule_preempt_disabled+0x2d/0x80
> [    0.357724]  [<ffffffff810c1092>] cpu_startup_entry+0x172/0x350
> [    0.358217]  [<ffffffff81b55d95>] rest_init+0xb5/0xc0
> [    0.358637]  [<ffffffff82104e83>] start_kernel+0x430/0x43d
> [    0.359094]  [<ffffffff82104120>] ? early_idt_handlers+0x120/0x120
> [    0.359603]  [<ffffffff82104463>] x86_64_start_reservations+0x2a/0x2c
> [    0.360004]  [<ffffffff82104541>] x86_64_start_kernel+0xdc/0xeb
> [    0.360522] cpuidle: using governor menu
> [    0.361058] ------------[ cut here ]------------
> [    0.361453] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.362217] initcall arch_kdebugfs_init+0x0/0x214 returned with preemption imbalance 
> [    0.362866] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.363590] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.364428]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.365141]  ffffffff8109b88b ffff88001344be88 0000000000000000 ffff8800134d3f20
> [    0.365805]  0000000000000000 ffffffff82109707 0000000000000000 ffff88001344be88
> [    0.366471] Call Trace:
> [    0.366684]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.367119]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.367619]  [<ffffffff82109707>] ? topology_init+0x16/0x16
> [    0.368086]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.368565]  [<ffffffff82109707>] ? topology_init+0x16/0x16
> [    0.369033]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.369511]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.370004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.370441]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.370875]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.371326]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.371765] ---[ end trace 16f8d1a3aab8f9c4 ]---
> [    0.372192] ACPI: bus type PCI registered
> [    0.372651] ------------[ cut here ]------------
> [    0.373046] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.373806] initcall dmi_id_init+0x0/0x2fe returned with preemption imbalance 
> [    0.374400] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.375120] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.375951]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.376607]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff8800134d3f20
> [    0.377314]  0000000000000000 ffffffff8213b342 0000000000000000 ffff88001344be88
> [    0.377972] Call Trace:
> [    0.378183]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.378608]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.379106]  [<ffffffff8213b342>] ? dcdbas_init+0x57/0x57
> [    0.379551]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.380004]  [<ffffffff8213b342>] ? dcdbas_init+0x57/0x57
> [    0.380451]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.380931]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.381446]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.381885]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.382314]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.382766]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.383200] ---[ end trace 16f8d1a3aab8f9c5 ]---
> [    0.383633] PCI: Using configuration type 1 for base access
> [    0.384298] ------------[ cut here ]------------
> [    0.384689] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.385447] initcall topology_init+0x0/0x16 returned with preemption imbalance 
> [    0.386052] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.386781] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.387610]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.388271]  ffffffff8109b88b ffff8800134d6c78 0000000000000000 ffff8800134d6c78
> [    0.388934]  0000000000000000 ffffffff821096f1 0000000000000000 ffff88001344be88
> [    0.389592] Call Trace:
> [    0.390004]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.390432]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.390924]  [<ffffffff821096f1>] ? pci_iommu_alloc+0x6e/0x6e
> [    0.391400]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.391876]  [<ffffffff815b2d42>] ? register_cpu+0xc2/0xe0
> [    0.392330]  [<ffffffff821096f1>] ? pci_iommu_alloc+0x6e/0x6e
> [    0.392800]  [<ffffffff821096f1>] ? pci_iommu_alloc+0x6e/0x6e
> [    0.393277]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.393749]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.394263]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.394695]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.395124]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.395568]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.396001] ---[ end trace 16f8d1a3aab8f9c6 ]---
> [    0.401178] ------------[ cut here ]------------
> [    0.401569] WARNING: CPU: 0 PID: 1 at kernel/sched/core.c:2603 preempt_count_add+0xa4/0xb0()
> [    0.402392] DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >= PREEMPT_MASK - 10)
> [    0.403032] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.403778] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.404612]  0000000000000009 ffff88001344bc08 ffffffff81b5b203 ffff88001344bc48
> [    0.405273]  ffffffff8109b88b 0000000000000000 0000000000000001 0000000000000286
> [    0.405929]  000000000000000b ffffffff81f6306f 0000000000000015 ffff88001344bca8
> [    0.406593] Call Trace:
> [    0.406804]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.407236]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.407733]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.408212]  [<ffffffff810b9894>] preempt_count_add+0xa4/0xb0
> [    0.408688]  [<ffffffff81b63ace>] _raw_spin_lock_irqsave+0x2e/0x70
> [    0.409201]  [<ffffffff814bbaf3>] ? __this_cpu_preempt_check+0x13/0x20
> [    0.409739]  [<ffffffff81143626>] slob_free+0x76/0x490
> [    0.410000]  [<ffffffff81143e9f>] kfree+0x7f/0x90
> [    0.410000]  [<ffffffff81494430>] kobject_uevent_env+0xf0/0x530
> [    0.410000]  [<ffffffff8149487b>] kobject_uevent+0xb/0x10
> [    0.410000]  [<ffffffff821165d5>] param_sysfs_init+0x2b2/0x2e8
> [    0.410000]  [<ffffffff811436bf>] ? slob_free+0x10f/0x490
> [    0.410000]  [<ffffffff82116323>] ? locate_module_kobject+0xb0/0xb0
> [    0.410000]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    0.410000]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.410000]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.410000]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.410000]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.410000]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.410000] ---[ end trace 16f8d1a3aab8f9c7 ]---
> [    0.420004] ------------[ cut here ]------------
> [    0.420396] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.421155] initcall param_sysfs_init+0x0/0x2e8 returned with preemption imbalance 
> [    0.421781] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.422499] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.423329]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.423989]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff8800134b4fe8
> [    0.424648]  0000000000000000 ffffffff82116323 0000000000000000 ffff88001344be88
> [    0.425308] Call Trace:
> [    0.425519]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.425947]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.426444]  [<ffffffff82116323>] ? locate_module_kobject+0xb0/0xb0
> [    0.426962]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.427438]  [<ffffffff82116323>] ? locate_module_kobject+0xb0/0xb0
> [    0.427954]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.428435]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.428946]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.429381]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.429805]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.430003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.430437] ---[ end trace 16f8d1a3aab8f9c8 ]---
> [    0.430852] BUG: scheduling while atomic: kthreadd/2/0x00000055
> [    0.431343] INFO: lockdep is turned off.
> [    0.431670] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.432302] 
> [    0.432435] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.433215] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.434051]  ffff880013500528 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.434711]  ffffffff810b88f7 0000000000000055 ffffffff81ff35e0 ffff88001344fef8
> [    0.435368]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.436027] Call Trace:
> [    0.436238]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.436666]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.437122]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.437562]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.437979]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.438406]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.438863]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.439310]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.440034] BUG: scheduling while atomic: kthreadd/2/0x0000005b
> [    0.440526] INFO: lockdep is turned off.
> [    0.440853] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.441481] 
> [    0.441613] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.442340] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.443173]  ffff880013500548 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.443832]  ffffffff810b88f7 000000000000005b ffffffff81ff35e0 ffff88001344fef8
> [    0.444542]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.445252] Call Trace:
> [    0.445463]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.445888]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.446343]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.446783]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.447197]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.447622]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.448078]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.448523]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.449065] ------------[ cut here ]------------
> [    0.449459] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.450004] initcall default_bdi_init+0x0/0x6e returned with preemption imbalance 
> [    0.450625] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.451347] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.452179]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.452837]  ffffffff8109b88b ffffffff81ef191a 0000000000000000 ffff880013500528
> [    0.453494]  0000000000000000 ffffffff8211aac1 0000000000000000 ffff88001344be88
> [    0.454153] Call Trace:
> [    0.454362]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.454793]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.455293]  [<ffffffff8211aac1>] ? bdi_class_init+0x49/0x49
> [    0.455767]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.456244]  [<ffffffff8112275a>] ? bdi_init+0x1fa/0x210
> [    0.456686]  [<ffffffff8211aac1>] ? bdi_class_init+0x49/0x49
> [    0.457159]  [<ffffffff8211aac1>] ? bdi_class_init+0x49/0x49
> [    0.457631]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.458112]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.458623]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.459061]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.459489]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.460003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.460444] ---[ end trace 16f8d1a3aab8f9c9 ]---
> [    0.460898] BUG: scheduling while atomic: kthreadd/2/0x00000061
> [    0.461388] INFO: lockdep is turned off.
> [    0.461714] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.462344] 
> [    0.462476] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.463204] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.464038]  ffff880013504e60 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.464695]  ffffffff810b88f7 0000000000000061 ffffffff81ff35e0 ffff88001344fef8
> [    0.465352]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.466008] Call Trace:
> [    0.466217]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.466641]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.467094]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.467529]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.467941]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.468366]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.468867]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.469311]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.470018] BUG: scheduling while atomic: kthreadd/2/0x00000067
> [    0.470508] INFO: lockdep is turned off.
> [    0.470832] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.471462] 
> [    0.471594] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.472320] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.473152]  ffff8800135062b8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.473807]  ffffffff810b88f7 0000000000000067 ffffffff81ff35e0 ffff88001344fef8
> [    0.474467]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.475128] Call Trace:
> [    0.475338]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.475763]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.476250]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.476689]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.477106]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.477531]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.477988]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.478432]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.478913] BUG: scheduling while atomic: swapper/1/0x00000003
> [    0.479401] INFO: lockdep is turned off.
> [    0.479728] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    0.480393] 
> [    0.480529] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.481252] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.482089]  ffff88001344bcb8 ffff88001344bab8 ffffffff81b5b203 ffff88001344bad8
> [    0.482745]  ffffffff810b88f7 0000000000000003 7fffffffffffffff ffff88001344bb38
> [    0.483452]  ffffffff81b5e5a5 ffffffffffffffff ffff880013444000 ffff88001344bfd8
> [    0.484112] Call Trace:
> [    0.484322]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.484746]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.485248]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.485688]  [<ffffffff81034075>] ? kernel_map_pages+0x95/0x100
> [    0.486179]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.486591]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    0.487075]  [<ffffffff81b5fa83>] ? wait_for_completion_killable+0x33/0x1e0
> [    0.487648]  [<ffffffff810bde7d>] ? __enqueue_entity+0x6d/0x70
> [    0.488225]  [<ffffffff81b5fb2f>] wait_for_completion_killable+0xdf/0x1e0
> [    0.488784]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    0.489287]  [<ffffffff810afe30>] ? put_pwq_unlocked+0x40/0x40
> [    0.489769]  [<ffffffff810b4bf1>] kthread_create_on_node+0x161/0x230
> [    0.490004]  [<ffffffff81143b42>] ? slob_alloc+0x52/0x210
> [    0.490507]  [<ffffffff810b211c>] __alloc_workqueue_key+0x31c/0x410
> [    0.491024]  [<ffffffff81483100>] ? exact_match+0x10/0x10
> [    0.491467]  [<ffffffff81143d71>] ? __kmalloc+0x71/0x90
> [    0.491950]  [<ffffffff821223ab>] ? proc_genhd_init+0x3c/0x3c
> [    0.492423]  [<ffffffff8212224c>] blk_dev_init+0x27/0x87
> [    0.492863]  [<ffffffff821223f7>] genhd_device_init+0x4c/0x78
> [    0.493334]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    0.493809]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.494317]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.494750]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.495174]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.495617]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.496068] BUG: scheduling while atomic: kthreadd/2/0x0000006d
> [    0.496558] INFO: lockdep is turned off.
> [    0.496898] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    0.497525] 
> [    0.497661] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.498386] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.499217]  ffff880013506788 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    0.500161]  ffffffff810b88f7 000000000000006d ffffffff81ff35e0 ffff88001344fef8
> [    0.500815]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    0.501474] Call Trace:
> [    0.501684]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.502112]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.502562]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.503002]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.503411]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    0.503833]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.504287]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.504730]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    0.505198] ------------[ cut here ]------------
> [    0.505586] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.506340] initcall genhd_device_init+0x0/0x78 returned with preemption imbalance 
> [    0.506968] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.507685] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.508541]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.509228]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff8800135065a8
> [    0.509881]  0000000000000000 ffffffff821223ab 0000000000000000 ffff88001344be88
> [    0.510427] Call Trace:
> [    0.510641]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.511073]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.511567]  [<ffffffff821223ab>] ? proc_genhd_init+0x3c/0x3c
> [    0.512043]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.512517]  [<ffffffff821223ab>] ? proc_genhd_init+0x3c/0x3c
> [    0.512994]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.513469]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.513980]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.514412]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.514891]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.515338]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.515770] ---[ end trace 16f8d1a3aab8f9ca ]---
> [    0.516226] ------------[ cut here ]------------
> [    0.516613] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.517370] initcall fbmem_init+0x0/0x98 returned with preemption imbalance 
> [    0.517951] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.518670] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.519500]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.520293]  ffffffff8109b88b ffff8800135176a8 0000000000000000 ffff880013506b90
> [    0.520953]  0000000000000000 ffffffff82125da3 0000000000000000 ffff88001344be88
> [    0.521611] Call Trace:
> [    0.521822]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.522253]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.522746]  [<ffffffff82125da3>] ? video_setup+0x81/0x81
> [    0.523195]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.523667]  [<ffffffff82125da3>] ? video_setup+0x81/0x81
> [    0.524114]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.524589]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.525100]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.525531]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.525959]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.526403]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.526834] ---[ end trace 16f8d1a3aab8f9cb ]---
> [    0.527243] ACPI: Added _OSI(Module Device)
> [    0.527598] ACPI: Added _OSI(Processor Device)
> [    0.527969] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.528361] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.529535] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
> [    0.531509] ACPI: Interpreter enabled
> [    0.531835] ACPI: (supports S0 S5)
> [    0.532119] ACPI: Using IOAPIC for interrupt routing
> [    0.532558] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.537808] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.538330] acpi PNP0A03:00: _OSC: OS supports [Segments]
> [    0.538791] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
> [    0.539535] PCI host bridge to bus 0000:00
> [    0.540004] pci_bus 0000:00: root bus resource [bus 00-ff]
> [    0.540458] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.540969] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
> [    0.541476] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
> [    0.541987] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
> [    0.542495] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
> [    0.543008] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.543572] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebfffff]
> [    0.544185] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
> [    0.545007] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
> [    0.545975] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
> [    0.548950] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
> [    0.550239] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
> [    0.550821] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
> [    0.551351] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
> [    0.551935] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
> [    0.552618] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
> [    0.553381] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
> [    0.553977] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
> [    0.554794] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
> [    0.556242] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
> [    0.557666] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
> [    0.562603] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
> [    0.563331] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
> [    0.564590] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
> [    0.565833] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
> [    0.570004] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
> [    0.570758] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
> [    0.571657] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
> [    0.574769] pci_bus 0000:00: on NUMA node 0
> [    0.575563] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [    0.576267] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [    0.576956] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [    0.577643] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [    0.578248] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
> [    0.579051] ACPI: Enabled 16 GPEs in block 00 to 0F
> [    0.579510] ------------[ cut here ]------------
> [    0.579903] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.580743] initcall acpi_init+0x0/0x254 returned with preemption imbalance 
> [    0.581314] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.582020] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.582832]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.583527]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff880013506ec0
> [    0.584177]  0000000000000000 ffffffff82127583 0000000000000000 ffff88001344be88
> [    0.584822] Call Trace:
> [    0.585032]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.585452]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.585936]  [<ffffffff82127583>] ? acpi_sleep_init+0xe8/0xe8
> [    0.586404]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.586870]  [<ffffffff82127583>] ? acpi_sleep_init+0xe8/0xe8
> [    0.587388]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.587854]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.588355]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.588779]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.589250]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.589688]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.590002] ---[ end trace 16f8d1a3aab8f9cc ]---
> [    0.590406] ------------[ cut here ]------------
> [    0.590789] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.591536] initcall pnp_init+0x0/0x12 returned with preemption imbalance 
> [    0.592096] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.592801] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.593617]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.594265]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff880013558920
> [    0.594959]  0000000000000000 ffffffff82128a03 0000000000000000 ffff88001344be88
> [    0.595601] Call Trace:
> [    0.595808]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.596230]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.596718]  [<ffffffff82128a03>] ? acpi_battery_init_async+0x27/0x27
> [    0.597289]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.597754]  [<ffffffff82128a03>] ? acpi_battery_init_async+0x27/0x27
> [    0.598275]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.598749]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.599256]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.599683]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.600004]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.600443]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.600869] ---[ end trace 16f8d1a3aab8f9cd ]---
> [    0.601273] ------------[ cut here ]------------
> [    0.601657] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.602402] initcall regulator_fixed_voltage_init+0x0/0x14 returned with preemption imbalance 
> [    0.603099] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.603856] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.604673]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.605323]  ffffffff8109b88b ffff8800135591d0 0000000000000000 ffff880013558e40
> [    0.605971]  0000000000000000 ffffffff821294c8 0000000000000000 ffff88001344be88
> [    0.606617] Call Trace:
> [    0.606828]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.607251]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.607744]  [<ffffffff821294c8>] ? regulator_dummy_init+0x87/0x87
> [    0.608244]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.608714]  [<ffffffff821294c8>] ? regulator_dummy_init+0x87/0x87
> [    0.609213]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.609680]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.610003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.610430]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.610851]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.611290]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.611718] ---[ end trace 16f8d1a3aab8f9ce ]---
> [    0.612117] ------------[ cut here ]------------
> [    0.612502] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.613248] initcall pm8607_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.613896] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.614651] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.615462]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.616110]  ffffffff8109b88b ffff880013559540 0000000000000000 ffff8800135591d0
> [    0.616802]  0000000000000000 ffffffff82129504 0000000000000000 ffff88001344be88
> [    0.617444] Call Trace:
> [    0.617653]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.618072]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.618560]  [<ffffffff82129504>] ? regulator_userspace_consumer_driver_init+0x14/0x14
> [    0.619196]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.620004]  [<ffffffff82129504>] ? regulator_userspace_consumer_driver_init+0x14/0x14
> [    0.620644]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.621111]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.621612]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.622038]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.622455]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.622895]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.623317] ---[ end trace 16f8d1a3aab8f9cf ]---
> [    0.623715] ------------[ cut here ]------------
> [    0.624099] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.624839] initcall ad5398_init+0x0/0x14 returned with preemption imbalance 
> [    0.625409] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.626115] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.626981]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.627625]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013559540
> [    0.628277]  0000000000000000 ffffffff82129518 0000000000000000 ffff88001344be88
> [    0.628925] Call Trace:
> [    0.629134]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.629555]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.630004]  [<ffffffff82129518>] ? pm8607_regulator_init+0x14/0x14
> [    0.630516]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.630988]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.631483]  [<ffffffff82129518>] ? pm8607_regulator_init+0x14/0x14
> [    0.631995]  [<ffffffff82129518>] ? pm8607_regulator_init+0x14/0x14
> [    0.632503]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.632974]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.633474]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.633903]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.634323]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.634762]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.635190] ---[ end trace 16f8d1a3aab8f9d0 ]---
> [    0.635589] ------------[ cut here ]------------
> [    0.635978] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.636723] initcall as3711_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.637421] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.638131] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.638951]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.639598]  ffffffff8109b88b ffff880013559c00 0000000000000000 ffff880013559890
> [    0.640416]  0000000000000000 ffffffff82129540 0000000000000000 ffff88001344be88
> [    0.641064] Call Trace:
> [    0.641272]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.641692]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.642182]  [<ffffffff82129540>] ? anatop_regulator_init+0x14/0x14
> [    0.642689]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.643157]  [<ffffffff82129540>] ? anatop_regulator_init+0x14/0x14
> [    0.643664]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.644134]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.644636]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.645065]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.645483]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.645922]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.646348] ---[ end trace 16f8d1a3aab8f9d1 ]---
> [    0.646747] ------------[ cut here ]------------
> [    0.647138] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.647883] initcall da9052_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.648532] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.649291] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.650002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.650649]  ffffffff8109b88b ffff880013559f70 0000000000000000 ffff880013559c00
> [    0.651300]  0000000000000000 ffffffff82129568 0000000000000000 ffff88001344be88
> [    0.652000] Call Trace:
> [    0.652208]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.652626]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.653115]  [<ffffffff82129568>] ? axp20x_regulator_driver_init+0x14/0x14
> [    0.653668]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.654138]  [<ffffffff82129568>] ? axp20x_regulator_driver_init+0x14/0x14
> [    0.654695]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.655164]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.655663]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.656092]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.656509]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.656951]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.657374] ---[ end trace 16f8d1a3aab8f9d2 ]---
> [    0.657780] ------------[ cut here ]------------
> [    0.658171] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.658922] initcall isl6271a_init+0x0/0x14 returned with preemption imbalance 
> [    0.659513] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.660002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.660823]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.661467]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013559f70
> [    0.662114]  0000000000000000 ffffffff821295a4 0000000000000000 ffff88001344be88
> [    0.662761] Call Trace:
> [    0.662967]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.663383]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.663871]  [<ffffffff821295a4>] ? da9211_regulator_driver_init+0x14/0x14
> [    0.664425]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.664938]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.665431]  [<ffffffff821295a4>] ? da9211_regulator_driver_init+0x14/0x14
> [    0.665989]  [<ffffffff821295a4>] ? da9211_regulator_driver_init+0x14/0x14
> [    0.666543]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.667013]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.667512]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.667937]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.668354]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.668794]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.669216] ---[ end trace 16f8d1a3aab8f9d3 ]---
> [    0.669614] ------------[ cut here ]------------
> [    0.670004] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.670748] initcall lp3972_module_init+0x0/0x14 returned with preemption imbalance 
> [    0.671372] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.672077] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.672891]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.673533]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355a368
> [    0.674179]  0000000000000000 ffffffff821295e0 0000000000000000 ffff88001344be88
> [    0.674875] Call Trace:
> [    0.675081]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.675501]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.675986]  [<ffffffff821295e0>] ? lp3971_i2c_driver_init+0x14/0x14
> [    0.676498]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.676967]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.677458]  [<ffffffff821295e0>] ? lp3971_i2c_driver_init+0x14/0x14
> [    0.677973]  [<ffffffff821295e0>] ? lp3971_i2c_driver_init+0x14/0x14
> [    0.678486]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.679003]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.679499]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.680003]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.680423]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.680865]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.681288] ---[ end trace 16f8d1a3aab8f9d4 ]---
> [    0.681687] ------------[ cut here ]------------
> [    0.682066] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.682806] initcall lp8755_init+0x0/0x14 returned with preemption imbalance 
> [    0.683382] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.684088] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.684903]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.685547]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355a6b8
> [    0.686192]  0000000000000000 ffffffff82129608 0000000000000000 ffff88001344be88
> [    0.686836] Call Trace:
> [    0.687046]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.687463]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.687950]  [<ffffffff82129608>] ? lp872x_driver_init+0x14/0x14
> [    0.688434]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.688900]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.689393]  [<ffffffff82129608>] ? lp872x_driver_init+0x14/0x14
> [    0.690004]  [<ffffffff82129608>] ? lp872x_driver_init+0x14/0x14
> [    0.690493]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.690964]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.691467]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.691899]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.692319]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.692759]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.693237] ---[ end trace 16f8d1a3aab8f9d5 ]---
> [    0.693634] ------------[ cut here ]------------
> [    0.694022] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.694767] initcall max1586_pmic_init+0x0/0x14 returned with preemption imbalance 
> [    0.695386] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.696093] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.696954]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.697600]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355aa28
> [    0.698248]  0000000000000000 ffffffff82129630 0000000000000000 ffff88001344be88
> [    0.698896] Call Trace:
> [    0.699103]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.699523]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.700004]  [<ffffffff82129630>] ? ltc3589_driver_init+0x14/0x14
> [    0.700501]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.700972]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.701467]  [<ffffffff82129630>] ? ltc3589_driver_init+0x14/0x14
> [    0.701965]  [<ffffffff82129630>] ? ltc3589_driver_init+0x14/0x14
> [    0.702459]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.702975]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.703473]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.703900]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.704317]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.704754]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.705181] ---[ end trace 16f8d1a3aab8f9d6 ]---
> [    0.705587] ------------[ cut here ]------------
> [    0.705975] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.706719] initcall max8952_pmic_init+0x0/0x14 returned with preemption imbalance 
> [    0.707385] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.708092] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.708961]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.709605]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355ad78
> [    0.710414]  0000000000000000 ffffffff82129644 0000000000000000 ffff88001344be88
> [    0.711061] Call Trace:
> [    0.711269]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.711688]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.712178]  [<ffffffff82129644>] ? max1586_pmic_init+0x14/0x14
> [    0.712655]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.713168]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.713661]  [<ffffffff82129644>] ? max1586_pmic_init+0x14/0x14
> [    0.714143]  [<ffffffff82129644>] ? max1586_pmic_init+0x14/0x14
> [    0.714623]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.715141]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.715643]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.716070]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.716489]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.716928]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.717355] ---[ end trace 16f8d1a3aab8f9d7 ]---
> [    0.717750] ------------[ cut here ]------------
> [    0.718135] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.718875] initcall max8973_init+0x0/0x14 returned with preemption imbalance 
> [    0.719460] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.720002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.720818]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.721463]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355b0a0
> [    0.722157]  0000000000000000 ffffffff82129658 0000000000000000 ffff88001344be88
> [    0.722851] Call Trace:
> [    0.723058]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.723478]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.723970]  [<ffffffff82129658>] ? max8952_pmic_init+0x14/0x14
> [    0.724448]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.724965]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.725458]  [<ffffffff82129658>] ? max8952_pmic_init+0x14/0x14
> [    0.725942]  [<ffffffff82129658>] ? max8952_pmic_init+0x14/0x14
> [    0.726423]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.726892]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.727391]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.727819]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.728236]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.728673]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.729098] ---[ end trace 16f8d1a3aab8f9d8 ]---
> [    0.729495] ------------[ cut here ]------------
> [    0.730004] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.730743] initcall max8998_pmic_init+0x0/0x14 returned with preemption imbalance 
> [    0.731357] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.732061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.732879]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.733520]  ffffffff8109b88b ffff88001355b750 0000000000000000 ffff88001355b3f0
> [    0.734210]  0000000000000000 ffffffff8212966c 0000000000000000 ffff88001344be88
> [    0.734848] Call Trace:
> [    0.735106]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.735528]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.736018]  [<ffffffff8212966c>] ? max8973_init+0x14/0x14
> [    0.736461]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.736927]  [<ffffffff8212966c>] ? max8973_init+0x14/0x14
> [    0.737371]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.737835]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.738383]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.738804]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.739272]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.739708]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.740002] ---[ end trace 16f8d1a3aab8f9d9 ]---
> [    0.740398] ------------[ cut here ]------------
> [    0.740784] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.741520] initcall palmas_init+0x0/0x14 returned with preemption imbalance 
> [    0.742098] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.742805] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.743619]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.744266]  ffffffff8109b88b ffff88001355bab0 0000000000000000 ffff88001355b750
> [    0.744945]  0000000000000000 ffffffff82129680 0000000000000000 ffff88001344be88
> [    0.745586] Call Trace:
> [    0.745796]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.746213]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.746701]  [<ffffffff82129680>] ? max8998_pmic_init+0x14/0x14
> [    0.747183]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.747647]  [<ffffffff82129680>] ? max8998_pmic_init+0x14/0x14
> [    0.748128]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.748594]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.749096]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.749521]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.750004]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.750445]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.750876] ---[ end trace 16f8d1a3aab8f9da ]---
> [    0.751274] ------------[ cut here ]------------
> [    0.751656] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.752404] initcall tps51632_init+0x0/0x14 returned with preemption imbalance 
> [    0.752997] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.753704] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.754522]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.755169]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355bab0
> [    0.755817]  0000000000000000 ffffffff82129694 0000000000000000 ffff88001344be88
> [    0.756464] Call Trace:
> [    0.756672]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.757095]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.757581]  [<ffffffff82129694>] ? palmas_init+0x14/0x14
> [    0.758021]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.758486]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.758983]  [<ffffffff82129694>] ? palmas_init+0x14/0x14
> [    0.759422]  [<ffffffff82129694>] ? palmas_init+0x14/0x14
> [    0.760004]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.760473]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.760976]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.761401]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.761821]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.762310]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.762735] ---[ end trace 16f8d1a3aab8f9db ]---
> [    0.763142] ------------[ cut here ]------------
> [    0.763524] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.764268] initcall rc5t583_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.764921] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.765633] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.766502]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.767200]  ffffffff8109b88b ffff88001355c1d0 0000000000000000 ffff88001355be10
> [    0.767851]  0000000000000000 ffffffff821296a8 0000000000000000 ffff88001344be88
> [    0.768505] Call Trace:
> [    0.768714]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.769137]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.769624]  [<ffffffff821296a8>] ? tps51632_init+0x14/0x14
> [    0.770003]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.770470]  [<ffffffff821296a8>] ? tps51632_init+0x14/0x14
> [    0.770926]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.771391]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.771893]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.772316]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.772733]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.773174]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.773597] ---[ end trace 16f8d1a3aab8f9dc ]---
> [    0.773996] ------------[ cut here ]------------
> [    0.774378] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.775124] initcall tps62360_init+0x0/0x14 returned with preemption imbalance 
> [    0.775711] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.776419] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.777236]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.777931]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355c1d0
> [    0.778575]  0000000000000000 ffffffff821296d0 0000000000000000 ffff88001344be88
> [    0.779271] Call Trace:
> [    0.779479]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.780004]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.780493]  [<ffffffff821296d0>] ? rn5t618_regulator_driver_init+0x14/0x14
> [    0.781059]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.781523]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.782070]  [<ffffffff821296d0>] ? rn5t618_regulator_driver_init+0x14/0x14
> [    0.782629]  [<ffffffff821296d0>] ? rn5t618_regulator_driver_init+0x14/0x14
> [    0.783191]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.783656]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.784158]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.784583]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.785004]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.785442]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.785865] ---[ end trace 16f8d1a3aab8f9dd ]---
> [    0.786308] ------------[ cut here ]------------
> [    0.786691] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.787484] initcall tps_65023_init+0x0/0x14 returned with preemption imbalance 
> [    0.788084] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.788790] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.789607]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.790287]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001355c530
> [    0.790931]  0000000000000000 ffffffff821296e4 0000000000000000 ffff88001344be88
> [    0.791578] Call Trace:
> [    0.791784]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.792204]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.792689]  [<ffffffff821296e4>] ? tps62360_init+0x14/0x14
> [    0.793142]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.793605]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.794146]  [<ffffffff821296e4>] ? tps62360_init+0x14/0x14
> [    0.794597]  [<ffffffff821296e4>] ? tps62360_init+0x14/0x14
> [    0.795050]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.795514]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.796015]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.796438]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.796853]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.797341]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.797763] ---[ end trace 16f8d1a3aab8f9de ]---
> [    0.798209] ------------[ cut here ]------------
> [    0.798591] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.799335] initcall tps65217_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.800003] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.800706] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.801519]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.802165]  ffffffff8109b88b ffff88001355cbf0 0000000000000000 ffff88001355c890
> [    0.802806]  0000000000000000 ffffffff821296f8 0000000000000000 ffff88001344be88
> [    0.803452] Call Trace:
> [    0.803658]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.804078]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.804561]  [<ffffffff821296f8>] ? tps_65023_init+0x14/0x14
> [    0.805021]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.805484]  [<ffffffff821296f8>] ? tps_65023_init+0x14/0x14
> [    0.805940]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.806409]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.806907]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.807332]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.807747]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.808184]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.808603] ---[ end trace 16f8d1a3aab8f9df ]---
> [    0.809028] ------------[ cut here ]------------
> [    0.809409] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.810003] initcall tps80031_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.810659] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.811364] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.812180]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.812857]  ffffffff8109b88b ffff88001355cf50 0000000000000000 ffff88001355cbf0
> [    0.813501]  0000000000000000 ffffffff8212971e 0000000000000000 ffff88001344be88
> [    0.814181] Call Trace:
> [    0.814388]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.814808]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.815294]  [<ffffffff8212971e>] ? pmic_driver_init+0x12/0x12
> [    0.815767]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.816235]  [<ffffffff8212971e>] ? pmic_driver_init+0x12/0x12
> [    0.816708]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.817175]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.817673]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.818100]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.818515]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.818955]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.819377] ---[ end trace 16f8d1a3aab8f9e0 ]---
> [    0.819776] ------------[ cut here ]------------
> [    0.820004] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.820749] initcall twlreg_init+0x0/0x14 returned with preemption imbalance 
> [    0.821321] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.822029] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.822874]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.823515]  ffffffff8109b88b ffff88001355d358 0000000000000000 ffff88001355cf50
> [    0.824159]  0000000000000000 ffffffff82129732 0000000000000000 ffff88001344be88
> [    0.824806] Call Trace:
> [    0.825013]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.825430]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.825968]  [<ffffffff82129732>] ? tps80031_regulator_init+0x14/0x14
> [    0.826487]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.826952]  [<ffffffff82129732>] ? tps80031_regulator_init+0x14/0x14
> [    0.827470]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.827939]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.828436]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.828863]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.829278]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.830003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.830429] ---[ end trace 16f8d1a3aab8f9e1 ]---
> [    0.830875] ------------[ cut here ]------------
> [    0.831263] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.832004] initcall wm831x_dcdc_init+0x0/0x90 returned with preemption imbalance 
> [    0.832611] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.833318] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.834132]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.834775]  ffffffff8109b88b ffff88001355e0a0 0000000000000000 ffff88001355d358
> [    0.835451]  0000000000000000 ffffffff82129746 0000000000000000 ffff88001344be88
> [    0.836103] Call Trace:
> [    0.836310]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.836730]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.837221]  [<ffffffff82129746>] ? twlreg_init+0x14/0x14
> [    0.837659]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.838159]  [<ffffffff82129746>] ? twlreg_init+0x14/0x14
> [    0.838596]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.839093]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.839592]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.840003]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.840422]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.840864]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.841293] ---[ end trace 16f8d1a3aab8f9e2 ]---
> [    0.841694] ------------[ cut here ]------------
> [    0.842081] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.842820] initcall wm831x_isink_init+0x0/0x30 returned with preemption imbalance 
> [    0.843441] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.844152] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.844972]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.845618]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff88001355e0a0
> [    0.846268]  0000000000000000 ffffffff821297d6 0000000000000000 ffff88001344be88
> [    0.846917] Call Trace:
> [    0.847124]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.847543]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.848036]  [<ffffffff821297d6>] ? wm831x_dcdc_init+0x90/0x90
> [    0.848510]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.849011]  [<ffffffff815b2965>] ? __platform_driver_register+0x45/0x50
> [    0.849551]  [<ffffffff821297d6>] ? wm831x_dcdc_init+0x90/0x90
> [    0.850004]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.850472]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.850974]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.851398]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.851815]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.852254]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.852677] ---[ end trace 16f8d1a3aab8f9e3 ]---
> [    0.853139] ------------[ cut here ]------------
> [    0.853522] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.854266] initcall wm831x_ldo_init+0x0/0x6e returned with preemption imbalance 
> [    0.854907] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.855614] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.856433]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.857113]  ffffffff8109b88b ffff88001355ee30 0000000000000000 ffff88001355e400
> [    0.857756]  0000000000000000 ffffffff82129806 0000000000000000 ffff88001344be88
> [    0.858404] Call Trace:
> [    0.858612]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.859037]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.859525]  [<ffffffff82129806>] ? wm831x_isink_init+0x30/0x30
> [    0.860004]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.860472]  [<ffffffff82129806>] ? wm831x_isink_init+0x30/0x30
> [    0.860959]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.861427]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.861930]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.862356]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.862775]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.863245]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.863669] ---[ end trace 16f8d1a3aab8f9e4 ]---
> [    0.864090] ------------[ cut here ]------------
> [    0.864475] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.865221] initcall wm8350_regulator_init+0x0/0x14 returned with preemption imbalance 
> [    0.865871] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.866577] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.867443]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.868093]  ffffffff8109b88b ffff88001355f1d0 0000000000000000 ffff88001355ee30
> [    0.868739]  0000000000000000 ffffffff82129874 0000000000000000 ffff88001344be88
> [    0.869418] Call Trace:
> [    0.869626]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.870004]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.870494]  [<ffffffff82129874>] ? wm831x_ldo_init+0x6e/0x6e
> [    0.870962]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.871430]  [<ffffffff82129874>] ? wm831x_ldo_init+0x6e/0x6e
> [    0.871902]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.872369]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.872873]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.873298]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.873717]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.874162]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.874587] ---[ end trace 16f8d1a3aab8f9e5 ]---
> [    0.874987] ------------[ cut here ]------------
> [    0.875370] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.876117] initcall misc_init+0x0/0xb2 returned with preemption imbalance 
> [    0.876679] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.877431] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.878250]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.878899]  ffffffff8109b88b ffff88001355f430 0000000000000000 ffff88001355f1d0
> [    0.879546]  0000000000000000 ffffffff8212ab49 0000000000000000 ffff88001344be88
> [    0.880288] Call Trace:
> [    0.880497]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.880923]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.881414]  [<ffffffff8212ab49>] ? chr_dev_init+0xc2/0xc2
> [    0.881892]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.882359]  [<ffffffff8212ab49>] ? chr_dev_init+0xc2/0xc2
> [    0.882807]  [<ffffffff8212ab49>] ? chr_dev_init+0xc2/0xc2
> [    0.883287]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.883756]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.884292]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.884719]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.885143]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.885582]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.886038] ---[ end trace 16f8d1a3aab8f9e6 ]---
> [    0.886466] BUG: scheduling while atomic: kdevtmpfs/14/0x0000001d
> [    0.886972] INFO: lockdep is turned off.
> [    0.887297] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    0.887962] 
> [    0.888094] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.888822] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.889673]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    0.890418]  ffffffff810b88f7 000000000000001d 0000000000000000 ffff8800134c3df8
> [    0.891068]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    0.891716] Call Trace:
> [    0.891960]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.892378]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    0.892824]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    0.893260]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    0.893664]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    0.894124]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    0.894589]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    0.894997]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    0.895473]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.895919]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    0.896424] vgaarb: setting as boot device: PCI:0000:00:02.0
> [    0.896880] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.897530] vgaarb: loaded
> [    0.897755] vgaarb: bridge control possible 0000:00:02.0
> [    0.898186] ------------[ cut here ]------------
> [    0.898563] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.899305] initcall vga_arb_device_init+0x0/0x199 returned with preemption imbalance 
> [    0.900003] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.900713] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.901537]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.902237]  ffffffff8109b88b ffff88001344be58 0000000000000000 ffff88001355f4f0
> [    0.902885]  0000000000000000 ffffffff8212c0d9 0000000000000000 ffff88001344be88
> [    0.903588] Call Trace:
> [    0.903797]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.904219]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.904707]  [<ffffffff8212c0d9>] ? tda998x_init+0x32/0x32
> [    0.905156]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.905623]  [<ffffffff8212c242>] ? vga_arb_device_init+0x169/0x199
> [    0.906133]  [<ffffffff8212c0d9>] ? tda998x_init+0x32/0x32
> [    0.906583]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.907101]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.907601]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.908029]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.908446]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.908884]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.909308] ---[ end trace 16f8d1a3aab8f9e7 ]---
> [    0.909731] ------------[ cut here ]------------
> [    0.910005] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.910745] initcall pm860x_i2c_init+0x0/0x30 returned with preemption imbalance 
> [    0.911353] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.912061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.912877]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.913524]  ffffffff8109b88b ffff8800134d2a70 0000000000000000 ffff88001355fcf8
> [    0.914173]  0000000000000000 ffffffff8212edc0 0000000000000000 ffff88001344be88
> [    0.914818] Call Trace:
> [    0.915029]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.915448]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.915937]  [<ffffffff8212edc0>] ? sram_init+0x14/0x14
> [    0.916360]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.916827]  [<ffffffff8212edc0>] ? sram_init+0x14/0x14
> [    0.917258]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.917726]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.918261]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.918688]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.919109]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.919548]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.920002] ---[ end trace 16f8d1a3aab8f9e8 ]---
> [    0.920391] ------------[ cut here ]------------
> [    0.920773] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.921518] initcall pm800_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    0.922121] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.922828] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.923647]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.924297]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff8800135620a0
> [    0.925001]  0000000000000000 ffffffff8212edf0 0000000000000000 ffff88001344be88
> [    0.925648] Call Trace:
> [    0.925859]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.926279]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.926767]  [<ffffffff8212edf0>] ? pm860x_i2c_init+0x30/0x30
> [    0.927282]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.927749]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.928247]  [<ffffffff8212edf0>] ? pm860x_i2c_init+0x30/0x30
> [    0.928714]  [<ffffffff8212edf0>] ? pm860x_i2c_init+0x30/0x30
> [    0.929185]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.929654]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.930004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.930433]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.930855]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.931297]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.931726] ---[ end trace 16f8d1a3aab8f9e9 ]---
> [    0.932114] ------------[ cut here ]------------
> [    0.932496] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.933240] initcall pm805_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    0.933843] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.934552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.935375]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.936028]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff8800135623f0
> [    0.936675]  0000000000000000 ffffffff8212ee04 0000000000000000 ffff88001344be88
> [    0.937375] Call Trace:
> [    0.937582]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.938053]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.938541]  [<ffffffff8212ee04>] ? pm800_i2c_init+0x14/0x14
> [    0.939053]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.939522]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.940003]  [<ffffffff8212ee04>] ? pm800_i2c_init+0x14/0x14
> [    0.940462]  [<ffffffff8212ee04>] ? pm800_i2c_init+0x14/0x14
> [    0.940924]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.941388]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.941940]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.942363]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.942784]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.943221]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.943643] ---[ end trace 16f8d1a3aab8f9ea ]---
> [    0.944032] ------------[ cut here ]------------
> [    0.944415] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.945156] initcall wm831x_i2c_init+0x0/0x30 returned with preemption imbalance 
> [    0.945763] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.946472] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.947293]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.947942]  ffffffff8109b88b ffff8800134d2a70 0000000000000000 ffff880013562740
> [    0.948589]  0000000000000000 ffffffff8212ee70 0000000000000000 ffff88001344be88
> [    0.949268] Call Trace:
> [    0.949476]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.950004]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.950491]  [<ffffffff8212ee70>] ? arizona_i2c_driver_init+0x14/0x14
> [    0.951011]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.951477]  [<ffffffff8212ee70>] ? arizona_i2c_driver_init+0x14/0x14
> [    0.952000]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.952464]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.952965]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.953391]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.953862]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.954298]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.954723] ---[ end trace 16f8d1a3aab8f9eb ]---
> [    0.955110] ------------[ cut here ]------------
> [    0.955491] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.956232] initcall wm8350_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    0.956885] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.957588] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.958452]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.959145]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013562a90
> [    0.959791]  0000000000000000 ffffffff8212eea0 0000000000000000 ffff88001344be88
> [    0.960414] Call Trace:
> [    0.960620]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.961041]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.961531]  [<ffffffff8212eea0>] ? wm831x_i2c_init+0x30/0x30
> [    0.962001]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.962468]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.962967]  [<ffffffff8212eea0>] ? wm831x_i2c_init+0x30/0x30
> [    0.963433]  [<ffffffff8212eea0>] ? wm831x_i2c_init+0x30/0x30
> [    0.963904]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.964371]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.964904]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.965330]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.965747]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.966190]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.966615] ---[ end trace 16f8d1a3aab8f9ec ]---
> [    0.967070] ------------[ cut here ]------------
> [    0.967455] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.968205] initcall tps6507x_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    0.968829] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.969541] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.970002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.970652]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013562de0
> [    0.971296]  0000000000000000 ffffffff8212eec8 0000000000000000 ffff88001344be88
> [    0.971943] Call Trace:
> [    0.972150]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.972571]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.973056]  [<ffffffff8212eec8>] ? wm8994_i2c_driver_init+0x14/0x14
> [    0.973572]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.974036]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.974533]  [<ffffffff8212eec8>] ? wm8994_i2c_driver_init+0x14/0x14
> [    0.975047]  [<ffffffff8212eec8>] ? wm8994_i2c_driver_init+0x14/0x14
> [    0.975564]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.976032]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.976567]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.976992]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.977460]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.977898]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.978323] ---[ end trace 16f8d1a3aab8f9ed ]---
> [    0.978713] ------------[ cut here ]------------
> [    0.979094] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.980003] initcall tps65217_init+0x0/0x14 returned with preemption imbalance 
> [    0.980595] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.981301] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.982116]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.982763]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff8800135631d0
> [    0.983407]  0000000000000000 ffffffff8212eedc 0000000000000000 ffff88001344be88
> [    0.984055] Call Trace:
> [    0.984265]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.984685]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.985170]  [<ffffffff8212eedc>] ? tps6507x_i2c_init+0x14/0x14
> [    0.985649]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.986113]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.986607]  [<ffffffff8212eedc>] ? tps6507x_i2c_init+0x14/0x14
> [    0.987085]  [<ffffffff8212eedc>] ? tps6507x_i2c_init+0x14/0x14
> [    0.987565]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    0.988029]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    0.988525]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.988952]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    0.989369]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    0.990003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    0.990429] ---[ end trace 16f8d1a3aab8f9ee ]---
> [    0.990818] ------------[ cut here ]------------
> [    0.991196] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    0.991940] initcall tps80031_init+0x0/0x14 returned with preemption imbalance 
> [    0.992533] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    0.993247] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    0.994070]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    0.994719]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013563530
> [    0.995417]  0000000000000000 ffffffff8212ef04 0000000000000000 ffff88001344be88
> [    0.996070] Call Trace:
> [    0.996278]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    0.996698]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    0.997239]  [<ffffffff8212ef04>] ? tps65218_driver_init+0x14/0x14
> [    0.997742]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    0.998208]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    0.998702]  [<ffffffff8212ef04>] ? tps65218_driver_init+0x14/0x14
> [    0.999206]  [<ffffffff8212ef04>] ? tps65218_driver_init+0x14/0x14
> [    0.999708]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.000004]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.000504]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.000931]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.001349]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.001822]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.002247] ---[ end trace 16f8d1a3aab8f9ef ]---
> [    1.002636] ------------[ cut here ]------------
> [    1.003017] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.003763] initcall mc13xxx_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.004375] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.005119] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.005967]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.006647]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013563890
> [    1.007290]  0000000000000000 ffffffff8212ef2c 0000000000000000 ffff88001344be88
> [    1.007936] Call Trace:
> [    1.008143]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.008565]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.009052]  [<ffffffff8212ef2c>] ? twl_driver_init+0x14/0x14
> [    1.009517]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.010004]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.010498]  [<ffffffff8212ef2c>] ? twl_driver_init+0x14/0x14
> [    1.010967]  [<ffffffff8212ef2c>] ? twl_driver_init+0x14/0x14
> [    1.011434]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.011904]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.012406]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.012861]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.013278]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.013718]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.014145] ---[ end trace 16f8d1a3aab8f9f0 ]---
> [    1.014532] ------------[ cut here ]------------
> [    1.014913] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.015656] initcall da9052_spi_init+0x0/0x2e returned with preemption imbalance 
> [    1.016256] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.017009] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.017827]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.018470]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff880013563be0
> [    1.019118]  0000000000000000 ffffffff8212ef54 0000000000000000 ffff88001344be88
> [    1.020158] Call Trace:
> [    1.020365]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.020784]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.021273]  [<ffffffff8212ef54>] ? smsc_i2c_driver_init+0x14/0x14
> [    1.021773]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.022244]  [<ffffffff816d29a2>] ? spi_register_driver+0x42/0x50
> [    1.022739]  [<ffffffff8212ef54>] ? smsc_i2c_driver_init+0x14/0x14
> [    1.023242]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.023707]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.024209]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.024633]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.025101]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.025539]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.025965] ---[ end trace 16f8d1a3aab8f9f1 ]---
> [    1.026363] ------------[ cut here ]------------
> [    1.026743] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.027486] initcall da9052_i2c_init+0x0/0x30 returned with preemption imbalance 
> [    1.028093] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.028796] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.029612]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.030288]  ffffffff8109b88b ffff8800134d2a70 0000000000000000 ffff880013563f30
> [    1.030931]  0000000000000000 ffffffff8212ef82 0000000000000000 ffff88001344be88
> [    1.031580] Call Trace:
> [    1.031788]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.032209]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.032694]  [<ffffffff8212ef82>] ? da9052_spi_init+0x2e/0x2e
> [    1.033161]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.033625]  [<ffffffff8212ef82>] ? da9052_spi_init+0x2e/0x2e
> [    1.034094]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.034559]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.035108]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.035530]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.035950]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.036386]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.036807] ---[ end trace 16f8d1a3aab8f9f2 ]---
> [    1.037227] ------------[ cut here ]------------
> [    1.037608] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.038353] initcall max14577_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.038975] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.039681] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.040002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.040652]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013564268
> [    1.041295]  0000000000000000 ffffffff8212efee 0000000000000000 ffff88001344be88
> [    1.041941] Call Trace:
> [    1.042147]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.042570]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.043054]  [<ffffffff8212efee>] ? da9063_i2c_driver_init+0x14/0x14
> [    1.043571]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.044036]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.044531]  [<ffffffff8212efee>] ? da9063_i2c_driver_init+0x14/0x14
> [    1.045041]  [<ffffffff8212efee>] ? da9063_i2c_driver_init+0x14/0x14
> [    1.045556]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.046020]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.046568]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.046990]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.047407]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.047845]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.048269] ---[ end trace 16f8d1a3aab8f9f3 ]---
> [    1.048658] ------------[ cut here ]------------
> [    1.049039] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.050003] initcall max8998_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.050611] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.051319] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.052137]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.052814]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff8800135645c8
> [    1.053460]  0000000000000000 ffffffff8212f002 0000000000000000 ffff88001344be88
> [    1.054140] Call Trace:
> [    1.054346]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.054798]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.055285]  [<ffffffff8212f002>] ? max14577_i2c_init+0x14/0x14
> [    1.055765]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.056229]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.056753]  [<ffffffff8212f002>] ? max14577_i2c_init+0x14/0x14
> [    1.057232]  [<ffffffff8212f002>] ? max14577_i2c_init+0x14/0x14
> [    1.057745]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.058209]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.058742]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.059164]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.059582]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.060003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.060428] ---[ end trace 16f8d1a3aab8f9f4 ]---
> [    1.060820] ------------[ cut here ]------------
> [    1.061200] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.061941] initcall palmas_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.062544] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.063251] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.064071]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.064721]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013564918
> [    1.065365]  0000000000000000 ffffffff8212f044 0000000000000000 ffff88001344be88
> [    1.066012] Call Trace:
> [    1.066219]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.066687]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.067173]  [<ffffffff8212f044>] ? wl1273_core_init+0x2e/0x2e
> [    1.067695]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.068160]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.068702]  [<ffffffff8212f044>] ? wl1273_core_init+0x2e/0x2e
> [    1.069174]  [<ffffffff8212f044>] ? wl1273_core_init+0x2e/0x2e
> [    1.070004]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.070472]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.070975]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.071398]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.071817]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.072301]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.072723] ---[ end trace 16f8d1a3aab8f9f5 ]---
> [    1.073110] ------------[ cut here ]------------
> [    1.073494] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.074235] initcall rc5t583_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.074845] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.075581] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.076428]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.077075]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013564c68
> [    1.077720]  0000000000000000 ffffffff8212f073 0000000000000000 ffff88001344be88
> [    1.078398] Call Trace:
> [    1.078603]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.079024]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.079508]  [<ffffffff8212f073>] ? vprbrd_driver_init+0x1b/0x1b
> [    1.080003]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.080471]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.080966]  [<ffffffff8212f073>] ? vprbrd_driver_init+0x1b/0x1b
> [    1.081452]  [<ffffffff8212f073>] ? vprbrd_driver_init+0x1b/0x1b
> [    1.081941]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.082405]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.082903]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.083329]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.083747]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.084216]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.084641] ---[ end trace 16f8d1a3aab8f9f6 ]---
> [    1.085075] ------------[ cut here ]------------
> [    1.085458] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.086202] initcall lm3533_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.086805] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.087517] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.088340]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.088993]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013564fb8
> [    1.089641]  0000000000000000 ffffffff8212f0af 0000000000000000 ffff88001344be88
> [    1.090288] Call Trace:
> [    1.090495]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.090916]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.091402]  [<ffffffff8212f0af>] ? syscon_init+0x14/0x14
> [    1.091840]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.092308]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.092799]  [<ffffffff8212f0af>] ? syscon_init+0x14/0x14
> [    1.093240]  [<ffffffff8212f0af>] ? syscon_init+0x14/0x14
> [    1.093678]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.094148]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.094645]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.095071]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.095486]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.095952]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.096375] ---[ end trace 16f8d1a3aab8f9f7 ]---
> [    1.096760] ------------[ cut here ]------------
> [    1.097144] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.097918] initcall as3711_i2c_init+0x0/0x14 returned with preemption imbalance 
> [    1.098525] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.099267] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.100002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.100649]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013565358
> [    1.101330]  0000000000000000 ffffffff8212f0c3 0000000000000000 ffff88001344be88
> [    1.102014] Call Trace:
> [    1.102222]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.102641]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.103133]  [<ffffffff8212f0c3>] ? lm3533_i2c_init+0x14/0x14
> [    1.103597]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.104063]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.104554]  [<ffffffff8212f0c3>] ? lm3533_i2c_init+0x14/0x14
> [    1.105022]  [<ffffffff8212f0c3>] ? lm3533_i2c_init+0x14/0x14
> [    1.105487]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.105955]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.106452]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.106909]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.107326]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.107764]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.108225] ---[ end trace 16f8d1a3aab8f9f8 ]---
> [    1.108615] ------------[ cut here ]------------
> [    1.108997] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.109733] initcall dma_buf_init+0x0/0x75 returned with preemption imbalance 
> [    1.110003] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.110710] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.111560]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.112202]  ffffffff8109b88b ffff8800135607c0 0000000000000000 ffff8800135656a8
> [    1.112849]  0000000000000000 ffffffff8212f1ce 0000000000000000 ffff88001344be88
> [    1.113522] Call Trace:
> [    1.113730]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.114146]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.114636]  [<ffffffff8212f1ce>] ? st21nfcb_nci_i2c_driver_init+0x14/0x14
> [    1.115191]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.115660]  [<ffffffff8134a8ea>] ? debugfs_create_file+0x1a/0x20
> [    1.116151]  [<ffffffff8212f1ce>] ? st21nfcb_nci_i2c_driver_init+0x14/0x14
> [    1.116709]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.117173]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.117704]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.118127]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.118547]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.118984]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.119407] ---[ end trace 16f8d1a3aab8f9f9 ]---
> [    1.120178] SCSI subsystem initialized
> [    1.120494] ------------[ cut here ]------------
> [    1.120879] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.121618] initcall init_scsi+0x0/0x9d returned with preemption imbalance 
> [    1.122185] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.122895] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.123718]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.124367]  ffffffff8109b88b ffffffff8212fc08 0000000000000000 ffff8800135656a8
> [    1.125018]  0000000000000000 ffffffff8212fc08 0000000000000000 ffff88001344be88
> [    1.125699] Call Trace:
> [    1.125906]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.126326]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.126815]  [<ffffffff8212fc08>] ? platform_ide_driver_init+0x14/0x14
> [    1.127340]  [<ffffffff8212fc08>] ? platform_ide_driver_init+0x14/0x14
> [    1.127871]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.128338]  [<ffffffff8212fc08>] ? platform_ide_driver_init+0x14/0x14
> [    1.128870]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.129338]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.130003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.130430]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.130849]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.131288]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.131712] ---[ end trace 16f8d1a3aab8f9fa ]---
> [    1.132125] BUG: scheduling while atomic: kthreadd/2/0x00000073
> [    1.132608] INFO: lockdep is turned off.
> [    1.132937] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    1.133554] 
> [    1.133685] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.134405] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.135228]  ffff88001356d4a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    1.135881]  ffffffff810b88f7 0000000000000073 ffffffff81ff35e0 ffff88001344fef8
> [    1.136529]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    1.137209] Call Trace:
> [    1.137418]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.137842]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.138289]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.138721]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.139163]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    1.139581]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.140004]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.140446]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.140916] libata version 3.00 loaded.
> [    1.141235] ------------[ cut here ]------------
> [    1.141615] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.142360] initcall ata_init+0x0/0x42f returned with preemption imbalance 
> [    1.142926] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.143634] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.144485]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.145136]  ffffffff8109b88b 0000000000000282 0000000000000000 ffff88001356d3d8
> [    1.145818]  0000000000000000 ffffffff82130644 0000000000000000 ffff88001344be88
> [    1.146466] Call Trace:
> [    1.146673]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.147095]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.147582]  [<ffffffff82130644>] ? ses_init+0x42/0x42
> [    1.148032]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.148498]  [<ffffffff82130644>] ? ses_init+0x42/0x42
> [    1.148946]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.149411]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.150004]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.150431]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.150851]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.151287]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.151713] ---[ end trace 16f8d1a3aab8f9fb ]---
> [    1.152099] ACPI: bus type USB registered
> [    1.152483] usbcore: registered new interface driver usbfs
> [    1.152958] usbcore: registered new interface driver hub
> [    1.153414] usbcore: registered new device driver usb
> [    1.153833] ------------[ cut here ]------------
> [    1.154215] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.154959] initcall usb_init+0x0/0x169 returned with preemption imbalance 
> [    1.155524] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.156235] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.157052]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.157699]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff88001356d7f8
> [    1.158347]  0000000000000000 ffffffff82131baf 0000000000000000 ffff88001344be88
> [    1.158994] Call Trace:
> [    1.159200]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.159620]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.160004]  [<ffffffff82131baf>] ? i1480_est_init+0x85/0x85
> [    1.160464]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.160932]  [<ffffffff82131baf>] ? i1480_est_init+0x85/0x85
> [    1.161393]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.161863]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.162361]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.162790]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.163207]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.163643]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.164067] ---[ end trace 16f8d1a3aab8f9fc ]---
> [    1.164464] ------------[ cut here ]------------
> [    1.164850] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.165593] initcall usb_phy_generic_init+0x0/0x14 returned with preemption imbalance 
> [    1.166237] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.166945] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.167784]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.168444]  ffffffff8109b88b ffff880013578ed8 0000000000000000 ffff880013578b78
> [    1.169105]  0000000000000000 ffffffff821329e0 0000000000000000 ffff88001344be88
> [    1.170030] Call Trace:
> [    1.170241]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.170667]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.171167]  [<ffffffff821329e0>] ? lvs_driver_init+0x1b/0x1b
> [    1.171642]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.172119]  [<ffffffff821329e0>] ? lvs_driver_init+0x1b/0x1b
> [    1.172595]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.173071]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.173579]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.174045]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.174470]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.174912]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.175347] ---[ end trace 16f8d1a3aab8f9fd ]---
> [    1.175761] ------------[ cut here ]------------
> [    1.176155] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.176911] initcall serio_init+0x0/0x2e returned with preemption imbalance 
> [    1.177494] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.178219] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.179053]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.179714]  ffffffff8109b88b ffffffff8206c200 0000000000000000 ffff880013578ed8
> [    1.180427]  0000000000000000 ffffffff82132a87 0000000000000000 ffff88001344be88
> [    1.181092] Call Trace:
> [    1.181304]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.181733]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.182233]  [<ffffffff82132a87>] ? ci_hdrc_pci_driver_init+0x1b/0x1b
> [    1.182763]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.183241]  [<ffffffff82132a87>] ? ci_hdrc_pci_driver_init+0x1b/0x1b
> [    1.183773]  [<ffffffff82132a87>] ? ci_hdrc_pci_driver_init+0x1b/0x1b
> [    1.184304]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.184778]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.185320]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.185752]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.186181]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.186627]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.187095] ---[ end trace 16f8d1a3aab8f9fe ]---
> [    1.187505] ------------[ cut here ]------------
> [    1.187896] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.188656] initcall gameport_init+0x0/0x2e returned with preemption imbalance 
> [    1.189259] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.190002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.190839]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.191502]  ffffffff8109b88b ffffffff8206cd80 0000000000000000 ffff880013579470
> [    1.192198]  0000000000000000 ffffffff82133a05 0000000000000000 ffff88001344be88
> [    1.192859] Call Trace:
> [    1.193077]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.193505]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.194003]  [<ffffffff82133a05>] ? arc_ps2_driver_init+0x14/0x14
> [    1.194504]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.194979]  [<ffffffff82133a05>] ? arc_ps2_driver_init+0x14/0x14
> [    1.195480]  [<ffffffff82133a05>] ? arc_ps2_driver_init+0x14/0x14
> [    1.195985]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.196459]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.196968]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.197404]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.197828]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.198277]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.198707] ---[ end trace 16f8d1a3aab8f9ff ]---
> [    1.199112] ------------[ cut here ]------------
> [    1.199501] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.200003] initcall input_init+0x0/0x104 returned with preemption imbalance 
> [    1.200597] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.201317] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.202151]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.202842]  ffffffff8109b88b 0000000000d00000 0000000000000000 ffff8800135799a0
> [    1.203502]  0000000000000000 ffffffff82133d60 0000000000000000 ffff88001344be88
> [    1.204164] Call Trace:
> [    1.204376]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.204806]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.205304]  [<ffffffff82133d60>] ? l4_init+0x32d/0x32d
> [    1.205739]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.206212]  [<ffffffff82133d60>] ? l4_init+0x32d/0x32d
> [    1.206644]  [<ffffffff82133d60>] ? l4_init+0x32d/0x32d
> [    1.207078]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.207550]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.208090]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.208522]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.208951]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.209399]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.210002] ---[ end trace 16f8d1a3aab8fa00 ]---
> [    1.210416] ------------[ cut here ]------------
> [    1.210808] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.211573] initcall tca8418_keypad_init+0x0/0x14 returned with preemption imbalance 
> [    1.212220] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.212947] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.213781]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.214445]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff880013579d08
> [    1.215109]  0000000000000000 ffffffff82133f3a 0000000000000000 ffff88001344be88
> [    1.215768] Call Trace:
> [    1.215982]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.216411]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.216913]  [<ffffffff82133f3a>] ? cros_ec_keyb_driver_init+0x14/0x14
> [    1.217451]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.217959]  [<ffffffff817a5771>] ? i2c_register_driver+0x61/0xc0
> [    1.218463]  [<ffffffff82133f3a>] ? cros_ec_keyb_driver_init+0x14/0x14
> [    1.219003]  [<ffffffff82133f3a>] ? cros_ec_keyb_driver_init+0x14/0x14
> [    1.219542]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.220004]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.220514]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.220948]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.221374]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.221821]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.222287] ---[ end trace 16f8d1a3aab8fa01 ]---
> [    1.222694] ------------[ cut here ]------------
> [    1.223093] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.223852] initcall vprbrd_i2c_init+0x0/0x99 returned with preemption imbalance 
> [    1.224463] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.225186] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.226020]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.226676]  ffffffff8109b88b ffff88001357a400 0000000000000000 ffff88001357a0a0
> [    1.227368]  0000000000000000 ffffffff8213495a 0000000000000000 ffff88001344be88
> [    1.228027] Call Trace:
> [    1.228237]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.228663]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.229164]  [<ffffffff8213495a>] ? i2c_parport_init+0x170/0x170
> [    1.229659]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.230004]  [<ffffffff8213495a>] ? i2c_parport_init+0x170/0x170
> [    1.230501]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.230976]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.231484]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.231921]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.232346]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.232795]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.233226] ---[ end trace 16f8d1a3aab8fa02 ]---
> [    1.233623] pps_core: LinuxPPS API ver. 1 registered
> [    1.234038] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
> [    1.234816] ------------[ cut here ]------------
> [    1.235203] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.235960] initcall pps_init+0x0/0xb4 returned with preemption imbalance 
> [    1.236524] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.237247] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.238084]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.238747]  ffffffff8109b88b ffffffff82134a07 0000000000000000 ffff88001357a400
> [    1.239404]  0000000000000000 ffffffff82134a07 0000000000000000 ffff88001344be88
> [    1.240293] Call Trace:
> [    1.240504]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.240936]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.241434]  [<ffffffff82134a07>] ? ec_i2c_tunnel_driver_init+0x14/0x14
> [    1.242018]  [<ffffffff82134a07>] ? ec_i2c_tunnel_driver_init+0x14/0x14
> [    1.242564]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.243043]  [<ffffffff82134a07>] ? ec_i2c_tunnel_driver_init+0x14/0x14
> [    1.243586]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.244062]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.244570]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.245008]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.245432]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.245911]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.246342] ---[ end trace 16f8d1a3aab8fa03 ]---
> [    1.246738] ------------[ cut here ]------------
> [    1.247129] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.247887] initcall power_supply_class_init+0x0/0x40 returned with preemption imbalance 
> [    1.248559] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.249280] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.250002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.250658]  ffffffff8109b88b ffff88001357b318 0000000000000000 ffff88001357a5a0
> [    1.251315]  0000000000000000 ffffffff82134d62 0000000000000000 ffff88001344be88
> [    1.251973] Call Trace:
> [    1.252183]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.252612]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.253115]  [<ffffffff82134d62>] ? w1_f1C_init+0x12/0x12
> [    1.253560]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.254037]  [<ffffffff82134d62>] ? w1_f1C_init+0x12/0x12
> [    1.254482]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.254958]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.255466]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.255901]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.256328]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.256778]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.257208] ---[ end trace 16f8d1a3aab8fa04 ]---
> [    1.257601] ------------[ cut here ]------------
> [    1.257991] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.258751] initcall hwmon_init+0x0/0xe3 returned with preemption imbalance 
> [    1.259329] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.260002] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.260836]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.261493]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff88001357a6e8
> [    1.262153]  0000000000000000 ffffffff82134f3d 0000000000000000 ffff88001344be88
> [    1.262813] Call Trace:
> [    1.263024]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.263452]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.263952]  [<ffffffff82134f3d>] ? smb347_driver_init+0x14/0x14
> [    1.264448]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.264925]  [<ffffffff82135003>] ? hwmon_init+0xc6/0xe3
> [    1.265367]  [<ffffffff82134f3d>] ? smb347_driver_init+0x14/0x14
> [    1.265866]  [<ffffffff82134f3d>] ? smb347_driver_init+0x14/0x14
> [    1.266362]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.266875]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.267385]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.267822]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.268250]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.268700]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.269133] ---[ end trace 16f8d1a3aab8fa05 ]---
> [    1.269529] ------------[ cut here ]------------
> [    1.270004] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.270763] initcall watchdog_init+0x0/0x65 returned with preemption imbalance 
> [    1.271365] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.272087] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.272920]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.273577]  ffffffff8109b88b ffff88001344be38 0000000000000000 ffff88001357a7a0
> [    1.274237]  0000000000000000 ffffffff82137cb9 0000000000000000 ffff88001344be88
> [    1.274896] Call Trace:
> [    1.275106]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.275532]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.276032]  [<ffffffff82137cb9>] ? pkg_temp_thermal_init+0x463/0x463
> [    1.276563]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.277071]  [<ffffffff82137cb9>] ? pkg_temp_thermal_init+0x463/0x463
> [    1.277602]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.278079]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.278588]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.279024]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.279450]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.280003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.280437] ---[ end trace 16f8d1a3aab8fa06 ]---
> [    1.280867] ------------[ cut here ]------------
> [    1.281254] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.282010] initcall leds_init+0x0/0x3c returned with preemption imbalance 
> [    1.282584] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.283311] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.284142]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.284799]  ffffffff8109b88b ffff88001357bc48 0000000000000000 ffff88001357a950
> [    1.285457]  0000000000000000 ffffffff82139db6 0000000000000000 ffff88001344be88
> [    1.286118] Call Trace:
> [    1.286329]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.286756]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.287255]  [<ffffffff82139db6>] ? rtsx_usb_ms_driver_init+0x14/0x14
> [    1.287783]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.288257]  [<ffffffff82139db6>] ? rtsx_usb_ms_driver_init+0x14/0x14
> [    1.288783]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.289261]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.289768]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.290003]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.290430]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.290880]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.291311] ---[ end trace 16f8d1a3aab8fa07 ]---
> [    1.291730] ------------[ cut here ]------------
> [    1.292117] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.292874] initcall iio_init+0x0/0x83 returned with preemption imbalance 
> [    1.293438] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.294157] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.294983]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.295638]  ffffffff8109b88b ffff8800134b97f8 0000000000000000 ffff88001357aa88
> [    1.296286]  0000000000000000 ffffffff8213c314 0000000000000000 ffff88001344be88
> [    1.296938] Call Trace:
> [    1.297147]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.297571]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.298096]  [<ffffffff8213c314>] ? bcma_host_soc_init+0x38/0x38
> [    1.298587]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.299093]  [<ffffffff8134a906>] ? debugfs_create_dir+0x16/0x20
> [    1.299586]  [<ffffffff8213c314>] ? bcma_host_soc_init+0x38/0x38
> [    1.300004]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.300480]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.300992]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.301426]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.301856]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.302303]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.302738] ---[ end trace 16f8d1a3aab8fa08 ]---
> [    1.303143] ------------[ cut here ]------------
> [    1.303531] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.304287] initcall init_soundcore+0x0/0x95 returned with preemption imbalance 
> [    1.304898] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.305617] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.306446]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.307105]  ffffffff8109b88b ffff88001357c7c8 0000000000000000 ffff88001356dfc8
> [    1.307764]  0000000000000000 ffffffff8213d30e 0000000000000000 ffff88001344be88
> [    1.308420] Call Trace:
> [    1.308662]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.309087]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.310004]  [<ffffffff8213d30e>] ? rapl_init+0x72f/0x72f
> [    1.310450]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.310926]  [<ffffffff8213d30e>] ? rapl_init+0x72f/0x72f
> [    1.311375]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.311852]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.312364]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.312796]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.313251]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.313699]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.314131] ---[ end trace 16f8d1a3aab8fa09 ]---
> [    1.314546] Advanced Linux Sound Architecture Driver Initialized.
> [    1.315052] PCI: Using ACPI for IRQ routing
> [    1.315400] PCI: pci_cache_line_size set to 64 bytes
> [    1.315894] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
> [    1.316396] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
> [    1.317119] ------------[ cut here ]------------
> [    1.317511] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.318269] initcall net_dev_init+0x0/0x18a returned with preemption imbalance 
> [    1.318870] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.319589] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.320002]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.320662]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff88001357dac8
> [    1.321317]  0000000000000000 ffffffff821421dc 0000000000000000 ffff88001344be88
> [    1.322004] Call Trace:
> [    1.322215]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.322679]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.323176]  [<ffffffff821421dc>] ? netdev_init+0x6b/0x6b
> [    1.323625]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.324099]  [<ffffffff821421dc>] ? netdev_init+0x6b/0x6b
> [    1.324549]  [<ffffffff821421dc>] ? netdev_init+0x6b/0x6b
> [    1.324994]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.325469]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.326006]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.326437]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.326864]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.327310]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.327744] ---[ end trace 16f8d1a3aab8fa0a ]---
> [    1.328153] Bluetooth: Core ver 2.19
> [    1.328471] NET: Registered protocol family 31
> [    1.328848] Bluetooth: HCI device and connection manager initialized
> [    1.329378] Bluetooth: HCI socket layer initialized
> [    1.330007] Bluetooth: L2CAP socket layer initialized
> [    1.330436] Bluetooth: SCO socket layer initialized
> [    1.330851] ------------[ cut here ]------------
> [    1.331241] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.331998] initcall bt_init+0x0/0xb2 returned with preemption imbalance 
> [    1.332560] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.333281] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.334145]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.334807]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff880013584918
> [    1.335465]  0000000000000000 ffffffff8214b43f 0000000000000000 ffff88001344be88
> [    1.336128] Call Trace:
> [    1.336339]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.336771]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.337267]  [<ffffffff8214b43f>] ? cgw_module_init+0xf8/0xf8
> [    1.337746]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.338220]  [<ffffffff8214b4c5>] ? bt_init+0x86/0xb2
> [    1.338640]  [<ffffffff8214b43f>] ? cgw_module_init+0xf8/0xf8
> [    1.339118]  [<ffffffff8214b43f>] ? cgw_module_init+0xf8/0xf8
> [    1.339595]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.340004]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.340517]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.340954]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.341380]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.341828]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.342261] ---[ end trace 16f8d1a3aab8fa0b ]---
> [    1.342649] nfc: nfc_init: NFC Core ver 0.1
> [    1.343021] NET: Registered protocol family 39
> [    1.343391] ------------[ cut here ]------------
> [    1.343787] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.344544] initcall nfc_init+0x0/0x9c returned with preemption imbalance 
> [    1.345116] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.345874] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.346747]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.347410]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff880013584ca0
> [    1.348075]  0000000000000000 ffffffff8214dddc 0000000000000000 ffff88001344be88
> [    1.348740] Call Trace:
> [    1.348953]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.349381]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.350004]  [<ffffffff8214dddc>] ? batadv_init+0x120/0x120
> [    1.350468]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.350948]  [<ffffffff8214dee7>] ? af_nfc_init+0x10/0x12
> [    1.351398]  [<ffffffff8214dddc>] ? batadv_init+0x120/0x120
> [    1.351894]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.352371]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.352884]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.353319]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.353749]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.354197]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.354630] ---[ end trace 16f8d1a3aab8fa0c ]---
> [    1.355207] ------------[ cut here ]------------
> [    1.355598] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.356361] initcall nmi_warning_debugfs+0x0/0x27 returned with preemption imbalance 
> [    1.357036] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.357790] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.358624]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.359288]  ffffffff8109b88b ffff8800134d2c40 0000000000000000 ffff880013584eb0
> [    1.360162]  0000000000000000 ffffffff82106c18 0000000000000000 ffff88001344be88
> [    1.360823] Call Trace:
> [    1.361039]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.361468]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.361969]  [<ffffffff82106c18>] ? setup_unknown_nmi_panic+0x15/0x15
> [    1.362500]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.362980]  [<ffffffff8134a8ea>] ? debugfs_create_file+0x1a/0x20
> [    1.363485]  [<ffffffff82106c18>] ? setup_unknown_nmi_panic+0x15/0x15
> [    1.364022]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.364498]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.365011]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.365447]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.365876]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.366326]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.366759] ---[ end trace 16f8d1a3aab8fa0d ]---
> [    1.367170] Switched to clocksource kvm-clock
> [    1.367647] FS-Cache: Loaded
> [    1.367947] ------------[ cut here ]------------
> [    1.368336] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.369090] initcall pnp_system_init+0x0/0x12 returned with preemption imbalance 
> [    1.369701] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.370000] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.370000]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.370000]  ffffffff8109b88b ffff880013589358 0000000000000000 ffff880013588f40
> [    1.370000]  0000000000000000 ffffffff82128afd 0000000000000000 ffff88001344be88
> [    1.370000] Call Trace:
> [    1.370000]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.370000]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.370000]  [<ffffffff82128afd>] ? pnp_setup_reserve_mem+0x3a/0x3a
> [    1.370000]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.370000]  [<ffffffff82128afd>] ? pnp_setup_reserve_mem+0x3a/0x3a
> [    1.370000]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.370000]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.370000]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.370218]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.370645]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.371094]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.371524] ---[ end trace 16f8d1a3aab8fa0e ]---
> [    1.371912] pnp: PnP ACPI init
> [    1.372216] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
> [    1.372921] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    1.373512] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
> [    1.374216] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
> [    1.374791] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
> [    1.375497] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
> [    1.376111] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
> [    1.376783] pnp 00:03: [dma 2]
> [    1.377078] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
> [    1.377674] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
> [    1.378372] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
> [    1.378986] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
> [    1.379687] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> [    1.380560] pnp: PnP ACPI: found 6 devices
> [    1.380910] ------------[ cut here ]------------
> [    1.381295] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.382051] initcall pnpacpi_init+0x0/0x74 returned with preemption imbalance 
> [    1.382644] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.383365] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.384197]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.384857]  ffffffff8109b88b ffff880013589358 0000000000000000 ffff880013589358
> [    1.385511]  0000000000000000 ffffffff82128b93 0000000000000000 ffff88001344be88
> [    1.386169] Call Trace:
> [    1.386380]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.386840]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.387335]  [<ffffffff82128b93>] ? ispnpidacpi+0x84/0x84
> [    1.387786]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.388260]  [<ffffffff82128b93>] ? ispnpidacpi+0x84/0x84
> [    1.388703]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.389179]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.389688]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.390134]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.390560]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.391008]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.391436] ---[ end trace 16f8d1a3aab8fa0f ]---
> [    1.391852] BUG: scheduling while atomic: swapper/1/0x00000003
> [    1.392332] INFO: lockdep is turned off.
> [    1.392657] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.393328] 
> [    1.393461] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.394180] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.395042]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.395693]  ffffffff810b88f7 0000000000000003 7fffffffffffffff ffff88001344bb48
> [    1.396348]  ffffffff81b5e5a5 0000000000000001 ffff880013444000 ffff88001344bfd8
> [    1.397005] Call Trace:
> [    1.397216]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.397640]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.398100]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.398539]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.398953]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.399434]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.399943]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.400448]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.400907]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.401415]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.401857]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.402391]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.403000]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.403445]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.403945]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.404384]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.404859]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.405366]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.405799]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.406223]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.406667]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.407114] BUG: scheduling while atomic: kdevtmpfs/14/0x00000023
> [    1.407621] INFO: lockdep is turned off.
> [    1.407953] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.408594] 
> [    1.408727] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.409472] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.410313]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.410972]  ffffffff810b88f7 0000000000000023 0000000000000000 ffff8800134c3df8
> [    1.411623]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.412277] Call Trace:
> [    1.412487]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.412915]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.413368]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.413811]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.414222]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.414654]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.415157]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.415568]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.416052]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.416498]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.417018] BUG: scheduling while atomic: swapper/1/0x00000005
> [    1.417503] INFO: lockdep is turned off.
> [    1.417834] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.418503] 
> [    1.418635] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.419354] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.420191]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.420847]  ffffffff810b88f7 0000000000000005 7fffffffffffffff ffff88001344bb48
> [    1.421497]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.422150] Call Trace:
> [    1.422360]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.422787]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.423236]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.423672]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.424083]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.424560]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.425067]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.425560]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.426012]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.426517]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.426955]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.427488]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.428071]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.428517]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.428985]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.429422]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.429896]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.430416]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.430850]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.431272]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.431715]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.432154] BUG: scheduling while atomic: kdevtmpfs/14/0x00000029
> [    1.432657] INFO: lockdep is turned off.
> [    1.432986] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.433625] 
> [    1.433790] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.434527] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.435390]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.436082]  ffffffff810b88f7 0000000000000029 0000000000000000 ffff8800134c3df8
> [    1.436738]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.437397] Call Trace:
> [    1.437607]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.438036]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.438489]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.438929]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.439340]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.439776]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.440261]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.440673]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.441155]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.441600]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.442111] BUG: scheduling while atomic: swapper/1/0x00000007
> [    1.442592] INFO: lockdep is turned off.
> [    1.442921] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.443585] 
> [    1.443717] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.444435] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.445293]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.445948]  ffffffff810b88f7 0000000000000007 7fffffffffffffff ffff88001344bb48
> [    1.446600]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.447257] Call Trace:
> [    1.447467]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.447894]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.448347]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.448787]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.449197]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.449676]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.450198]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.450695]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.451152]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.451661]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.452101]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.452638]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.453219]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.453665]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.454136]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.454575]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.455054]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.455565]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.456001]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.456427]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.456907]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.457350] BUG: scheduling while atomic: kdevtmpfs/14/0x0000002f
> [    1.457859] INFO: lockdep is turned off.
> [    1.458188] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.458833] 
> [    1.458967] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.459709] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.460552]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.461211]  ffffffff810b88f7 000000000000002f 0000000000000000 ffff8800134c3df8
> [    1.461868]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.462523] Call Trace:
> [    1.462733]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.463163]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.463616]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.464058]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.464468]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.464902]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.465375]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.465821]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.466303]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.466785]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.467296] BUG: scheduling while atomic: swapper/1/0x00000009
> [    1.467782] INFO: lockdep is turned off.
> [    1.468107] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.468775] 
> [    1.468907] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.469624] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.470463]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.471123]  ffffffff810b88f7 0000000000000009 7fffffffffffffff ffff88001344bb48
> [    1.471780]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.472436] Call Trace:
> [    1.472648]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.473078]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.473532]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.473974]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.474387]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.474871]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.475379]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.475877]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.476330]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.476873]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.477313]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.477853]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.478433]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.478883]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.479351]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.479794]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.480278]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.480789]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.481222]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.481648]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.482098]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.482538] BUG: scheduling while atomic: kdevtmpfs/14/0x00000035
> [    1.483044] INFO: lockdep is turned off.
> [    1.483369] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.484010] 
> [    1.484142] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.484883] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.485714]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.486373]  ffffffff810b88f7 0000000000000035 0000000000000000 ffff8800134c3df8
> [    1.487066]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.487724] Call Trace:
> [    1.487938]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.488367]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.488823]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.489261]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.489671]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.490125]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.490600]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.491014]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.491496]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.491945]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.492454] BUG: scheduling while atomic: swapper/1/0x0000000b
> [    1.492940] INFO: lockdep is turned off.
> [    1.493264] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.493933] 
> [    1.494065] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.494784] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.495609]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.496264]  ffffffff810b88f7 000000000000000b 7fffffffffffffff ffff88001344bb48
> [    1.496918]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.497571] Call Trace:
> [    1.497783]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.498205]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.498655]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.499094]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.499503]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.499984]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.500503]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.501001]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.501451]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.501960]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.502397]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.502934]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.503508]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.503953]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.504417]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.504857]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.505328]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.505837]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.506266]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.506690]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.507138]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.507578] BUG: scheduling while atomic: kdevtmpfs/14/0x0000003b
> [    1.508084] INFO: lockdep is turned off.
> [    1.508408] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.509049] 
> [    1.509181] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.509922] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.510796]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.511453]  ffffffff810b88f7 000000000000003b 0000000000000000 ffff8800134c3df8
> [    1.512109]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.512765] Call Trace:
> [    1.512975]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.513399]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.513856]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.514295]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.514705]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.515139]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.515611]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.516052]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.516533]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.516981]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.517496] BUG: scheduling while atomic: swapper/1/0x0000000d
> [    1.517980] INFO: lockdep is turned off.
> [    1.518309] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.518980] 
> [    1.519113] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.519836] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.520674]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.521333]  ffffffff810b88f7 000000000000000d 7fffffffffffffff ffff88001344bb48
> [    1.521992]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.522648] Call Trace:
> [    1.522863]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.523290]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.523743]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.524185]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.524597]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.525082]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.525591]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.526089]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.526543]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.527056]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.527496]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.528038]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.528618]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.529070]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.529538]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.529981]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.530466]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.530981]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.531415]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.531844]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.532291]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.532732] BUG: scheduling while atomic: kdevtmpfs/14/0x00000041
> [    1.533241] INFO: lockdep is turned off.
> [    1.533567] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.534209] 
> [    1.534341] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.535083] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.535917]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.536575]  ffffffff810b88f7 0000000000000041 0000000000000000 ffff8800134c3df8
> [    1.537232]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.537887] Call Trace:
> [    1.538097]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.538521]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.538978]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.539418]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.539832]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.540275]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.540755]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.541168]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.541651]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.542102]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.542612] BUG: scheduling while atomic: swapper/1/0x0000000f
> [    1.543100] INFO: lockdep is turned off.
> [    1.543428] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.544099] 
> [    1.544231] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.544956] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.545816]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.546471]  ffffffff810b88f7 000000000000000f 7fffffffffffffff ffff88001344bb48
> [    1.547159]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.547849] Call Trace:
> [    1.548060]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.548490]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.548949]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.549391]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.549806]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.550300]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.550814]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.551311]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.551769]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.552279]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.552720]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.553261]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.553842]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.554287]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.554758]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.555199]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.555675]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.556186]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.556619]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.557047]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.557495]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.557939] BUG: scheduling while atomic: kdevtmpfs/14/0x00000047
> [    1.558446] INFO: lockdep is turned off.
> [    1.558777] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.559418] 
> [    1.559552] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.560306] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.561140]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.561800]  ffffffff810b88f7 0000000000000047 0000000000000000 ffff8800134c3df8
> [    1.562454]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.563144] Call Trace:
> [    1.563355]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.563784]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.564238]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.564676]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.565091]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.565525]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.566002]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.566413]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.566898]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.567343]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.567857] BUG: scheduling while atomic: swapper/1/0x00000011
> [    1.568339] INFO: lockdep is turned off.
> [    1.568663] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.569334] 
> [    1.569467] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.570197] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.571032]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.571688]  ffffffff810b88f7 0000000000000011 7fffffffffffffff ffff88001344bb48
> [    1.572348]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.573008] Call Trace:
> [    1.573219]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.573643]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.574099]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.574538]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.574952]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.575435]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.575947]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.576444]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.576901]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.577410]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.577856]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.578396]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.578975]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.579419]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.579918]  [<ffffffff8212ab34>] chr_dev_init+0xad/0xc2
> [    1.580368]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.580845]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.581355]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.581790]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.582214]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.582658]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.583101] BUG: scheduling while atomic: kdevtmpfs/14/0x0000004d
> [    1.583604] INFO: lockdep is turned off.
> [    1.583935] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.584578] 
> [    1.584711] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.585457] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.586287]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.586975]  ffffffff810b88f7 000000000000004d 0000000000000000 ffff8800134c3df8
> [    1.587630]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.588287] Call Trace:
> [    1.588497]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.588925]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.589377]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.589818]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.590240]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.590674]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.591151]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.591563]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.592045]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.592491]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.593011] BUG: scheduling while atomic: swapper/1/0x00000013
> [    1.593494] INFO: lockdep is turned off.
> [    1.593822] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.594487] 
> [    1.594619] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.595339] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.596165]  ffff88001344bca0 ffff88001344bab8 ffffffff81b5b203 ffff88001344bad8
> [    1.596851]  ffffffff810b88f7 0000000000000013 7fffffffffffffff ffff88001344bb38
> [    1.597505]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.598162] Call Trace:
> [    1.598372]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.598799]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.599252]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.599690]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.600115]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.600598]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.601111]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.601608]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.602066]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.602574]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.603045]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.603580]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.604161]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.604608]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.605217]  [<ffffffff8212996e>] tty_init+0x77/0x12e
> [    1.605635]  [<ffffffff8212ab44>] chr_dev_init+0xbd/0xc2
> [    1.606077]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.606551]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.607063]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.607496]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.607924]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.608372]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.608815] BUG: scheduling while atomic: kdevtmpfs/14/0x00000053
> [    1.609321] INFO: lockdep is turned off.
> [    1.609649] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.610304] 
> [    1.610438] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.611183] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.612042]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.612696]  ffffffff810b88f7 0000000000000053 0000000000000000 ffff8800134c3df8
> [    1.613382]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.614040] Call Trace:
> [    1.614250]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.614676]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.615160]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.615598]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.616010]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.616441]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.616918]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.617328]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.617811]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.618257]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.618771] BUG: scheduling while atomic: swapper/1/0x00000015
> [    1.619254] INFO: lockdep is turned off.
> [    1.619581] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.620264] 
> [    1.620398] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.621119] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.621957]  ffff88001344bca0 ffff88001344bab8 ffffffff81b5b203 ffff88001344bad8
> [    1.622614]  ffffffff810b88f7 0000000000000015 7fffffffffffffff ffff88001344bb38
> [    1.623306]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    1.623969] Call Trace:
> [    1.624180]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.624604]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.625061]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.625499]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.625913]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.626394]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.626936]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.627431]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.627887]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.628397]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.628870]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.629408]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.629989]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.630445]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.631028]  [<ffffffff821299e1>] tty_init+0xea/0x12e
> [    1.631449]  [<ffffffff8212ab44>] chr_dev_init+0xbd/0xc2
> [    1.631892]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.632366]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.632909]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.633342]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.633770]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.634217]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.634656] BUG: scheduling while atomic: kdevtmpfs/14/0x00000059
> [    1.635163] INFO: lockdep is turned off.
> [    1.635489] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.636130] 
> [    1.636263] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.637006] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.637841]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.638502]  ffffffff810b88f7 0000000000000059 0000000000000000 ffff8800134c3df8
> [    1.639165]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.639827] Call Trace:
> [    1.640049]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.640477]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.640934]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.641373]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.641786]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.642220]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.642696]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.643142]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.643623]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.644101]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.644599] ------------[ cut here ]------------
> [    1.644992] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.645748] initcall chr_dev_init+0x0/0xc2 returned with preemption imbalance 
> [    1.646342] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.647061] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.647893]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.648548]  ffffffff8109b88b ffffffff82030e78 0000000000000000 ffff88001358e420
> [    1.649207]  0000000000000000 ffffffff8212aa87 0000000000000000 ffff88001344be88
> [    1.649865] Call Trace:
> [    1.650088]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.650516]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.651015]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.651596]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.652071]  [<ffffffff82129a0c>] ? tty_init+0x115/0x12e
> [    1.652509]  [<ffffffff8212aa87>] ? setup_early_serial8250_console+0x5e/0x5e
> [    1.653089]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.653562]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.654072]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.654504]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.654931]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.655376]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.655810] ---[ end trace 16f8d1a3aab8fa10 ]---
> [    1.656209] ------------[ cut here ]------------
> [    1.656598] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.657358] initcall firmware_class_init+0x0/0x5e returned with preemption imbalance 
> [    1.658004] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.658722] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.659555]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.660226]  ffffffff8109b88b ffffffff8203bc18 0000000000000000 ffff880013595bc0
> [    1.660889]  0000000000000000 ffffffff8212cc00 0000000000000000 ffff88001344be88
> [    1.661546] Call Trace:
> [    1.661760]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.662188]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.662684]  [<ffffffff8212cc00>] ? devtmpfs_init+0xd0/0xd0
> [    1.663150]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.663627]  [<ffffffff8212cc00>] ? devtmpfs_init+0xd0/0xd0
> [    1.664091]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.664564]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.665076]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.665509]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.665938]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.666385]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.666820] ---[ end trace 16f8d1a3aab8fa11 ]---
> [    1.667228] ------------[ cut here ]------------
> [    1.667616] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.668375] initcall thermal_init+0x0/0xce returned with preemption imbalance 
> [    1.668978] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.669690] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.670530]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.671192]  ffffffff8109b88b ffff88001344be68 0000000000000000 ffff880013595d20
> [    1.671853]  0000000000000000 ffffffff82137788 0000000000000000 ffff88001344be88
> [    1.672511] Call Trace:
> [    1.672723]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.673205]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.673702]  [<ffffffff82137788>] ? ucd9200_driver_init+0x14/0x14
> [    1.674257]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.674732]  [<ffffffff82137788>] ? ucd9200_driver_init+0x14/0x14
> [    1.675237]  [<ffffffff82137788>] ? ucd9200_driver_init+0x14/0x14
> [    1.675740]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.676267]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.676829]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.677259]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.677684]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.678182]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.678613] ---[ end trace 16f8d1a3aab8fa12 ]---
> [    1.683606] ------------[ cut here ]------------
> [    1.684001] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.684759] initcall ssb_modinit+0x0/0x68 returned with preemption imbalance 
> [    1.685345] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.686067] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.686900]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.687557]  ffffffff8109b88b ffff88001344be68 0000000000000000 ffff880013595df0
> [    1.688213]  0000000000000000 ffffffff8213bf14 0000000000000000 ffff88001344be88
> [    1.688870] Call Trace:
> [    1.689079]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.689507]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.690044]  [<ffffffff8213bf14>] ? i2c_hid_driver_init+0x14/0x14
> [    1.690546]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.691023]  [<ffffffff81b60f59>] ? mutex_unlock+0x9/0x10
> [    1.691469]  [<ffffffff8213bf14>] ? i2c_hid_driver_init+0x14/0x14
> [    1.691973]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.692444]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.692955]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.693386]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.693812]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.694257]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.694688] ---[ end trace 16f8d1a3aab8fa13 ]---
> [    1.695123] ------------[ cut here ]------------
> [    1.695512] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.696268] initcall bcma_modinit+0x0/0x35 returned with preemption imbalance 
> [    1.696865] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.697583] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.698415]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.699075]  ffffffff8109b88b ffffffff8213bf7c 0000000000000000 ffff880013598320
> [    1.699730]  0000000000000000 ffffffff8213bf7c 0000000000000000 ffff88001344be88
> [    1.700401] Call Trace:
> [    1.700611]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.701040]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.701537]  [<ffffffff8213bf7c>] ? ssb_modinit+0x68/0x68
> [    1.701989]  [<ffffffff8213bf7c>] ? ssb_modinit+0x68/0x68
> [    1.702436]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.702913]  [<ffffffff8213c28d>] ? bcma_host_pci_init+0x19/0x1b
> [    1.703411]  [<ffffffff8213bf7c>] ? ssb_modinit+0x68/0x68
> [    1.703860]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.704335]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.704893]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.705323]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.705746]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.706241]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.706671] ---[ end trace 16f8d1a3aab8fa14 ]---
> [    1.707091] ------------[ cut here ]------------
> [    1.707482] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.708241] initcall mcb_init+0x0/0x20 returned with preemption imbalance 
> [    1.708813] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.709535] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.710382]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.711044]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff880013598cd0
> [    1.711700]  0000000000000000 ffffffff8188d010 0000000000000000 ffff88001344be88
> [    1.712358] Call Trace:
> [    1.712568]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.713000]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.713496]  [<ffffffff8188d010>] ? __mcb_bus_add_devices+0x50/0x50
> [    1.714015]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.714489]  [<ffffffff8188d010>] ? __mcb_bus_add_devices+0x50/0x50
> [    1.715008]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.715482]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.715994]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.716425]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.716854]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.717302]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.717733] ---[ end trace 16f8d1a3aab8fa15 ]---
> [    1.718125] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    1.718584] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
> [    1.719047] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
> [    1.719508] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
> [    1.720032] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
> [    1.720497] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
> [    1.721070] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
> [    1.721613] NET: Registered protocol family 2
> [    1.722112] BUG: scheduling while atomic: kthreadd/2/0x00000079
> [    1.722604] INFO: lockdep is turned off.
> [    1.722933] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    1.723557] 
> [    1.723690] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.724418] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.725256]  ffff88001359d3b8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    1.725917]  ffffffff810b88f7 0000000000000079 ffffffff81ff35e0 ffff88001344fef8
> [    1.726576]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    1.727234] Call Trace:
> [    1.727444]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.727872]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.728324]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.728766]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.729176]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    1.729599]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.730065]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.730511]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.731034] TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> [    1.731630] TCP bind hash table entries: 4096 (order: 6, 262144 bytes)
> [    1.732240] TCP: Hash tables configured (established 4096 bind 4096)
> [    1.732792] TCP: reno registered
> [    1.733074] UDP hash table entries: 256 (order: 3, 40960 bytes)
> [    1.733577] UDP-Lite hash table entries: 256 (order: 3, 40960 bytes)
> [    1.734192] ------------[ cut here ]------------
> [    1.734606] BUG: workqueue leaked lock or atomic: kworker/0:0/0x00000200/4
> [    1.734606]      last function: check_lifetime
> [    1.735537] INFO: lockdep is turned off.
> [    1.735869] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.736612] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.737489] Workqueue: events_power_efficient check_lifetime
> [    1.738001]  ffffffff820de0c0 ffff88001346bd68 ffffffff81b5b203 ffff88001346bde8
> [    1.738654]  ffffffff810af83e ffffffff810af63e ffffffff81ff2090 ffffffff820de0c8
> [    1.739311]  0000000081ff1d40 ffffffff820de0c0 0000000000000000 0000000000000000
> [    1.740029] Call Trace:
> [    1.740240]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.740667]  [<ffffffff810af83e>] process_one_work+0x33e/0x460
> [    1.741151]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    1.741648]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    1.742103]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.742597]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.743061]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.743541]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.743988]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.744467] BUG: scheduling while atomic: kworker/0:0/4/0x00000201
> [    1.744977] INFO: lockdep is turned off.
> [    1.745302] Preemption disabled at:[<ffffffff819a7185>] check_lifetime+0x45/0x2c0
> [    1.745978] 
> [    1.746111] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.746859] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.747694]  ffffffff81ff1d40 ffff88001346bd58 ffffffff81b5b203 ffff88001346bd78
> [    1.748402]  ffffffff810b88f7 0000000000000201 ffff88001343ada0 ffff88001346bdd8
> [    1.749092]  ffffffff81b5e5a5 ffff88001346bdc8 ffff880013464000 ffff88001346bfd8
> [    1.749754] Call Trace:
> [    1.749964]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.750397]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.750855]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.751292]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.751702]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    1.752156]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.752649]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.753064]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.753544]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.753993]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.754479] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.755239] initcall inet_init+0x0/0x285 returned with preemption imbalance 
> [    1.755852] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.756570] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.757402]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.758062]  ffffffff8109b88b ffffffff820fbb40 0000000000000000 ffff880013599438
> [    1.758720]  0000000000000000 ffffffff82145a46 0000000000000000 ffff88001344be88
> [    1.759382] Call Trace:
> [    1.759593]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.760033]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.760530]  [<ffffffff82145a46>] ? ipv4_mib_init_net+0x16b/0x16b
> [    1.761036]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.761511]  [<ffffffff82145a46>] ? ipv4_mib_init_net+0x16b/0x16b
> [    1.762018]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.762492]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.763003]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.763433]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.763890]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.764339]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.764775] ---[ end trace 16f8d1a3aab8fa16 ]---
> [    1.765165] NET: Registered protocol family 1
> [    1.765558] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> [    1.766063] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [    1.766549] pci 0000:00:01.0: Activating ISA DMA hang workarounds
> [    1.767082] pci 0000:00:02.0: Video device with shadowed ROM
> [    1.767567] PCI: CLS 0 bytes, default 64
> [    1.767972] Unpacking initramfs...
> [    1.818150] debug: unmapping init [mem 0xffff880013cce000-0xffff880013fd7fff]
> [    1.819028] ------------[ cut here ]------------
> [    1.819430] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.820303] BUG: workqueue leaked lock or atomic: kworker/0:1/0x000001e1/22
> [    1.820303]      last function: delayed_fput
> [    1.821380] INFO: lockdep is turned off.
> [    1.821869] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.822805] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.823636] Workqueue: events delayed_fput
> [    1.823991]  ffffffff82000ac0 ffff8800135afd68 ffffffff81b5b203 ffff8800135afde8
> [    1.824618]  ffffffff810af83e ffffffff810af63e ffffffff81ff1d58 ffffffff82000ac8
> [    1.825249]  0000000081ff1d40 ffffffff82000ac0 0000000000000000 0000000000000000
> [    1.825882] Call Trace:
> [    1.826085]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.826496]  [<ffffffff810af83e>] process_one_work+0x33e/0x460
> [    1.826974]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    1.827449]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    1.827979]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.828453]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.828893]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.829358]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.829791]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.830272] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    1.830767] INFO: lockdep is turned off.
> [    1.831128] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.831742] 
> [    1.831916] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.832642] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.833493]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    1.834125]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    1.834756]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    1.835398] Call Trace:
> [    1.835600]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.836023]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.836455]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.836876]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.837268]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    1.837699]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.838188]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.838581]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.839155]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.839580]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.840106] initcall populate_rootfs+0x0/0xac returned with preemption imbalance 
> [    1.840693] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.841385] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.842181]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.842818]  ffffffff8109b88b ffff88001344be28 0000000000000000 ffff88001362c330
> [    1.843451]  0000000000000000 ffffffff821065e3 0000000000000000 ffff88001344be88
> [    1.844197] Call Trace:
> [    1.844399]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.844808]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.845282]  [<ffffffff821065e3>] ? unpack_to_rootfs+0x247/0x247
> [    1.845755]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.846221]  [<ffffffff821148b4>] ? free_initrd_mem+0x2f/0x34
> [    1.846674]  [<ffffffff821065e3>] ? unpack_to_rootfs+0x247/0x247
> [    1.847264]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.847716]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.848252]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.848663]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.849074]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.849500]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.849915] ---[ end trace 16f8d1a3aab8fa17 ]---
> [    1.850590] Machine check injector initialized
> [    1.851045] BUG: scheduling while atomic: swapper/1/0x00000003
> [    1.851509] INFO: lockdep is turned off.
> [    1.851941] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.852583] 
> [    1.852711] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.853401] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.854201]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.854841]  ffffffff810b88f7 0000000000000003 7fffffffffffffff ffff88001344bb48
> [    1.855477]  ffffffff81b5e5a5 ffff8800120581ea ffff880013444000 ffff88001344bfd8
> [    1.856108] Call Trace:
> [    1.856310]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.856718]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.857154]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.857575]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.857974]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.858434]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.858925]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.859399]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.859837]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.860338]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.860764]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.861280]  [<ffffffff8210f21c>] ? set_kbd_reboot+0x37/0x37
> [    1.861728]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.862159]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.862606]  [<ffffffff8210f2af>] msr_init+0x93/0xdc
> [    1.863004]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.863458]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.863948]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.864363]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.864772]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.865201]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.865662] BUG: scheduling while atomic: kdevtmpfs/14/0x00000071
> [    1.866150] INFO: lockdep is turned off.
> [    1.866464] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.867080] 
> [    1.867207] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.867919] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.868713]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.869345]  ffffffff810b88f7 0000000000000071 0000000000000000 ffff8800134c3df8
> [    1.869975]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.870616] Call Trace:
> [    1.870821]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.871227]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.871658]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.872081]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.872473]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.872889]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.873341]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.873734]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.874195]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.874627]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.875117] ------------[ cut here ]------------
> [    1.875504] BUG: workqueue leaked lock or atomic: kworker/0:1/0x000001e1/22
> [    1.875504]      last function: tsc_refine_calibration_work
> [    1.876478] INFO: lockdep is turned off.
> [    1.876796] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.877520] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.878322] Workqueue: events tsc_refine_calibration_work
> [    1.878768]  ffffffff81fceac0 ffff8800135afd68 ffffffff81b5b203 ffff8800135afde8
> [    1.879391]  ffffffff810af83e ffffffff810af63e ffffffff81ff1d58 ffffffff81fceac8
> [    1.880027]  0000000081ff1d40 ffffffff81fceac0 0000000000000000 0000000000000000
> [    1.880653] Call Trace:
> [    1.880859]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.881267]  [<ffffffff810af83e>] process_one_work+0x33e/0x460
> [    1.881727]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    1.882323]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    1.882762]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.883285]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.883681]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.884195]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.884624]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.885134] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    1.885624] INFO: lockdep is turned off.
> [    1.885951] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.886562] 
> [    1.886688] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.887545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.888375]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    1.889033]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    1.889687]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    1.890353] Call Trace:
> [    1.890563]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.890989]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.891439]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.891879]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.892287]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    1.892738]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.893277]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.893686]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.894198]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.894640]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.895152] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.895904] initcall msr_init+0x0/0xdc returned with preemption imbalance 
> [    1.896466] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.897181] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.898033]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.898687]  ffffffff8109b88b ffff88001344be68 0000000000000000 ffff8800126b3ad8
> [    1.899341]  0000000000000000 ffffffff8210f21c 0000000000000000 ffff88001344be88
> [    1.900042] Call Trace:
> [    1.900250]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.900672]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.901168]  [<ffffffff8210f21c>] ? set_kbd_reboot+0x37/0x37
> [    1.901631]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.902157]  [<ffffffff8210f21c>] ? set_kbd_reboot+0x37/0x37
> [    1.902623]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.903097]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.903601]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.904033]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.904461]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.904908]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.905335] ---[ end trace 16f8d1a3aab8fa18 ]---
> [    1.905769] BUG: scheduling while atomic: swapper/1/0x00000003
> [    1.906253] INFO: lockdep is turned off.
> [    1.906579] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    1.907247] 
> [    1.907379] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.908101] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.908963]  ffff88001344bcb0 ffff88001344bac8 ffffffff81b5b203 ffff88001344bae8
> [    1.909618]  ffffffff810b88f7 0000000000000003 7fffffffffffffff ffff88001344bb48
> [    1.910316]  ffffffff81b5e5a5 ffff880012058a1c ffff880013444000 ffff88001344bfd8
> [    1.910974] Call Trace:
> [    1.911183]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.911606]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.912060]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.912497]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.912909]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    1.913389]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    1.913898]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    1.914389]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    1.914844]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    1.915350]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    1.915790]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    1.916322]  [<ffffffff8210f2f8>] ? msr_init+0xdc/0xdc
> [    1.916745]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    1.917194]  [<ffffffff815b1765>] ? __class_create+0x45/0x80
> [    1.917658]  [<ffffffff8210f38b>] cpuid_init+0x93/0xdc
> [    1.918085]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    1.918557]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.919067]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.919497]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.919924]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.920377]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.920826] BUG: scheduling while atomic: kdevtmpfs/14/0x00000077
> [    1.921330] INFO: lockdep is turned off.
> [    1.921657] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.922301] 
> [    1.922434] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.923178] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.924006]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    1.924660]  ffffffff810b88f7 0000000000000077 0000000000000000 ffff8800134c3df8
> [    1.925315]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    1.925970] Call Trace:
> [    1.926179]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.926602]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.927055]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.927492]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.927905]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    1.928338]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    1.928813]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.929223]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.929701]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.930159]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.930655] ------------[ cut here ]------------
> [    1.931255] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.932018] initcall cpuid_init+0x0/0xdc returned with preemption imbalance 
> [    1.932597] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.933316] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.934147]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.934810]  ffffffff8109b88b ffff88001344be68 0000000000000000 ffff880012058338
> [    1.935470]  0000000000000000 ffffffff8210f2f8 0000000000000000 ffff88001344be88
> [    1.936133] Call Trace:
> [    1.936343]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.936773]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.937268]  [<ffffffff8210f2f8>] ? msr_init+0xdc/0xdc
> [    1.937694]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.938170]  [<ffffffff8210f2f8>] ? msr_init+0xdc/0xdc
> [    1.938596]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.939070]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.939577]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.940025]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.940451]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.940900]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.941410] ---[ end trace 16f8d1a3aab8fa19 ]---
> [    1.941843] ------------[ cut here ]------------
> [    1.942234] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.942991] initcall add_pcspkr+0x0/0x40 returned with preemption imbalance 
> [    1.943569] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.944290] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.945122]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.945782]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff880012058b68
> [    1.946440]  0000000000000000 ffffffff82113eed 0000000000000000 ffff88001344be88
> [    1.947103] Call Trace:
> [    1.947315]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.947744]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.948245]  [<ffffffff82113eed>] ? pvclock_init_vsyscall+0x5b/0x5b
> [    1.948763]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.949238]  [<ffffffff82113eed>] ? pvclock_init_vsyscall+0x5b/0x5b
> [    1.949759]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.950245]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.950757]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.951187]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.951612]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.952062]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.952494] ---[ end trace 16f8d1a3aab8fa1a ]---
> [    1.952884] Scanning for low memory corruption every 60 seconds
> [    1.953412] BUG: workqueue leaked lock or atomic: kworker/0:1/0x000001e1/22
> [    1.953412]      last function: check_corruption
> [    1.954357] INFO: lockdep is turned off.
> [    1.954686] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.955442] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.956273] Workqueue: events check_corruption
> [    1.956654]  ffffffff81fe8480 ffff8800135afd68 ffffffff81b5b203 ffff8800135afde8
> [    1.957312]  ffffffff810af83e ffffffff810af63e ffffffff81ff1d58 ffffffff81fe8488
> [    1.957970]  0000000081ff1d40 ffffffff81fe8480 0000000000000000 0000000000000000
> [    1.958627] Call Trace:
> [    1.958841]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.959264]  [<ffffffff810af83e>] process_one_work+0x33e/0x460
> [    1.959742]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    1.960250]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    1.960704]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.961200]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.961609]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.962091]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.962534]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.963015] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    1.963525] INFO: lockdep is turned off.
> [    1.963853] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    1.964491] 
> [    1.964626] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.965378] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.966215]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    1.966878]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    1.967536]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    1.968197] Call Trace:
> [    1.968407]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.968836]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.969288]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.969726]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.970150]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    1.970604]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    1.971099]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    1.971510]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.971994]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.972437]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    1.972974] ------------[ cut here ]------------
> [    1.973362] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    1.974113] initcall sysfb_init+0x0/0x6a returned with preemption imbalance 
> [    1.974691] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.975411] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.976239]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    1.976893]  ffffffff8109b88b ffff88001344be18 0000000000000000 ffff88001362cd40
> [    1.977546]  0000000000000000 ffffffff821141c7 0000000000000000 ffff88001344be88
> [    1.978203] Call Trace:
> [    1.978414]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.978842]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    1.979335]  [<ffffffff821141c7>] ? pci_swiotlb_late_init+0x29/0x29
> [    1.979852]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    1.980337]  [<ffffffff821141c7>] ? pci_swiotlb_late_init+0x29/0x29
> [    1.980857]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    1.981332]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    1.981844]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.982276]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    1.982702]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.983150]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    1.983581] ---[ end trace 16f8d1a3aab8fa1b ]---
> [    1.984004] BUG: scheduling while atomic: kthreadd/2/0x0000007f
> [    1.984494] INFO: lockdep is turned off.
> [    1.984825] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    1.985450] 
> [    1.985583] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.986314] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.987144]  ffff88001205a558 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    1.987802]  ffffffff810b88f7 000000000000007f ffffffff81ff35e0 ffff88001344fef8
> [    1.988459]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    1.989119] Call Trace:
> [    1.989329]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    1.989756]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    1.990220]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    1.990660]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    1.991074]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    1.991498]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.991953]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    1.992396]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    1.992865] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
> [    1.993608] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
> [    1.994370] cryptomgr_test (23) used greatest stack depth: 14968 bytes left
> [    1.994965] BUG: scheduling while atomic: kthreadd/2/0x00000085
> [    1.995455] INFO: lockdep is turned off.
> [    1.995788] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    1.996417] 
> [    1.996549] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    1.997275] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    1.998107]  ffff88001205a558 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    1.998766]  ffffffff810b88f7 0000000000000085 ffffffff81ff35e0 ffff88001344fef8
> [    1.999423]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.000097] Call Trace:
> [    2.000308]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.000734]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.001192]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.001631]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.002045]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.002470]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.002925]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.003372]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.003843] twofish-x86_64-3way: performance on this CPU would be suboptimal: disabling twofish-x86_64-3way.
> [    2.004670] BUG: scheduling while atomic: kthreadd/2/0x0000008b
> [    2.005167] INFO: lockdep is turned off.
> [    2.005493] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.006120] 
> [    2.006251] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.006978] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.007808]  ffff88001205a828 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.008462]  ffffffff810b88f7 000000000000008b ffffffff81ff35e0 ffff88001344fef8
> [    2.009119]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.009776] Call Trace:
> [    2.009987]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.010425]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.010885]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.011326]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.011737]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.012166]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.012621]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.013070]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.013532] BUG: scheduling while atomic: rcuop/0/10/0x00000003
> [    2.014023] INFO: lockdep is turned off.
> [    2.014349] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.014949] 
> [    2.015082] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.015810] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.016634]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.017288]  ffffffff810b88f7 0000000000000003 ffffffff81ff6e40 ffff88001349fd98
> [    2.017943]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.018594] Call Trace:
> [    2.018807]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.019231]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.019682]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.020135]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.020547]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.021031]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.021526]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.022008]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.022484]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.023071]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.023480]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.023961]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.024406]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.024927] BUG: scheduling while atomic: kthreadd/2/0x00000091
> [    2.025421] INFO: lockdep is turned off.
> [    2.025749] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.026380] 
> [    2.026513] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.027241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.028074]  ffff88001205a828 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.028730]  ffffffff810b88f7 0000000000000091 ffffffff81ff35e0 ffff88001344fef8
> [    2.029389]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.030063] Call Trace:
> [    2.030273]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.030700]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.031158]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.031598]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.032013]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.032440]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.032898]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.033345]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.033838] BUG: scheduling while atomic: kthreadd/2/0x00000097
> [    2.034331] INFO: lockdep is turned off.
> [    2.034658] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.035291] 
> [    2.035424] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.036151] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.036984]  ffff88001205a828 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.037637]  ffffffff810b88f7 0000000000000097 ffffffff81ff35e0 ffff88001344fef8
> [    2.038294]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.038950] Call Trace:
> [    2.039161]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.039584]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.040051]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.040489]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.040901]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.041323]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.041777]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.042221]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.042681] BUG: scheduling while atomic: rcuop/0/10/0x00000005
> [    2.043175] INFO: lockdep is turned off.
> [    2.043504] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.044105] 
> [    2.044238] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.044963] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.045788]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.046438]  ffffffff810b88f7 0000000000000005 ffffffff81ff6e40 ffff88001349fd98
> [    2.047092]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.047742] Call Trace:
> [    2.047955]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.048382]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.048837]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.049275]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.049684]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.050179]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.050673]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.051155]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.051633]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.052216]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.052626]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.053106]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.053549]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.054078] BUG: scheduling while atomic: kthreadd/2/0x0000009d
> [    2.054570] INFO: lockdep is turned off.
> [    2.054905] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.055530] 
> [    2.055662] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.056392] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.057226]  ffff88001205a4c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.057888]  ffffffff810b88f7 000000000000009d ffffffff81ff35e0 ffff88001344fef8
> [    2.058547]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.059209] Call Trace:
> [    2.059421]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.059853]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.060320]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.060764]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.061178]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.061606]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.062062]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.062510]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.062984] BUG: scheduling while atomic: rcuop/0/10/0x00000009
> [    2.063474] INFO: lockdep is turned off.
> [    2.063803] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.064398] 
> [    2.064531] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.065260] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.066091]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.066747]  ffffffff810b88f7 0000000000000009 ffffffff81ff6e40 ffff88001349fd98
> [    2.067404]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.068061] Call Trace:
> [    2.068271]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.068696]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.069149]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.069587]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.070005]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.070496]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.070996]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.071478]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.071963]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.072549]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.072963]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.073443]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.073893]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.074431] BUG: scheduling while atomic: kthreadd/2/0x000000a3
> [    2.074928] INFO: lockdep is turned off.
> [    2.075255] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.075886] 
> [    2.076019] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.076742] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.077577]  ffff88001205a558 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.078235]  ffffffff810b88f7 00000000000000a3 ffffffff81ff35e0 ffff88001344fef8
> [    2.078894]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.079551] Call Trace:
> [    2.079765]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.080205]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.080660]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.081105]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.081517]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.081947]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.082401]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.082852]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.083342] BUG: scheduling while atomic: rcuop/0/10/0x0000000b
> [    2.083840] INFO: lockdep is turned off.
> [    2.084170] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.084776] 
> [    2.084910] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.085636] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.086470]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.087131]  ffffffff810b88f7 000000000000000b ffffffff81ff6e40 ffff88001349fd98
> [    2.087791]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.088450] Call Trace:
> [    2.088661]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.089089]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.089540]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.089981]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.090408]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.090894]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.091391]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.091876]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.092358]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.092946]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.093356]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.093838]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.094282]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.094791] BUG: scheduling while atomic: kthreadd/2/0x000000a9
> [    2.095280] INFO: lockdep is turned off.
> [    2.095605] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.096234] 
> [    2.096366] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.097096] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.097927]  ffff88001205a558 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.098578]  ffffffff810b88f7 00000000000000a9 ffffffff81ff35e0 ffff88001344fef8
> [    2.099233]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.099889] Call Trace:
> [    2.100111]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.100538]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.100993]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.101431]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.101845]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.102270]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.102722]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.103170]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.103650] BUG: scheduling while atomic: kthreadd/2/0x000000af
> [    2.104144] INFO: lockdep is turned off.
> [    2.104472] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.105100] 
> [    2.105232] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.105959] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.106788]  ffff88001205a668 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.107439]  ffffffff810b88f7 00000000000000af ffffffff81ff35e0 ffff88001344fef8
> [    2.108094]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.108746] Call Trace:
> [    2.108959]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.109382]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.109837]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.110285]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.110694]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.111120]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.111571]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.112018]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.112508] BUG: scheduling while atomic: rcuop/0/10/0x0000000f
> [    2.113004] INFO: lockdep is turned off.
> [    2.113330] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.113931] 
> [    2.114062] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.114784] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.115609]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.116261]  ffffffff810b88f7 000000000000000f ffffffff81ff6e40 ffff88001349fd98
> [    2.116916]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.117567] Call Trace:
> [    2.117780]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.118201]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.118649]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.119088]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.119495]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.119974]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.120478]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.120959]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.121437]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.122021]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.122437]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.122940]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.123398]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.123944] BUG: scheduling while atomic: kthreadd/2/0x000000b5
> [    2.124440] INFO: lockdep is turned off.
> [    2.124785] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.125429] 
> [    2.125566] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.126307] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.127141]  ffff88001205a758 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.127818]  ffffffff810b88f7 00000000000000b5 ffffffff81ff35e0 ffff88001344fef8
> [    2.128482]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.129140] Call Trace:
> [    2.129353]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.129781]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.130260]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.130700]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.131115]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.131544]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.132001]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.132448]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.132927] BUG: scheduling while atomic: rcuop/0/10/0x00000013
> [    2.133416] INFO: lockdep is turned off.
> [    2.133743] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.134345] 
> [    2.134478] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.135209] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.136039]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.136692]  ffffffff810b88f7 0000000000000013 ffffffff81ff6e40 ffff88001349fd98
> [    2.137350]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.138009] Call Trace:
> [    2.138220]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.138646]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.139103]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.139541]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.139957]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.140448]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.140947]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.141430]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.141915]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.142498]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.142912]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.143391]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.143844]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.144389] BUG: scheduling while atomic: kthreadd/2/0x000000bb
> [    2.144884] INFO: lockdep is turned off.
> [    2.145212] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.145851] 
> [    2.145984] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.146707] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.147538]  ffff88001205a4c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.148200]  ffffffff810b88f7 00000000000000bb ffffffff81ff35e0 ffff88001344fef8
> [    2.148863]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.149522] Call Trace:
> [    2.149734]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.150177]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.150635]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.151081]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.151494]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.151924]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.152378]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.152830]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.153323] BUG: scheduling while atomic: kthreadd/2/0x000000c1
> [    2.153821] INFO: lockdep is turned off.
> [    2.154148] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.154776] 
> [    2.154908] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.155630] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.156465]  ffff88001205a4c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.157128]  ffffffff810b88f7 00000000000000c1 ffffffff81ff35e0 ffff88001344fef8
> [    2.157788]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.158444] Call Trace:
> [    2.158655]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.159083]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.159533]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.159973]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.160394]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.160824]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.161277]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.161722]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.162220] BUG: scheduling while atomic: rcuop/0/10/0x00000013
> [    2.162714] INFO: lockdep is turned off.
> [    2.163046] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.163643] 
> [    2.163781] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.164510] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.165347]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.166009]  ffffffff810b88f7 0000000000000013 ffffffff81ff6e40 ffff88001349fd98
> [    2.166666]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.167326] Call Trace:
> [    2.167537]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.167968]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.168422]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.168864]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.169275]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.169758]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.170267]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.170756]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.171239]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.171828]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.172240]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.172723]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.173172]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.173669] BUG: scheduling while atomic: kthreadd/2/0x000000c7
> [    2.174162] INFO: lockdep is turned off.
> [    2.174491] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.175123] 
> [    2.175255] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.175986] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.176815]  ffff88001205a4c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.177468]  ffffffff810b88f7 00000000000000c7 ffffffff81ff35e0 ffff88001344fef8
> [    2.178126]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.178783] Call Trace:
> [    2.178994]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.179419]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.179874]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.180324]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.180736]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.181162]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.181615]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.182062]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.182526] BUG: scheduling while atomic: rcuop/0/10/0x00000019
> [    2.183017] INFO: lockdep is turned off.
> [    2.183344] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.183945] 
> [    2.184078] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.184806] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.185633]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.186291]  ffffffff810b88f7 0000000000000019 ffffffff81ff6e40 ffff88001349fd98
> [    2.186947]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.187601] Call Trace:
> [    2.187815]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.188240]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.188692]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.189131]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.189540]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.190031]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.190523]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.191007]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.191489]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.192075]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.192486]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.192969]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.193414]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.193912] PCLMULQDQ-NI instructions are not detected.
> [    2.194347] sha512_ssse3: Neither AVX nor SSSE3 is available/usable.
> [    2.194873] AVX instructions are not detected.
> [    2.195244] AVX instructions are not detected.
> [    2.195614] AVX2 instructions are not detected.
> [    2.196026] spin_lock-torture:--- Start of test [debug]: nwriters_stress=2 nreaders_stress=0 stat_interval=60 verbose=1 shuffle_interval=3 stutter=5 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
> [    2.197445] spin_lock-torture: Creating torture_shuffle task
> [    2.197941] BUG: scheduling while atomic: kthreadd/2/0x000000cd
> [    2.198433] INFO: lockdep is turned off.
> [    2.198764] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.199391] 
> [    2.199523] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.200264] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.201093]  ffff88001205a5b8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.201748]  ffffffff810b88f7 00000000000000cd ffffffff81ff35e0 ffff88001344fef8
> [    2.202405]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.203062] Call Trace:
> [    2.203273]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.203698]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.204153]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.204592]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.205005]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.205432]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.205897]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.206348]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.206814] spin_lock-torture: Creating torture_stutter task
> [    2.207317] BUG: scheduling while atomic: kthreadd/2/0x000000d3
> [    2.207814] INFO: lockdep is turned off.
> [    2.208143] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.208777] 
> [    2.208910] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.209638] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.210478]  ffff88001205a5d8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.211141]  ffffffff810b88f7 00000000000000d3 ffffffff81ff35e0 ffff88001344fef8
> [    2.211799]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.212459] Call Trace:
> [    2.212671]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.213102]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.213556]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.213998]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.214412]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.214840]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.215294]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.215741]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.216201] spin_lock-torture: torture_shuffle task started
> [    2.216669] spin_lock-torture: Creating lock_torture_writer task
> [    2.217170] spin_lock-torture: torture_stutter task started
> [    2.217631] BUG: scheduling while atomic: rcuop/0/10/0x00000019
> [    2.218125] INFO: lockdep is turned off.
> [    2.218452] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.219055] 
> [    2.219188] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.219917] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.220761]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.221421]  ffffffff810b88f7 0000000000000019 ffffffff81ff6e40 ffff88001349fd98
> [    2.222080]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.222737] Call Trace:
> [    2.222950]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.223375]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.223832]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.224271]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.224682]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.225167]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.225663]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.226149]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.226630]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.227216]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.227626]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.228109]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.228554]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.229053] BUG: scheduling while atomic: kthreadd/2/0x000000d9
> [    2.229542] INFO: lockdep is turned off.
> [    2.229873] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.230514] 
> [    2.230646] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.231378] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.232214]  ffff88001205d130 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.232876]  ffffffff810b88f7 00000000000000d9 ffffffff81ff35e0 ffff88001344fef8
> [    2.233533]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.234193] Call Trace:
> [    2.234404]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.234833]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.235288]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.235731]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.236146]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.236570]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.237024]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.237469]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.237931] spin_lock-torture: Creating lock_torture_writer task
> [    2.238445] BUG: scheduling while atomic: kthreadd/2/0x000000df
> [    2.238941] INFO: lockdep is turned off.
> [    2.239267] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.239897] 
> [    2.240041] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.240766] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.241595]  ffff88001205d298 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.242254]  ffffffff810b88f7 00000000000000df ffffffff81ff35e0 ffff88001344fef8
> [    2.242915]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.243573] Call Trace:
> [    2.243787]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.244210]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.244660]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.245100]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.245509]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.245934]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.246386]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.246834]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.247289] spin_lock-torture: lock_torture_writer task started
> [    2.247787] spin_lock-torture: Creating lock_torture_stats task
> [    2.248291] BUG: scheduling while atomic: kthreadd/2/0x000000e5
> [    2.248786] INFO: lockdep is turned off.
> [    2.249111] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.249734] 
> [    2.249869] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.250602] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.251430]  ffff88001205d298 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.252087]  ffffffff810b88f7 00000000000000e5 ffffffff81ff35e0 ffff88001344fef8
> [    2.252741]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.253399] Call Trace:
> [    2.253609]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.254040]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.254494]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.254934]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.255345]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.255774]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.256227]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.256673]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.257133] spin_lock-torture: lock_torture_writer task started
> [    2.257629] BUG: scheduling while atomic: rcuop/0/10/0x0000001b
> [    2.258117] INFO: lockdep is turned off.
> [    2.258443] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.259045] 
> [    2.259178] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.259907] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.260757]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.261417]  ffffffff810b88f7 000000000000001b ffffffff81ff6e40 ffff88001349fd98
> [    2.262077]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.262731] Call Trace:
> [    2.262947]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.263372]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.263828]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.264268]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.264680]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    2.265166]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.265664]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.266155]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.266637]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.267226]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.267638]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.268123]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.268570]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.270027] torture_init_begin: refusing rcu init: spin_lock running
> [    2.270628] ------------[ cut here ]------------
> [    2.271052] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.271811] initcall init_clocksource_sysfs+0x0/0x69 returned with preemption imbalance 
> [    2.272474] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.273198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.274031]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.274688]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff88001205d3a8
> [    2.275346]  0000000000000000 ffffffff82118dea 0000000000000000 ffff88001344be88
> [    2.276007] Call Trace:
> [    2.276217]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.276646]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.277146]  [<ffffffff82118dea>] ? clocksource_done_booting+0x44/0x44
> [    2.277683]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.278162]  [<ffffffff815ac941>] ? device_create_file+0x41/0xb0
> [    2.278658]  [<ffffffff82118dea>] ? clocksource_done_booting+0x44/0x44
> [    2.279198]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.279673]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.280196]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.280628]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.281059]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.281506]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.281945] spin_lock-torture: lock_torture_stats task started
> [    2.282430] BUG: scheduling while atomic: rcuop/0/10/0x0000001b
> [    2.282919] INFO: lockdep is turned off.
> [    2.283246] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    2.283848] 
> [    2.283980] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.284704] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.285536]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    2.286195]  ffffffff810b88f7 000000000000001b ffffffff81ff6d88 ffff88001349fd98
> [    2.286853]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    2.287507] Call Trace:
> [    2.287717]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.288143]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.288593]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.289034]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.289443]  [<ffffffff810dda2d>] rcu_nocb_kthread+0xfd/0x5e0
> [    2.289918]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    2.290423]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    2.290908]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    2.291388]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    2.291975]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.292385]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.292867]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.293312]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.293795] ---[ end trace 16f8d1a3aab8fa1c ]---
> [    2.294256] ------------[ cut here ]------------
> [    2.294644] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.295401] initcall alarmtimer_init+0x0/0x141 returned with preemption imbalance 
> [    2.296024] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.296744] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.297576]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.298233]  ffffffff8109b88b 0000000000000000 0000000000000000 ffff88001205a820
> [    2.298887]  0000000000000000 ffffffff82118f30 0000000000000000 ffff88001344be88
> [    2.299540] Call Trace:
> [    2.299752]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.300189]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.300684]  [<ffffffff82118f30>] ? init_timer_list_procfs+0x2c/0x2c
> [    2.301213]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.301688]  [<ffffffff810ed8b0>] ? alarm_timer_del+0x10/0x10
> [    2.302164]  [<ffffffff810ed8a0>] ? alarm_timer_create+0x10/0x10
> [    2.302660]  [<ffffffff82118f30>] ? init_timer_list_procfs+0x2c/0x2c
> [    2.303187]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.303663]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.304176]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.304610]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.305041]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.305488]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.305921] ---[ end trace 16f8d1a3aab8fa1d ]---
> [    2.306386] ------------[ cut here ]------------
> [    2.306783] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.307536] initcall clockevents_init_sysfs+0x0/0x8e returned with preemption imbalance 
> [    2.308201] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.308923] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.309758]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.310432]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff88001205c7f0
> [    2.311097]  0000000000000000 ffffffff82119071 0000000000000000 ffff88001344be88
> [    2.311766] Call Trace:
> [    2.311975]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.312401]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.312900]  [<ffffffff82119071>] ? alarmtimer_init+0x141/0x141
> [    2.313388]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.313865]  [<ffffffff815ac941>] ? device_create_file+0x41/0xb0
> [    2.314360]  [<ffffffff82119071>] ? alarmtimer_init+0x141/0x141
> [    2.314850]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.315324]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.315835]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.316266]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.316691]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.317139]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.317568] ---[ end trace 16f8d1a3aab8fa1e ]---
> [    2.318002] ------------[ cut here ]------------
> [    2.318391] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.319144] initcall udelay_test_init+0x0/0x45 returned with preemption imbalance 
> [    2.319767] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.320487] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.321314]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.321971]  ffffffff8109b88b ffff88001344be38 0000000000000000 ffff88001364c9c8
> [    2.322625]  0000000000000000 ffffffff821191fa 0000000000000000 ffff88001344be88
> [    2.323284] Call Trace:
> [    2.323495]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.323925]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.324419]  [<ffffffff821191fa>] ? tk_debug_sleep_time_init+0x3c/0x3c
> [    2.324957]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.325429]  [<ffffffff821191fa>] ? tk_debug_sleep_time_init+0x3c/0x3c
> [    2.325968]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.326440]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.326954]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.327386]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.327815]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.328262]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.328692] ---[ end trace 16f8d1a3aab8fa1f ]---
> [    2.329083] futex hash table entries: 256 (order: 2, 20480 bytes)
> [    2.329604] audit: initializing netlink subsys (disabled)
> [    2.330093] audit: type=2000 audit(1417552450.306:1): initialized
> [    2.330602] ------------[ cut here ]------------
> [    2.330992] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.331748] initcall audit_init+0x0/0x117 returned with preemption imbalance 
> [    2.332337] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.333058] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.333889]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.334547]  ffffffff8109b88b 0000000000000000 0000000000000000 ffff88001364cb50
> [    2.335206]  0000000000000000 ffffffff821194f2 0000000000000000 ffff88001344be88
> [    2.335864] Call Trace:
> [    2.336074]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.336499]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.336997]  [<ffffffff821194f2>] ? audit_net_init+0xf1/0xf1
> [    2.337462]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.337938]  [<ffffffff821194f2>] ? audit_net_init+0xf1/0xf1
> [    2.338403]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.338879]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.339385]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.339819]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.340257]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.340704]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.341145] ---[ end trace 16f8d1a3aab8fa20 ]---
> [    2.341551] ------------[ cut here ]------------
> [    2.341943] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.342699] initcall gcov_fs_init+0x0/0xdb returned with preemption imbalance 
> [    2.343295] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.344014] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.344844]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.345500]  ffffffff8109b88b 0000000000000246 0000000000000000 ffff88001364cca0
> [    2.346157]  0000000000000000 ffffffff821196d8 0000000000000000 ffff88001344be88
> [    2.346814] Call Trace:
> [    2.347023]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.347450]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.347947]  [<ffffffff821196d8>] ? gcov_persist_setup+0x54/0x54
> [    2.348442]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.348918]  [<ffffffff810fb3de>] ? gcov_enable_events+0x4e/0x60
> [    2.349413]  [<ffffffff821196d8>] ? gcov_persist_setup+0x54/0x54
> [    2.349911]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.350396]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.350910]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.351343]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.351771]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.352216]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.352647] ---[ end trace 16f8d1a3aab8fa21 ]---
> [    2.353124] ------------[ cut here ]------------
> [    2.353516] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.354275] initcall perf_event_sysfs_init+0x0/0x95 returned with preemption imbalance 
> [    2.354937] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.355657] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.356491]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.357153]  ffffffff8109b88b ffff88001344be48 0000000000000000 ffff88001364ce58
> [    2.357809]  0000000000000000 ffffffff821198cb 0000000000000000 ffff88001344be88
> [    2.358461] Call Trace:
> [    2.358671]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.359100]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.359595]  [<ffffffff821198cb>] ? perf_workqueue_init+0x66/0x66
> [    2.360108]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.360584]  [<ffffffff81b60f59>] ? mutex_unlock+0x9/0x10
> [    2.361033]  [<ffffffff821198cb>] ? perf_workqueue_init+0x66/0x66
> [    2.361535]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.362012]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.362520]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.362955]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.363381]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.363830]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.364261] ---[ end trace 16f8d1a3aab8fa22 ]---
> [    2.364689] BUG: scheduling while atomic: kthreadd/2/0x000000eb
> [    2.365189] INFO: lockdep is turned off.
> [    2.365515] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.366144] 
> [    2.366277] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.367005] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.367834]  ffff880012063cb0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.368491]  ffffffff810b88f7 00000000000000eb ffffffff81ff35e0 ffff88001344fef8
> [    2.369152]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.369812] Call Trace:
> [    2.370035]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.370462]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.370917]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.371356]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.371770]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.372195]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.372648]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.373096]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.373582] ------------[ cut here ]------------
> [    2.373978] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.374732] initcall extfrag_debug_init+0x0/0x7a returned with preemption imbalance 
> [    2.375368] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.376086] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.376916]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.377571]  ffffffff8109b88b ffff880012061b60 0000000000000000 ffff880012063cb0
> [    2.378231]  0000000000000000 ffffffff8211a9fe 0000000000000000 ffff88001344be88
> [    2.378891] Call Trace:
> [    2.379102]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.379529]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.380041]  [<ffffffff8211a9fe>] ? setup_vmstat+0x7c/0x7c
> [    2.380496]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.380974]  [<ffffffff8134a8ea>] ? debugfs_create_file+0x1a/0x20
> [    2.381475]  [<ffffffff8211a9fe>] ? setup_vmstat+0x7c/0x7c
> [    2.381932]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.382406]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.382917]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.383347]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.383775]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.384218]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.384654] ---[ end trace 16f8d1a3aab8fa23 ]---
> [    2.385078] zbud: loaded
> [    2.385344] VFS: Disk quotas dquot_6.5.2
> [    2.385684] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    2.386352] ntfs: driver 2.1.31 [Flags: R/O DEBUG].
> [    2.386824] BUG: scheduling while atomic: kdevtmpfs/14/0x0000007d
> [    2.387337] INFO: lockdep is turned off.
> [    2.387664] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.388314] 
> [    2.388447] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.389191] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.390038]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    2.390694]  ffffffff810b88f7 000000000000007d 0000000000000000 ffff8800134c3df8
> [    2.391353]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    2.392011] Call Trace:
> [    2.392221]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.392649]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.393105]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.393543]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.393957]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    2.394388]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    2.394864]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.395275]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.395757]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.396204]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.396702] ------------[ cut here ]------------
> [    2.397096] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.397858] initcall init_autofs4_fs+0x0/0x2a returned with preemption imbalance 
> [    2.398474] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.399196] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.400042]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.400701]  ffffffff8109b88b ffffffff82006b40 0000000000000000 ffff880012076ca8
> [    2.401361]  0000000000000000 ffffffff8211f292 0000000000000000 ffff88001344be88
> [    2.402020] Call Trace:
> [    2.402230]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.402657]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.403155]  [<ffffffff8211f292>] ? init_ntfs_fs+0x23e/0x23e
> [    2.403624]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.404101]  [<ffffffff8211f292>] ? init_ntfs_fs+0x23e/0x23e
> [    2.404567]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.405043]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.405551]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.405987]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.406412]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.406862]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.407293] ---[ end trace 16f8d1a3aab8fa24 ]---
> [    2.407677] fuse init (API version 7.23)
> [    2.408036] BUG: scheduling while atomic: kdevtmpfs/14/0x00000083
> [    2.408541] INFO: lockdep is turned off.
> [    2.408874] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.409517] 
> [    2.409651] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.410405] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.411238]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    2.411898]  ffffffff810b88f7 0000000000000083 0000000000000000 ffff8800134c3df8
> [    2.412556]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    2.413215] Call Trace:
> [    2.413425]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.413852]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.414303]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.414723]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.415129]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    2.415541]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    2.415998]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.416391]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.416854]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.417284]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.417771] ------------[ cut here ]------------
> [    2.418147] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.418873] initcall fuse_init+0x0/0x1b6 returned with preemption imbalance 
> [    2.419427] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.420130] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.420928]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.421555]  ffffffff8109b88b ffffffff8211f355 0000000000000000 ffff8800120771f8
> [    2.422187]  0000000000000000 ffffffff8211f355 0000000000000000 ffff88001344be88
> [    2.422818] Call Trace:
> [    2.423019]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.423428]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.423907]  [<ffffffff8211f355>] ? fuse_dev_init+0x58/0x58
> [    2.424347]  [<ffffffff8211f355>] ? fuse_dev_init+0x58/0x58
> [    2.424790]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.425243]  [<ffffffff8211f51b>] ? fuse_ctl_init+0x10/0x12
> [    2.425681]  [<ffffffff8211f355>] ? fuse_dev_init+0x58/0x58
> [    2.426123]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.426576]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.427066]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.427480]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.427891]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.428317]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.428729] ---[ end trace 16f8d1a3aab8fa25 ]---
> [    2.429127] BUG: scheduling while atomic: swapper/1/0x00000003
> [    2.429588] INFO: lockdep is turned off.
> [    2.429903] Preemption disabled at:[<ffffffff81942fb2>] netlink_has_listeners+0x22/0xc0
> [    2.430555] 
> [    2.430682] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.431371] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.432168]  ffff88001344bc90 ffff88001344baa8 ffffffff81b5b203 ffff88001344bac8
> [    2.432799]  ffffffff810b88f7 0000000000000003 7fffffffffffffff ffff88001344bb28
> [    2.433426]  ffffffff81b5e5a5 0000000000000002 ffff880013444000 ffff88001344bfd8
> [    2.434056] Call Trace:
> [    2.434258]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.434666]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.435103]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.435523]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.435921]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    2.436382]  [<ffffffff81b5f311>] ? wait_for_completion+0x31/0x110
> [    2.436873]  [<ffffffff81b5f3b4>] wait_for_completion+0xd4/0x110
> [    2.437345]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    2.437782]  [<ffffffff815b532a>] devtmpfs_create_node+0x11a/0x160
> [    2.438269]  [<ffffffff815ad01e>] device_add+0x24e/0x600
> [    2.438690]  [<ffffffff815ad4a8>] device_create_groups_vargs+0xd8/0xf0
> [    2.439207]  [<ffffffff8211f51d>] ? fuse_ctl_init+0x12/0x12
> [    2.439648]  [<ffffffff815ade76>] device_create+0x36/0x40
> [    2.440087]  [<ffffffff8211f51d>] ? fuse_ctl_init+0x12/0x12
> [    2.440530]  [<ffffffff8156cf37>] misc_register+0xc7/0x120
> [    2.440969]  [<ffffffff8211f5ab>] cuse_init+0x8e/0xa8
> [    2.441372]  [<ffffffff82105022>] do_one_initcall+0x192/0x1a6
> [    2.441832]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.442323]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.442737]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.443148]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.443576]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.444017] BUG: scheduling while atomic: kdevtmpfs/14/0x00000089
> [    2.444501] INFO: lockdep is turned off.
> [    2.444819] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.445433] 
> [    2.445560] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.446279] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.447083]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    2.447716]  ffffffff810b88f7 0000000000000089 0000000000000000 ffff8800134c3df8
> [    2.448352]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    2.448990] Call Trace:
> [    2.449194]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.449605]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.450056]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.450478]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.450879]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    2.451294]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    2.451752]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.452148]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.452610]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.453041]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.453519] ------------[ cut here ]------------
> [    2.453895] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.454618] initcall cuse_init+0x0/0xa8 returned with preemption imbalance 
> [    2.455171] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.455861] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.456656]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.457289]  ffffffff8109b88b ffffffff8211f51d 0000000000000000 ffff880012077978
> [    2.457922]  0000000000000000 ffffffff8211f51d 0000000000000000 ffff88001344be88
> [    2.458550] Call Trace:
> [    2.458753]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.459162]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.459636]  [<ffffffff8211f51d>] ? fuse_ctl_init+0x12/0x12
> [    2.460090]  [<ffffffff8211f51d>] ? fuse_ctl_init+0x12/0x12
> [    2.460531]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.460989]  [<ffffffff8211f51d>] ? fuse_ctl_init+0x12/0x12
> [    2.461430]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.461888]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.462375]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.462792]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.463199]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.463626]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.464043] ---[ end trace 16f8d1a3aab8fa26 ]---
> [    2.464435] JFS: nTxBlock = 2218, nTxLock = 17750
> [    2.465723] BUG: scheduling while atomic: kthreadd/2/0x000000f1
> [    2.466202] INFO: lockdep is turned off.
> [    2.466517] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.467122] 
> [    2.467249] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.467948] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.468774]  ffff880012083760 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.469430]  ffffffff810b88f7 00000000000000f1 ffffffff81ff35e0 ffff88001344fef8
> [    2.470103]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.470761] Call Trace:
> [    2.470971]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.471394]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.471850]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.472291]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.472701]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.473129]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.473583]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.474030]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.474514] BUG: scheduling while atomic: kthreadd/2/0x000000f7
> [    2.475013] INFO: lockdep is turned off.
> [    2.475339] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.475970] 
> [    2.476103] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.476833] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.477669]  ffff880012083760 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.478331]  ffffffff810b88f7 00000000000000f7 ffffffff81ff35e0 ffff88001344fef8
> [    2.478992]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.479649] Call Trace:
> [    2.479864]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.480303]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.480761]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.481200]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.481614]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.482044]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.482498]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.482947]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.483423] BUG: scheduling while atomic: kthreadd/2/0x000000fd
> [    2.483919] INFO: lockdep is turned off.
> [    2.484247] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.484879] 
> [    2.485012] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.485743] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.486582]  ffff880012083760 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.487245]  ffffffff810b88f7 00000000000000fd ffffffff81ff35e0 ffff88001344fef8
> [    2.487908]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.488567] Call Trace:
> [    2.488781]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.489208]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.489661]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.490123]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.490534]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.490962]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.491413]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.491861]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.492335] SGI XFS with ACLs, security attributes, realtime, no debug enabled
> [    2.492979] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    2.493500] INFO: lockdep is turned off.
> [    2.493831] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.494471] 
> [    2.494604] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.495357] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.496194]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    2.496856]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    2.497514]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    2.498174] Call Trace:
> [    2.498385]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.498814]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.499267]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.499707]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.500133]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    2.500587]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    2.501085]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.501497]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.501981]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.502426]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.502924] BUG: scheduling while atomic: kthreadd/2/0x00000107
> [    2.503413] INFO: lockdep is turned off.
> [    2.503739] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.504367] 
> [    2.504500] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.505226] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.506062]  ffff8800122370a0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.506719]  ffffffff810b88f7 0000000000000107 ffffffff81ff35e0 ffff88001344fef8
> [    2.507381]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.508042] Call Trace:
> [    2.508253]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.508677]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.509131]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.509570]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.509983]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.510420]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.510877]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.511325]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.511790] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    2.512307] INFO: lockdep is turned off.
> [    2.512634] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.513280] 
> [    2.513413] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.514169] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.515002]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    2.515660]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    2.516319]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    2.516979] Call Trace:
> [    2.517190]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.517616]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.518072]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.518513]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.518929]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    2.519381]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    2.519877]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.520299]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.520785]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.521230]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.521726] BUG: scheduling while atomic: kthreadd/2/0x0000010d
> [    2.522221] INFO: lockdep is turned off.
> [    2.522547] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.523180] 
> [    2.523315] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.524044] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.524875]  ffff8800122370a0 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.525533]  ffffffff810b88f7 000000000000010d ffffffff81ff35e0 ffff88001344fef8
> [    2.526192]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.526851] Call Trace:
> [    2.527061]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.527487]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.527943]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.528384]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.528798]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.529224]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.529677]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.530136]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.530604] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    2.531127] INFO: lockdep is turned off.
> [    2.531457] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    2.532103] 
> [    2.532236] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.532992] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.533827]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    2.534483]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    2.535141]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    2.535801] Call Trace:
> [    2.536011]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.536440]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.536896]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.537335]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.537746]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    2.538200]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    2.538695]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    2.539108]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.539588]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.540047]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    2.540550] BUG: scheduling while atomic: kthreadd/2/0x00000113
> [    2.541045] INFO: lockdep is turned off.
> [    2.541373] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.542004] 
> [    2.542137] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.542863] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.543687]  ffff880012237470 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.544346]  ffffffff810b88f7 0000000000000113 ffffffff81ff35e0 ffff88001344fef8
> [    2.545004]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.545658] Call Trace:
> [    2.545871]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.546296]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.546748]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.547192]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.547604]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.548030]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.548484]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.548933]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.549438] NILFS version 2 loaded
> [    2.549771] BUG: scheduling while atomic: kthreadd/2/0x00000119
> [    2.550273] INFO: lockdep is turned off.
> [    2.550599] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.551227] 
> [    2.551359] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.552090] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.552922]  ffff880012237fb8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.553581]  ffffffff810b88f7 0000000000000119 ffffffff81ff35e0 ffff88001344fef8
> [    2.554242]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.554902] Call Trace:
> [    2.555114]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.555537]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.555994]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.556433]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.556847]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.557271]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.557723]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.558172]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.558682] ------------[ cut here ]------------
> [    2.559079] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.559834] initcall ocfs2_init+0x0/0x313 returned with preemption imbalance 
> [    2.560436] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.561156] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.561983]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.562633]  ffffffff8109b88b ffffffff8211ffd7 0000000000000000 ffff880012237d88
> [    2.563287]  0000000000000000 ffffffff8211ffd7 0000000000000000 ffff88001344be88
> [    2.563941] Call Trace:
> [    2.564151]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.564575]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.565072]  [<ffffffff8211ffd7>] ? debugfs_init+0x5f/0x5f
> [    2.565524]  [<ffffffff8211ffd7>] ? debugfs_init+0x5f/0x5f
> [    2.565978]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.566457]  [<ffffffff821202bc>] ? ocfs2_init+0x2e5/0x313
> [    2.566914]  [<ffffffff8211ffd7>] ? debugfs_init+0x5f/0x5f
> [    2.567367]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.567846]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.568354]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.568789]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.569212]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.569657]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.570107] ---[ end trace 16f8d1a3aab8fa27 ]---
> [    2.570520] ocfs2: Registered cluster interface o2cb
> [    2.570962] BUG: scheduling while atomic: kthreadd/2/0x0000011f
> [    2.571452] INFO: lockdep is turned off.
> [    2.571783] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.572410] 
> [    2.572543] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.573271] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.574103]  ffff88001223b8c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.574762]  ffffffff810b88f7 000000000000011f ffffffff81ff35e0 ffff88001344fef8
> [    2.575418]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.576078] Call Trace:
> [    2.576289]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.576713]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.577168]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.577606]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.578018]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.578441]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.578896]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.579340]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.579801] OCFS2 User DLM kernel interface loaded
> [    2.580429] ------------[ cut here ]------------
> [    2.580827] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.581580] initcall init_o2nm+0x0/0xa1 returned with preemption imbalance 
> [    2.582153] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.582876] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.583703]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.584358]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff88001223b8c8
> [    2.585013]  0000000000000000 ffffffff821204b1 0000000000000000 ffff88001344be88
> [    2.585666] Call Trace:
> [    2.585879]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.586305]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.586803]  [<ffffffff821204b1>] ? init_dlmfs_fs+0xef/0xef
> [    2.587262]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.587734]  [<ffffffff821204b1>] ? init_dlmfs_fs+0xef/0xef
> [    2.588192]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.588665]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.589173]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.589603]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.590039]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.590484]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.590920] ---[ end trace 16f8d1a3aab8fa28 ]---
> [    2.591311] ------------[ cut here ]------------
> [    2.591695] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    2.592445] initcall dlm_init+0x0/0x3a5 returned with preemption imbalance 
> [    2.593018] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.593736] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.594562]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    2.595217]  ffffffff8109b88b ffff88001344be08 0000000000000000 ffff880012267ab8
> [    2.595872]  0000000000000000 ffffffff82120552 0000000000000000 ffff88001344be88
> [    2.596526] Call Trace:
> [    2.596739]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.597168]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    2.597663]  [<ffffffff82120552>] ? init_o2nm+0xa1/0xa1
> [    2.598096]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    2.598569]  [<ffffffff82120552>] ? init_o2nm+0xa1/0xa1
> [    2.599003]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    2.599477]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    2.599987]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.600429]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    2.600858]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.601305]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    2.601736] ---[ end trace 16f8d1a3aab8fa29 ]---
> [    2.602130] msgmni has been set to 554
> [    2.602530] BUG: scheduling while atomic: kthreadd/2/0x00000125
> [    2.603024] INFO: lockdep is turned off.
> [    2.603349] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.603975] 
> [    2.604107] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.604834] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.605662]  ffff880012268428 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.606323]  ffffffff810b88f7 0000000000000125 ffffffff81ff35e0 ffff88001344fef8
> [    2.606983]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.607639] Call Trace:
> [    2.607854]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.608276]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.608725]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.609166]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.609575]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.610004]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.610466]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.610915]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.611409] BUG: scheduling while atomic: kthreadd/2/0x0000012b
> [    2.611901] INFO: lockdep is turned off.
> [    2.612228] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.612858] 
> [    2.612991] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.613714] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.614547]  ffff880012268428 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.615206]  ffffffff810b88f7 000000000000012b ffffffff81ff35e0 ffff88001344fef8
> [    2.615865]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.616521] Call Trace:
> [    2.616732]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.617160]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.617613]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.618055]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.618466]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.618895]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.619347]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.619797]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.620295] BUG: scheduling while atomic: kthreadd/2/0x00000131
> [    2.620792] INFO: lockdep is turned off.
> [    2.621120] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.621747] 
> [    2.621883] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.622604] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.623436]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.624096]  ffffffff810b88f7 0000000000000131 ffffffff81ff35e0 ffff88001344fef8
> [    2.624756]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.625412] Call Trace:
> [    2.625622]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.626049]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.626500]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.626944]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.627353]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.627779]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.628230]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.628674]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.629176] BUG: scheduling while atomic: kthreadd/2/0x00000137
> [    2.629667] INFO: lockdep is turned off.
> [    2.629996] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.630632] 
> [    2.630770] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.631492] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.632323]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.632983]  ffffffff810b88f7 0000000000000137 ffffffff81ff35e0 ffff88001344fef8
> [    2.633639]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.634295] Call Trace:
> [    2.634504]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.634934]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.635387]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.635827]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.636237]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.636660]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.637116]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.637561]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.638053] BUG: scheduling while atomic: kthreadd/2/0x0000013d
> [    2.638544] INFO: lockdep is turned off.
> [    2.638875] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.639501] 
> [    2.639633] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.640366] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.641200]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.641859]  ffffffff810b88f7 000000000000013d ffffffff81ff35e0 ffff88001344fef8
> [    2.642514]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.643172] Call Trace:
> [    2.643383]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.643811]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.644264]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.644701]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.645114]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.645539]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.645994]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.646439]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.646933] BUG: scheduling while atomic: kthreadd/2/0x00000143
> [    2.647422] INFO: lockdep is turned off.
> [    2.647746] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.648373] 
> [    2.648505] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.649229] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.650068]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.650724]  ffffffff810b88f7 0000000000000143 ffffffff81ff35e0 ffff88001344fef8
> [    2.651380]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.652036] Call Trace:
> [    2.652247]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.652669]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.653125]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.653562]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.653977]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.654401]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.654854]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.655297]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.655788] BUG: scheduling while atomic: kthreadd/2/0x00000149
> [    2.656278] INFO: lockdep is turned off.
> [    2.656602] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.657235] 
> [    2.657368] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.658092] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.658926]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.659583]  ffffffff810b88f7 0000000000000149 ffffffff81ff35e0 ffff88001344fef8
> [    2.660255]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.660914] Call Trace:
> [    2.661124]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.661548]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.662003]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.662440]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.662854]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.663279]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.663732]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.664181]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.664671] BUG: scheduling while atomic: kthreadd/2/0x0000014f
> [    2.665171] INFO: lockdep is turned off.
> [    2.665498] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.666132] 
> [    2.666265] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.666994] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.667829]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.668483]  ffffffff810b88f7 000000000000014f ffffffff81ff35e0 ffff88001344fef8
> [    2.669142]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.669800] Call Trace:
> [    2.670020]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.670447]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.670903]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.671341]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.671754]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.672181]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.672635]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.673085]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.673575] BUG: scheduling while atomic: kthreadd/2/0x00000155
> [    2.674072] INFO: lockdep is turned off.
> [    2.674400] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.675028] 
> [    2.675160] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.675885] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.676717]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.677377]  ffffffff810b88f7 0000000000000155 ffffffff81ff35e0 ffff88001344fef8
> [    2.678038]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.678694] Call Trace:
> [    2.678907]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.679331]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.679785]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.680235]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.680646]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.681073]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.681526]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.681973]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.682469] BUG: scheduling while atomic: kthreadd/2/0x0000015b
> [    2.682963] INFO: lockdep is turned off.
> [    2.683289] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.683914] 
> [    2.684046] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.684774] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.685601]  ffff8800122a2098 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.686261]  ffffffff810b88f7 000000000000015b ffffffff81ff35e0 ffff88001344fef8
> [    2.686919]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.687575] Call Trace:
> [    2.687788]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.688211]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.688662]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.689103]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.689513]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.689939]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.690401]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.690853]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.691340] BUG: scheduling while atomic: kthreadd/2/0x00000161
> [    2.691834] INFO: lockdep is turned off.
> [    2.692159] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.692785] 
> [    2.692917] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.693642] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.694468]  ffff8800122a2098 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.695124]  ffffffff810b88f7 0000000000000161 ffffffff81ff35e0 ffff88001344fef8
> [    2.695780]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.696434] Call Trace:
> [    2.696644]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.697072]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.697526]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.697968]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.698379]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.698806]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.699258]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.699703]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.700203] BUG: scheduling while atomic: kthreadd/2/0x00000167
> [    2.700695] INFO: lockdep is turned off.
> [    2.701025] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.701651] 
> [    2.701787] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.702507] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.703334]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.703989]  ffffffff810b88f7 0000000000000167 ffffffff81ff35e0 ffff88001344fef8
> [    2.704641]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.705296] Call Trace:
> [    2.705506]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.705933]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.706383]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.706822]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.707230]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.707653]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.708106]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.708548]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.709035] BUG: scheduling while atomic: kthreadd/2/0x0000016d
> [    2.709524] INFO: lockdep is turned off.
> [    2.709852] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.710489] 
> [    2.710621] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.711351] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.712187]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.712847]  ffffffff810b88f7 000000000000016d ffffffff81ff35e0 ffff88001344fef8
> [    2.713503]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.714162] Call Trace:
> [    2.714372]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.714800]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.715250]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.715687]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.716099]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.716521]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.716976]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.717424]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.717915] BUG: scheduling while atomic: kthreadd/2/0x00000173
> [    2.718403] INFO: lockdep is turned off.
> [    2.718732] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.719366] 
> [    2.719499] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.720239] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.721071]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.721725]  ffffffff810b88f7 0000000000000173 ffffffff81ff35e0 ffff88001344fef8
> [    2.722383]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.723042] Call Trace:
> [    2.723252]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.723679]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.724135]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.724574]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.724987]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.725412]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.725869]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.726314]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.726804] BUG: scheduling while atomic: kthreadd/2/0x00000179
> [    2.727292] INFO: lockdep is turned off.
> [    2.727617] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.728247] 
> [    2.728379] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.729107] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.729940]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.730609]  ffffffff810b88f7 0000000000000179 ffffffff81ff35e0 ffff88001344fef8
> [    2.731269]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.731926] Call Trace:
> [    2.732136]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.732560]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.733016]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.733455]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.733869]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.734295]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.734748]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.735201]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.735689] BUG: scheduling while atomic: kthreadd/2/0x0000017f
> [    2.736184] INFO: lockdep is turned off.
> [    2.736509] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.737136] 
> [    2.737269] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.737997] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.738826]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.739480]  ffffffff810b88f7 000000000000017f ffffffff81ff35e0 ffff88001344fef8
> [    2.740149]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.740806] Call Trace:
> [    2.741016]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.741440]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.741896]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.742334]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.742743]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.743173]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.743626]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.744073]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.744575] BUG: scheduling while atomic: kthreadd/2/0x00000185
> [    2.745072] INFO: lockdep is turned off.
> [    2.745399] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.746030] 
> [    2.746163] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.746896] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.747695]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.748341]  ffffffff810b88f7 0000000000000185 ffffffff81ff35e0 ffff88001344fef8
> [    2.748974]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.749603] Call Trace:
> [    2.749809]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.750227]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.750663]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.751085]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.751479]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.751891]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.752326]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.752757]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.753229] BUG: scheduling while atomic: kthreadd/2/0x0000018b
> [    2.753702] INFO: lockdep is turned off.
> [    2.754023] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.754626] 
> [    2.754757] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.755454] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.756251]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.756882]  ffffffff810b88f7 000000000000018b ffffffff81ff35e0 ffff88001344fef8
> [    2.757513]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.758146] Call Trace:
> [    2.758349]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.758762]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.759199]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.759620]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.760029]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.760440]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.760879]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.761306]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.761780] BUG: scheduling while atomic: kthreadd/2/0x00000191
> [    2.762250] INFO: lockdep is turned off.
> [    2.762563] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.763170] 
> [    2.763298] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.764009] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.764844]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.765502]  ffffffff810b88f7 0000000000000191 ffffffff81ff35e0 ffff88001344fef8
> [    2.766163]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.766822] Call Trace:
> [    2.767033]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.767456]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.767910]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.768346]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.768756]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.769181]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.769632]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.770092]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.770584] BUG: scheduling while atomic: kthreadd/2/0x00000197
> [    2.771079] INFO: lockdep is turned off.
> [    2.771406] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.772036] 
> [    2.772168] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.772895] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.773720]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.774378]  ffffffff810b88f7 0000000000000197 ffffffff81ff35e0 ffff88001344fef8
> [    2.775036]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.775689] Call Trace:
> [    2.775901]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.776325]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.776779]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.777218]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.777626]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.778051]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.778500]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.778946]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.779431] BUG: scheduling while atomic: kthreadd/2/0x0000019d
> [    2.779928] INFO: lockdep is turned off.
> [    2.780264] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.780894] 
> [    2.781027] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.781756] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.782584]  ffff8800122a2368 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.783241]  ffffffff810b88f7 000000000000019d ffffffff81ff35e0 ffff88001344fef8
> [    2.783896]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.784547] Call Trace:
> [    2.784759]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.785184]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.785637]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.786078]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.786487]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.786912]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.787361]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.787807]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.788305] BUG: scheduling while atomic: kthreadd/2/0x000001a3
> [    2.788801] INFO: lockdep is turned off.
> [    2.789129] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.789756] 
> [    2.789889] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.790626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.791458]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.792115]  ffffffff810b88f7 00000000000001a3 ffffffff81ff35e0 ffff88001344fef8
> [    2.792770]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.793423] Call Trace:
> [    2.793632]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.794058]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.794506]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.794944]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.795350]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.795772]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.796224]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.796666]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.797166] BUG: scheduling while atomic: kthreadd/2/0x000001a9
> [    2.797655] INFO: lockdep is turned off.
> [    2.797984] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.798606] 
> [    2.798737] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.799460] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.800296]  ffff8800000161a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.800954]  ffffffff810b88f7 00000000000001a9 ffffffff81ff35e0 ffff88001344fef8
> [    2.801605]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.802262] Call Trace:
> [    2.802472]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.802900]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.803353]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.803794]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.804203]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.804625]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.805079]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.805525]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.806015] BUG: scheduling while atomic: kthreadd/2/0x000001af
> [    2.806505] INFO: lockdep is turned off.
> [    2.806834] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.807462] 
> [    2.807594] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.808325] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.809163]  ffff8800000161a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.809824]  ffffffff810b88f7 00000000000001af ffffffff81ff35e0 ffff88001344fef8
> [    2.810494]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.811153] Call Trace:
> [    2.811363]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.811790]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.812241]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.812676]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.813088]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.813511]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.813965]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.814409]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.814910] BUG: scheduling while atomic: kthreadd/2/0x000001b5
> [    2.815398] INFO: lockdep is turned off.
> [    2.815721] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.816346] 
> [    2.816477] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.817202] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.818028]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.818680]  ffffffff810b88f7 00000000000001b5 ffffffff81ff35e0 ffff88001344fef8
> [    2.819335]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.819989] Call Trace:
> [    2.820209]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.820635]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.821090]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.821527]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.821940]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.822362]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.822814]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.823257]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.823744] BUG: scheduling while atomic: kthreadd/2/0x000001bb
> [    2.824236] INFO: lockdep is turned off.
> [    2.824562] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.825191] 
> [    2.825323] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.826052] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.826884]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.827541]  ffffffff810b88f7 00000000000001bb ffffffff81ff35e0 ffff88001344fef8
> [    2.828199]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.828857] Call Trace:
> [    2.829067]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.829492]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.829947]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.830394]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.830808]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.831232]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.831682]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.832130]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.832615] BUG: scheduling while atomic: kthreadd/2/0x000001c1
> [    2.833107] INFO: lockdep is turned off.
> [    2.833433] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.834058] 
> [    2.834189] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.834916] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.835743]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.836399]  ffffffff810b88f7 00000000000001c1 ffffffff81ff35e0 ffff88001344fef8
> [    2.837055]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.837711] Call Trace:
> [    2.837926]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.838353]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.838810]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.839249]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.839661]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.840099]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.840555]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.841005]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.841496] BUG: scheduling while atomic: kthreadd/2/0x000001c7
> [    2.841993] INFO: lockdep is turned off.
> [    2.842320] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.842949] 
> [    2.843082] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.843813] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.844648]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.845311]  ffffffff810b88f7 00000000000001c7 ffffffff81ff35e0 ffff88001344fef8
> [    2.845973]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.846628] Call Trace:
> [    2.846843]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.847269]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.847722]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.848164]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.848576]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.849005]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.849458]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.849908]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.850408] BUG: scheduling while atomic: kthreadd/2/0x000001cd
> [    2.850903] INFO: lockdep is turned off.
> [    2.851231] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.851858] 
> [    2.851991] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.852715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.853545]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.854202]  ffffffff810b88f7 00000000000001cd ffffffff81ff35e0 ffff88001344fef8
> [    2.854859]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.855510] Call Trace:
> [    2.855720]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.856144]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.856593]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.857034]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.857443]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.857869]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.858320]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.858769]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.859252] BUG: scheduling while atomic: kthreadd/2/0x000001d3
> [    2.859743] INFO: lockdep is turned off.
> [    2.860083] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.860703] 
> [    2.860839] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.861561] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.862394]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.863054]  ffffffff810b88f7 00000000000001d3 ffffffff81ff35e0 ffff88001344fef8
> [    2.863709]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.864367] Call Trace:
> [    2.864578]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.865004]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.865457]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.865899]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.866310]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.866735]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.867190]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.867639]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.868131] BUG: scheduling while atomic: kthreadd/2/0x000001d9
> [    2.868623] INFO: lockdep is turned off.
> [    2.868956] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.869587] 
> [    2.869720] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.870461] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.871294]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.871950]  ffffffff810b88f7 00000000000001d9 ffffffff81ff35e0 ffff88001344fef8
> [    2.872607]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.873270] Call Trace:
> [    2.873482]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.873911]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.874362]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.874802]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.875212]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.875635]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.876089]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.876533]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.877024] BUG: scheduling while atomic: kthreadd/2/0x000001df
> [    2.877516] INFO: lockdep is turned off.
> [    2.877849] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.878477] 
> [    2.878611] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.879339] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.880182]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.880843]  ffffffff810b88f7 00000000000001df ffffffff81ff35e0 ffff88001344fef8
> [    2.881498]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.882159] Call Trace:
> [    2.882371]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.882800]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.883252]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.883690]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.884103]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.884527]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.884981]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.885426]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.885918] BUG: scheduling while atomic: kthreadd/2/0x000001e5
> [    2.886407] INFO: lockdep is turned off.
> [    2.886732] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.887360] 
> [    2.887492] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.888217] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.889044]  ffff880000016198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.889697]  ffffffff810b88f7 00000000000001e5 ffffffff81ff35e0 ffff88001344fef8
> [    2.890366]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.891026] Call Trace:
> [    2.891238]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.891662]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.892118]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.892556]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.892970]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.893395]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.893851]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.894296]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.894799] BUG: scheduling while atomic: kthreadd/2/0x000001eb
> [    2.895293] INFO: lockdep is turned off.
> [    2.895621] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.896254] 
> [    2.896387] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.897115] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.897951]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.898605]  ffffffff810b88f7 00000000000001eb ffffffff81ff35e0 ffff88001344fef8
> [    2.899263]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.899921] Call Trace:
> [    2.900141]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.900567]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.901023]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.901462]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.901876]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.902300]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.902756]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.903202]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.903691] BUG: scheduling while atomic: kthreadd/2/0x000001f1
> [    2.904186] INFO: lockdep is turned off.
> [    2.904511] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.905137] 
> [    2.905269] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.905996] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.906826]  ffff88001230e1a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.907482]  ffffffff810b88f7 00000000000001f1 ffffffff81ff35e0 ffff88001344fef8
> [    2.908142]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.908801] Call Trace:
> [    2.909011]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.909435]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.909890]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.910340]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.910755]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.911183]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.911638]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.912087]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.912576] BUG: scheduling while atomic: kthreadd/2/0x000001f7
> [    2.913072] INFO: lockdep is turned off.
> [    2.913398] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.914027] 
> [    2.914159] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.914886] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.915714]  ffff88001230e1a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.916374]  ffffffff810b88f7 00000000000001f7 ffffffff81ff35e0 ffff88001344fef8
> [    2.917035]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.917693] Call Trace:
> [    2.918170]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.918596]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.919050]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.919488]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.919900]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.920338]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.920795]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.921240]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.921741] BUG: scheduling while atomic: kthreadd/2/0x000001fd
> [    2.922239] INFO: lockdep is turned off.
> [    2.922565] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.923194] 
> [    2.923327] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.924056] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.924891]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.925553]  ffffffff810b88f7 00000000000001fd ffffffff81ff35e0 ffff88001344fef8
> [    2.926216]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.926878] Call Trace:
> [    2.927089]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.927513]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.927968]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.928410]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.928822]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.929247]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.929698]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.930156]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.930645] BUG: scheduling while atomic: kthreadd/2/0x00000207
> [    2.931140] INFO: lockdep is turned off.
> [    2.931464] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.932089] 
> [    2.932221] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.932950] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.933781]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.934432]  ffffffff810b88f7 0000000000000207 ffffffff81ff35e0 ffff88001344fef8
> [    2.935087]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.935739] Call Trace:
> [    2.935951]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.936375]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.936830]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.937269]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.937678]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.938104]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.938556]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.939003]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.939491] BUG: scheduling while atomic: kthreadd/2/0x0000020d
> [    2.939986] INFO: lockdep is turned off.
> [    2.940324] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.940954] 
> [    2.941087] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.941818] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.942651]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.943313]  ffffffff810b88f7 000000000000020d ffffffff81ff35e0 ffff88001344fef8
> [    2.943974]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.944629] Call Trace:
> [    2.944843]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.945269]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.945721]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.946162]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.946575]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.947004]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.947455]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.947903]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.948396] BUG: scheduling while atomic: kthreadd/2/0x00000213
> [    2.948891] INFO: lockdep is turned off.
> [    2.949218] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.949844] 
> [    2.949977] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.950715] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.951551]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.952214]  ffffffff810b88f7 0000000000000213 ffffffff81ff35e0 ffff88001344fef8
> [    2.952876]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.953534] Call Trace:
> [    2.953746]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.954176]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.954629]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.955071]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.955482]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.955910]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.956364]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.956814]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.957312] BUG: scheduling while atomic: kthreadd/2/0x00000219
> [    2.957806] INFO: lockdep is turned off.
> [    2.958136] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.958772] 
> [    2.958905] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.959631] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.960469]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.961133]  ffffffff810b88f7 0000000000000219 ffffffff81ff35e0 ffff88001344fef8
> [    2.961795]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.962451] Call Trace:
> [    2.962662]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.963090]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.963544]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.963986]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.964397]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.964826]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.965280]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.965724]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.966231] BUG: scheduling while atomic: kthreadd/2/0x0000021f
> [    2.966721] INFO: lockdep is turned off.
> [    2.967053] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.967681] 
> [    2.967818] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.968546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.969381]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.970056]  ffffffff810b88f7 000000000000021f ffffffff81ff35e0 ffff88001344fef8
> [    2.970713]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.971376] Call Trace:
> [    2.971588]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.972016]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.972469]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.972911]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.973322]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.973746]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.974203]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.974649]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.975142] BUG: scheduling while atomic: kthreadd/2/0x00000225
> [    2.975633] INFO: lockdep is turned off.
> [    2.975964] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.976590] 
> [    2.976723] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.977452] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.978288]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.978950]  ffffffff810b88f7 0000000000000225 ffffffff81ff35e0 ffff88001344fef8
> [    2.979609]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.980283] Call Trace:
> [    2.980495]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.980924]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.981377]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.981819]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.982230]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.982654]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.983110]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.983556]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.984047] BUG: scheduling while atomic: kthreadd/2/0x0000022b
> [    2.984539] INFO: lockdep is turned off.
> [    2.984871] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.985499] 
> [    2.985632] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.986361] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.987194]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.987855]  ffffffff810b88f7 000000000000022b ffffffff81ff35e0 ffff88001344fef8
> [    2.988512]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.989181] Call Trace:
> [    2.989393]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.989823]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.990285]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.990723]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.991138]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    2.991562]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.992016]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    2.992461]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    2.992951] BUG: scheduling while atomic: kthreadd/2/0x00000231
> [    2.993440] INFO: lockdep is turned off.
> [    2.993769] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    2.994390] 
> [    2.994522] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    2.995251] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    2.996080]  ffff88001230e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    2.996735]  ffffffff810b88f7 0000000000000231 ffffffff81ff35e0 ffff88001344fef8
> [    2.997392]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    2.998049] Call Trace:
> [    2.998258]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    2.998684]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    2.999142]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    2.999581]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    2.999994]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.000430]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.000888]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.001333]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.001841] BUG: scheduling while atomic: kthreadd/2/0x00000237
> [    3.002333] INFO: lockdep is turned off.
> [    3.002660] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.003287] 
> [    3.003419] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.004148] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.004982]  ffff880012268418 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.005641]  ffffffff810b88f7 0000000000000237 ffffffff81ff35e0 ffff88001344fef8
> [    3.006302]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.006961] Call Trace:
> [    3.007172]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.007595]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.008049]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.008486]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.008899]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.009326]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.009783]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.010240]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.010727] BUG: scheduling while atomic: kthreadd/2/0x0000023d
> [    3.011226] INFO: lockdep is turned off.
> [    3.011554] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.012181] 
> [    3.012313] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.013042] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.013873]  ffff88001236e1a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.014527]  ffffffff810b88f7 000000000000023d ffffffff81ff35e0 ffff88001344fef8
> [    3.015184]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.015842] Call Trace:
> [    3.016052]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.016476]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.016930]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.017367]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.017779]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.018202]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.018653]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.019104]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.019594] BUG: scheduling while atomic: kthreadd/2/0x00000243
> [    3.020103] INFO: lockdep is turned off.
> [    3.020432] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.021063] 
> [    3.021196] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.021926] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.022759]  ffff88001236e1a8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.023414]  ffffffff810b88f7 0000000000000243 ffffffff81ff35e0 ffff88001344fef8
> [    3.024073]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.024730] Call Trace:
> [    3.024944]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.025370]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.025826]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.026264]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.026675]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.027103]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.027554]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.028002]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.028489] BUG: scheduling while atomic: kthreadd/2/0x00000249
> [    3.028981] INFO: lockdep is turned off.
> [    3.029307] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.029935] 
> [    3.030078] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.030808] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.031633]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.032292]  ffffffff810b88f7 0000000000000249 ffffffff81ff35e0 ffff88001344fef8
> [    3.032951]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.033604] Call Trace:
> [    3.033818]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.034241]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.034693]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.035134]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.035543]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.035970]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.036423]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.036872]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.037359] BUG: scheduling while atomic: kthreadd/2/0x0000024f
> [    3.037857] INFO: lockdep is turned off.
> [    3.038183] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.038812] 
> [    3.038945] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.039671] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.040512]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.041172]  ffffffff810b88f7 000000000000024f ffffffff81ff35e0 ffff88001344fef8
> [    3.041830]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.042483] Call Trace:
> [    3.042693]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.043120]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.043572]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.044012]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.044421]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.044849]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.045299]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.045743]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.050051] tsc: Refined TSC clocksource calibration: 2925.999 MHz
> [    3.050567] BUG: workqueue leaked lock or atomic: kworker/0:1/0x000001e1/22
> [    3.050567]      last function: tsc_refine_calibration_work
> [    3.051590] INFO: lockdep is turned off.
> [    3.051921] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.052675] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.053509] Workqueue: events tsc_refine_calibration_work
> [    3.053969]  ffffffff81fceac0 ffff8800135afd68 ffffffff81b5b203 ffff8800135afde8
> [    3.054623]  ffffffff810af83e ffffffff810af63e ffffffff81ff1d58 ffffffff81fceac8
> [    3.055280]  0000000081ff1d40 ffffffff81fceac0 0000000000000000 0000000000000000
> [    3.055936] Call Trace:
> [    3.056147]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.056573]  [<ffffffff810af83e>] process_one_work+0x33e/0x460
> [    3.057057]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    3.057552]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    3.058008]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    3.058502]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.058914]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.059392]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.059840]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.060329] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    3.060844] INFO: lockdep is turned off.
> [    3.061170] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    3.061814] 
> [    3.061946] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.062699] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.063535]  ffffffff81ff1d40 ffff8800135afd58 ffffffff81b5b203 ffff8800135afd78
> [    3.064193]  ffffffff810b88f7 00000000000001e2 ffff88001359d320 ffff8800135afdd8
> [    3.064850]  ffffffff81b5e5a5 ffff8800135afdc8 ffff8800135a8000 ffff8800135affd8
> [    3.065503] Call Trace:
> [    3.065713]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.066137]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.066589]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.067028]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.067437]  [<ffffffff810afa36>] worker_thread+0xd6/0x490
> [    3.067892]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    3.068385]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.068800]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.069278]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.069723]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.070220] BUG: scheduling while atomic: rcuop/0/10/0x0000001b
> [    3.070707] INFO: lockdep is turned off.
> [    3.071037] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    3.071632] 
> [    3.071768] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.072487] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.073315]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    3.073974]  ffffffff810b88f7 000000000000001b ffffffff81ff6e40 ffff88001349fd98
> [    3.074626]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    3.075285] Call Trace:
> [    3.075496]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.075925]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.076376]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.076817]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.077227]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    3.077705]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    3.078201]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    3.078682]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    3.079163]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    3.079747]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.080175]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.080655]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.081104]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.081625] BUG: scheduling while atomic: kthreadd/2/0x00000255
> [    3.082119] INFO: lockdep is turned off.
> [    3.082445] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.083077] 
> [    3.083209] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.083932] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.084760]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.085413]  ffffffff810b88f7 0000000000000255 ffffffff81ff35e0 ffff88001344fef8
> [    3.086068]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.086720] Call Trace:
> [    3.086933]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.087357]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.087812]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.088250]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.088660]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.089089]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.089541]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.089990]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.090489] BUG: scheduling while atomic: kthreadd/2/0x0000025b
> [    3.090984] INFO: lockdep is turned off.
> [    3.091312] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.091943] 
> [    3.092076] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.092802] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.093628]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.094287]  ffffffff810b88f7 000000000000025b ffffffff81ff35e0 ffff88001344fef8
> [    3.094945]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.095597] Call Trace:
> [    3.095810]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.096233]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.096684]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.097125]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.097535]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.097962]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.098413]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.098863]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.099350] BUG: scheduling while atomic: kthreadd/2/0x00000261
> [    3.099846] INFO: lockdep is turned off.
> [    3.100182] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.100814] 
> [    3.100947] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.101674] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.102504]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.103163]  ffffffff810b88f7 0000000000000261 ffffffff81ff35e0 ffff88001344fef8
> [    3.103822]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.104475] Call Trace:
> [    3.104686]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.105114]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.105565]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.106004]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.106412]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.106838]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.107289]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.107734]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.108223] BUG: scheduling while atomic: kthreadd/2/0x00000267
> [    3.108712] INFO: lockdep is turned off.
> [    3.109044] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.109667] 
> [    3.109803] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.110540] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.111368]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.112025]  ffffffff810b88f7 0000000000000267 ffffffff81ff35e0 ffff88001344fef8
> [    3.112678]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.113337] Call Trace:
> [    3.113545]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.113974]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.114425]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.114866]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.115274]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.115697]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.116153]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.116600]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.117092] BUG: scheduling while atomic: kthreadd/2/0x0000026d
> [    3.117583] INFO: lockdep is turned off.
> [    3.117914] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    3.118538] 
> [    3.118671] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.119399] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.120240]  ffff88001236e198 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    3.120897]  ffffffff810b88f7 000000000000026d ffffffff81ff35e0 ffff88001344fef8
> [    3.121551]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    3.122212] Call Trace:
> [    3.122425]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.122871]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.123327]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.123767]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.124177]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    3.124600]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.125063]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.125521]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    3.126015] NET: Registered protocol family 38
> [    3.126392] Key type asymmetric registered
> [    3.126780] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> [    3.127387] ------------[ cut here ]------------
> [    3.127779] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    3.128528] initcall bsg_init+0x0/0x130 returned with preemption imbalance 
> [    3.129105] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.129829] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.130858] BUG: scheduling while atomic: rcuop/0/10/0x0000007d
> [    3.131350] INFO: lockdep is turned off.
> [    3.131678] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    3.132283] 
> [    3.132415] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.133141] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.133974]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    3.134632]  ffffffff810b88f7 000000000000007d ffffffff81ff6e40 ffff88001349fd98
> [    3.135291]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    3.135949] Call Trace:
> [    3.136160]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.136586]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.137043]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.137485]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.137912]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    3.138398]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    3.138897]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    3.139376]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    3.139859]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    3.140469]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.140888]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.141371]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.141822]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.142332]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    3.142995]  ffffffff8109b88b ffff88001344be58 0000000000000000 ffff88001236e118
> [    3.143657]  0000000000000000 ffffffff8212292f 0000000000000000 ffff88001344be88
> [    3.144319] Call Trace:
> [    3.144532]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.144964]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    3.145466]  [<ffffffff8212292f>] ? blk_scsi_ioctl_init+0x2c5/0x2c5
> [    3.145987]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    3.146464]  [<ffffffff82122a2b>] ? bsg_init+0xfc/0x130
> [    3.146902]  [<ffffffff8212292f>] ? blk_scsi_ioctl_init+0x2c5/0x2c5
> [    3.147423]  [<ffffffff8212292f>] ? blk_scsi_ioctl_init+0x2c5/0x2c5
> [    3.147946]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    3.148424]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    3.148939]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.149373]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    3.149803]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.150262]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.150739] BUG: scheduling while atomic: rcuop/0/10/0x00000087
> [    3.151237] INFO: lockdep is turned off.
> [    3.151566] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    3.152170] 
> [    3.152303] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.153038] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.153873]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    3.154531]  ffffffff810b88f7 0000000000000087 ffffffff81ff6e40 ffff88001349fd98
> [    3.155193]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    3.155855] Call Trace:
> [    3.156066]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.156494]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.156954]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.157395]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.157811]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    3.158295]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    3.158798]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    3.159285]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    3.159772]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    3.160372]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.160792]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.161274]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.161723]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.162210] ---[ end trace 16f8d1a3aab8fa2a ]---
> [    3.162596] io scheduler noop registered (default)
> [    3.163026] io scheduler cfq registered
> [    3.163349] start plist test
> [    3.164868] end plist test
> [    3.165526] test_string_helpers: Running tests...
> [    3.166119] BUG: scheduling while atomic: kdevtmpfs/14/0x0000008f
> [    3.166630] INFO: lockdep is turned off.
> [    3.166965] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    3.167612] 
> [    3.167745] CPU: 0 PID: 14 Comm: kdevtmpfs Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.168490] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.169330]  0000000000000000 ffff8800134c3d78 ffffffff81b5b203 ffff8800134c3d98
> [    3.169996]  ffffffff810b88f7 000000000000008f 0000000000000000 ffff8800134c3df8
> [    3.170669]  ffffffff81b5e5a5 ffff8800134c3de8 ffff8800134be000 ffff8800134c3fd8
> [    3.171330] Call Trace:
> [    3.171541]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.171972]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.172425]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.172869]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.173283]  [<ffffffff815b51f8>] devtmpfsd+0x158/0x170
> [    3.173716]  [<ffffffff815b50a0>] ? handle_create+0x1f0/0x1f0
> [    3.174194]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.174609]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.175094]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.175544]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.176053] test_firmware: interface ready
> [    3.176398] ------------[ cut here ]------------
> [    3.176789] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    3.177548] initcall test_firmware_init+0x0/0x79 returned with preemption imbalance 
> [    3.178185] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.178904] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.179729]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    3.180399]  ffffffff8109b88b ffffffff821244a4 0000000000000000 ffff88001236e008
> [    3.181059]  0000000000000000 ffffffff821244a4 0000000000000000 ffff88001344be88
> [    3.181701] BUG: scheduling while atomic: rcuop/0/10/0x00000089
> [    3.182220] INFO: lockdep is turned off.
> [    3.182549] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    3.183156] 
> [    3.183290] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.184023] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.184862]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    3.185521]  ffffffff810b88f7 0000000000000089 ffffffff81ff6e40 ffff88001349fd98
> [    3.186183]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    3.186846] Call Trace:
> [    3.187057]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.187485]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.187943]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.188384]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.188798]  [<ffffffff810ddb4e>] rcu_nocb_kthread+0x21e/0x5e0
> [    3.189279]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    3.189779]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    3.190274]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    3.190760]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    3.191347]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.191765]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.192250]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.192701]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.193194] 
> [    3.193328] Call Trace:
> [    3.193538]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.193969]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    3.194466]  [<ffffffff821244a4>] ? test_kstrtox_init+0x8ba/0x8ba
> [    3.194975]  [<ffffffff821244a4>] ? test_kstrtox_init+0x8ba/0x8ba
> [    3.195477]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    3.195956]  [<ffffffff821244a4>] ? test_kstrtox_init+0x8ba/0x8ba
> [    3.196458]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    3.196935]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    3.197445]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.197881]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    3.198306]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.198755]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.199188] ---[ end trace 16f8d1a3aab8fa2b ]---
> [    3.199826] crc32: CRC_LE_BITS = 64, CRC_BE BITS = 64
> [    3.200263] BUG: scheduling while atomic: rcuop/0/10/0x00000089
> [    3.200753] INFO: lockdep is turned off.
> [    3.201082] Preemption disabled at:[<ffffffff810c0b2f>] finish_wait+0x2f/0x70
> [    3.201680] 
> [    3.201817] CPU: 0 PID: 10 Comm: rcuop/0 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.202545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.203380]  ffffffff81ff6c00 ffff88001349fd18 ffffffff81b5b203 ffff88001349fd38
> [    3.204042]  ffffffff810b88f7 0000000000000089 ffffffff81ff6d88 ffff88001349fd98
> [    3.204698]  ffffffff81b5e5a5 ffff88001349fd68 ffff880013498000 ffff88001349ffd8
> [    3.205356] Call Trace:
> [    3.205566]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.205998]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    3.206452]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    3.206896]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    3.207310]  [<ffffffff810dda2d>] rcu_nocb_kthread+0xfd/0x5e0
> [    3.207789]  [<ffffffff810ddcd2>] ? rcu_nocb_kthread+0x3a2/0x5e0
> [    3.208285]  [<ffffffff810c7acd>] ? trace_hardirqs_on+0xd/0x10
> [    3.208770]  [<ffffffff810c0650>] ? __wake_up_common+0x90/0x90
> [    3.209253]  [<ffffffff810dd930>] ? rcu_report_exp_rnp+0xb0/0xb0
> [    3.209839]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    3.210262]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.210743]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.211196]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    3.211680] crc32: self tests passed, processed 225944 bytes in 122898 nsec
> [    3.212382] crc32c: CRC_LE_BITS = 64
> [    3.212680] crc32c: self tests passed, processed 225944 bytes in 62973 nsec
> [    3.224391] crc32_combine: 8373 self tests passed
> [    3.235943] crc32c_combine: 8373 self tests passed
> [    3.236409] ------------[ cut here ]------------
> [    3.236806] WARNING: CPU: 0 PID: 1 at init/main.c:803 do_one_initcall+0x179/0x1a6()
> [    3.237563] initcall err_inject_init+0x0/0x24 returned with preemption imbalance 
> [    3.238184] CPU: 0 PID: 1 Comm: swapper Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    3.238911] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    3.239743]  0000000000000009 ffff88001344bde8 ffffffff81b5b203 ffff88001344be28
> [    3.240415]  ffffffff8109b88b 00000015414c42bd 0000000000000000 ffff88001236e078
> [    3.241077]  0000000000000000 ffffffff82124ef0 0000000000000000 ffff88001344be88
> [    3.241740] Call Trace:
> [    3.241954]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    3.242380]  [<ffffffff8109b88b>] warn_slowpath_common+0x6b/0x90
> [    3.242878]  [<ffffffff82124ef0>] ? swiotlb_free+0x173/0x173
> [    3.243344]  [<ffffffff8109b911>] warn_slowpath_fmt+0x41/0x50
> [    3.243820]  [<ffffffff82124ef0>] ? swiotlb_free+0x173/0x173
> [    3.244288]  [<ffffffff82124ef0>] ? swiotlb_free+0x173/0x173
> [    3.244758]  [<ffffffff82105009>] do_one_initcall+0x179/0x1a6
> [    3.245232]  [<ffffffff8210514b>] kernel_init_freeable+0x115/0x19d
> [    3.245740]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.246174]  [<ffffffff81b55da9>] kernel_init+0x9/0xe0
> [    3.246600]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    3.247049]  [<ffffffff81b55da0>] ? rest_init+0xc0/0xc0
> [    3.247481] ---[ end trace 16f8d1a3aab8fa2c ]---
> [    3.247870] rbtree testing -> 18491 cycles
> [    3.923788] augmented rbtree testing
> [    4.050027] BUG: scheduling while atomic: kworker/0:1/22/0x000001e2
> [    4.050831] INFO: lockdep is turned off.
> [    4.051161] Preemption disabled at:[<ffffffff8116f2c1>] mntput_no_expire+0x11/0x230
> [    4.051810] 
> [    4.051943] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    4.052697] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    4.053534] Workqueue: events clocksource_watchdog_work
> [    4.053983]  ffff8800135afc58 ffff8800135afa58 ffffffff81b5b203 ffff8800135afa78
> [    4.054640]  ffffffff810b88f7 00000000000001e2 7fffffffffffffff ffff8800135afad8
> [    4.055302]  ffffffff81b5e5a5 ffffffff82eadd40 ffff8800135a8000 ffff8800135affd8
> [    4.055966] Call Trace:
> [    4.056179]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    4.056607]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    4.057065]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    4.057505]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    4.057919]  [<ffffffff81b62e15>] schedule_timeout+0x1b5/0x230
> [    4.058400]  [<ffffffff81b5fa83>] ? wait_for_completion_killable+0x33/0x1e0
> [    4.058976]  [<ffffffff810be4b2>] ? check_preempt_wakeup+0xb2/0x1a0
> [    4.059491]  [<ffffffff81b5fb2f>] wait_for_completion_killable+0xdf/0x1e0
> [    4.060062]  [<ffffffff810b9b50>] ? sched_fork+0x1f0/0x1f0
> [    4.060521]  [<ffffffff810eab60>] ? __clocksource_watchdog_kthread+0x180/0x180
> [    4.061117]  [<ffffffff810b4bf1>] kthread_create_on_node+0x161/0x230
> [    4.061641]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    4.062136]  [<ffffffff810ea9c0>] clocksource_watchdog_work+0x20/0x40
> [    4.062665]  [<ffffffff810af69a>] process_one_work+0x19a/0x460
> [    4.063151]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    4.063643]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    4.064096]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    4.064588]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    4.065003]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    4.065482]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    4.065930]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    4.066439] BUG: scheduling while atomic: kthreadd/2/0x00000273
> [    4.066932] INFO: lockdep is turned off.
> [    4.067258] Preemption disabled at:[<ffffffff810995a2>] copy_process+0x672/0x1ab0
> [    4.067889] 
> [    4.068022] CPU: 0 PID: 2 Comm: kthreadd Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    4.068744] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    4.069572]  ffff88001236e0c8 ffff88001344fe78 ffffffff81b5b203 ffff88001344fe98
> [    4.070240]  ffffffff810b88f7 0000000000000273 ffffffff81ff35e0 ffff88001344fef8
> [    4.070897]  ffffffff81b5e5a5 ffff88001344fee8 ffff880013446000 ffff88001344ffd8
> [    4.071546] Call Trace:
> [    4.071757]  [<ffffffff81b5b203>] dump_stack+0x19/0x1b
> [    4.072185]  [<ffffffff810b88f7>] __schedule_bug+0x67/0xc0
> [    4.072639]  [<ffffffff81b5e5a5>] __schedule+0x4a5/0x650
> [    4.073080]  [<ffffffff81b5e773>] schedule+0x23/0x60
> [    4.073489]  [<ffffffff810b4f2a>] kthreadd+0x11a/0x120
> [    4.073915]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    4.074366]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    4.074813]  [<ffffffff810b4e10>] ? kthread_stop+0x70/0x70
> [    4.090020] ------------[ cut here ]------------
> [    4.090404] kernel BUG at kernel/sched/core.c:3415!
> [    4.090932] invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
> [    4.091439] CPU: 0 PID: 22 Comm: kworker/0:1 Tainted: G        W      3.18.0-rc6-00066-gaee27dfb #526
> [    4.092188] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [    4.093014] Workqueue: events clocksource_watchdog_work
> [    4.093456] task: ffff8800135a8000 ti: ffff8800135ac000 task.ti: ffff8800135ac000
> [    4.094071] RIP: 0010:[<ffffffff810ba5a8>]  [<ffffffff810ba5a8>] __sched_setscheduler+0x568/0x700
> [    4.094810] RSP: 0000:ffff8800135afb78  EFLAGS: 00010206
> [    4.095245] RAX: 00000000800001e1 RBX: ffff88001236e0c8 RCX: 0000000000000000
> [    4.095828] RDX: 0000000000000000 RSI: ffff8800135afbe8 RDI: ffff880012376000
> [    4.096407] RBP: ffff8800135afbd8 R08: 0000000000000000 R09: 0000000000000000
> [    4.096988] R10: ffff880012376000 R11: 0000000000000000 R12: 0000000000000000
> [    4.097569] R13: ffff8800135afbe8 R14: 0000000000000063 R15: ffff880012376000
> [    4.098153] FS:  0000000000000000(0000) GS:ffffffff81fd4000(0000) knlGS:0000000000000000
> [    4.098813] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    4.099285] CR2: 0000000000000138 CR3: 0000000001fc4000 CR4: 00000000000006f0
> [    4.099872] Stack:
> [    4.100005]  ffff8800135afc58 ffff8800135afc50 ffff8800135a8000 ffffffff81e9703b
> [    4.100005]  ffff880012376540 ffff880012376550 ffff8800135afc28 ffff88001236e0c8
> [    4.100005]  ffff880012376000 00000000ffffffff 0000000000000000 ffffffff81e9703b
> [    4.100005] Call Trace:
> [    4.100005]  [<ffffffff810ba79f>] _sched_setscheduler+0x5f/0x70
> [    4.100005]  [<ffffffff810baa2b>] sched_setscheduler_nocheck+0xb/0x10
> [    4.100005]  [<ffffffff810b4c53>] kthread_create_on_node+0x1c3/0x230
> [    4.100005]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    4.100005]  [<ffffffff810ea9c0>] clocksource_watchdog_work+0x20/0x40
> [    4.100005]  [<ffffffff810af69a>] process_one_work+0x19a/0x460
> [    4.100005]  [<ffffffff810af63e>] ? process_one_work+0x13e/0x460
> [    4.100005]  [<ffffffff810af9c3>] worker_thread+0x63/0x490
> [    4.100005]  [<ffffffff810af960>] ? process_one_work+0x460/0x460
> [    4.100005]  [<ffffffff810b48cd>] kthread+0xfd/0x120
> [    4.100005]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    4.100005]  [<ffffffff81b6493a>] ret_from_fork+0x7a/0xb0
> [    4.100005]  [<ffffffff810b47d0>] ? __kthread_unpark+0x30/0x30
> [    4.100005] Code: 49 8b 55 18 48 83 fa ff 0f 84 a8 01 00 00 0f 1f 44 00 00 48 89 d0 31 d2 48 c1 e0 14 48 f7 f6 e9 6e fd ff ff 0f 1f 80 00 00 00 00 <0f> 0b 66 0f 1f 44 00 00 41 8b 47 20 39 45 b4 75 0b c1 e8 1f 84 
> [    4.100005] RIP  [<ffffffff810ba5a8>] __sched_setscheduler+0x568/0x700
> [    4.100005]  RSP <ffff8800135afb78>
> [    4.111778] ---[ end trace 16f8d1a3aab8fa2d ]---
> [    4.112163] Kernel panic - not syncing: Fatal exception in interrupt
> [    4.112684] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
> 
> Elapsed time: 5
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/x86_64-randconfig-r0-12011352/aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d/vmlinuz-3.18.0-rc6-00066-gaee27dfb -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/x86_64-randconfig-r0-12011352/rcu:Fraga1.2014.12.02a:aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d:bisect-linux-8/.vmlinuz-aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d-20141203043402-5-client8 branch=rcu/Fraga1.2014.12.02a BOOT_IMAGE=/kernel/x86_64-randconfig-r0-12011352/aee27dfbc1ecaf37e14ce4a7db3845d2cb2a799d/vmlinuz-3.18.0-rc6-00066-gaee27dfb drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz -m 320 -smp 1 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-yocto-client8-15 -serial file:/dev/shm/kboot/serial-yocto-client8-15 -daemonize -display none -monitor null 

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 3.18.0-rc6 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_PERF_EVENTS_INTEL_UNCORE=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_CONSTRUCTORS=y
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> CONFIG_KERNEL_BZIP2=y
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> CONFIG_FHANDLE=y
> CONFIG_USELIB=y
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> # CONFIG_AUDITSYSCALL is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_VIRT_CPU_ACCOUNTING=y
> # CONFIG_TICK_CPU_ACCOUNTING is not set
> CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> CONFIG_BSD_PROCESS_ACCT=y
> CONFIG_BSD_PROCESS_ACCT_V3=y
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_PREEMPT_RCU=y
> # CONFIG_TASKS_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_CONTEXT_TRACKING_FORCE=y
> CONFIG_RCU_FANOUT=64
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_BOOST is not set
> CONFIG_RCU_NOCB_CPU=y
> # CONFIG_RCU_NOCB_CPU_NONE is not set
> # CONFIG_RCU_NOCB_CPU_ZERO is not set
> CONFIG_RCU_NOCB_CPU_ALL=y
> CONFIG_BUILD_BIN2C=y
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> # CONFIG_CGROUPS is not set
> CONFIG_CHECKPOINT_RESTORE=y
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> # CONFIG_RD_LZ4 is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_BPF=y
> CONFIG_EXPERT=y
> CONFIG_SGETMASK_SYSCALL=y
> # CONFIG_SYSFS_SYSCALL is not set
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> # CONFIG_EPOLL is not set
> # CONFIG_SIGNALFD is not set
> # CONFIG_TIMERFD is not set
> # CONFIG_EVENTFD is not set
> # CONFIG_BPF_SYSCALL is not set
> # CONFIG_SHMEM is not set
> CONFIG_AIO=y
> # CONFIG_ADVISE_SYSCALLS is not set
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> # CONFIG_SLUB is not set
> CONFIG_SLOB=y
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> CONFIG_CC_STACKPROTECTOR_REGULAR=y
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> 
> #
> # GCOV-based kernel profiling
> #
> CONFIG_GCOV_KERNEL=y
> # CONFIG_GCOV_PROFILE_ALL is not set
> CONFIG_GCOV_FORMAT_AUTODETECT=y
> # CONFIG_GCOV_FORMAT_3_4 is not set
> # CONFIG_GCOV_FORMAT_4_7 is not set
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> # CONFIG_BLK_DEV_INTEGRITY is not set
> # CONFIG_BLK_CMDLINE_PARSER is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> CONFIG_ACORN_PARTITION=y
> CONFIG_ACORN_PARTITION_CUMANA=y
> CONFIG_ACORN_PARTITION_EESOX=y
> CONFIG_ACORN_PARTITION_ICS=y
> CONFIG_ACORN_PARTITION_ADFS=y
> CONFIG_ACORN_PARTITION_POWERTEC=y
> CONFIG_ACORN_PARTITION_RISCIX=y
> CONFIG_AIX_PARTITION=y
> CONFIG_OSF_PARTITION=y
> CONFIG_AMIGA_PARTITION=y
> CONFIG_ATARI_PARTITION=y
> CONFIG_MAC_PARTITION=y
> # CONFIG_MSDOS_PARTITION is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> CONFIG_SUN_PARTITION=y
> # CONFIG_KARMA_PARTITION is not set
> # CONFIG_EFI_PARTITION is not set
> # CONFIG_SYSV68_PARTITION is not set
> # CONFIG_CMDLINE_PARTITION is not set
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> # CONFIG_IOSCHED_DEADLINE is not set
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_CFQ is not set
> CONFIG_DEFAULT_NOOP=y
> CONFIG_DEFAULT_IOSCHED="noop"
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> CONFIG_ARCH_USE_QUEUE_RWLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> # CONFIG_SMP is not set
> CONFIG_X86_FEATURE_NAMES=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> # CONFIG_X86_GOLDFISH is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_IOSF_MBI is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> # CONFIG_CPU_SUP_CENTAUR is not set
> CONFIG_HPET_TIMER=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> # CONFIG_CALGARY_IOMMU is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_NR_CPUS=1
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> CONFIG_X86_MCE=y
> CONFIG_X86_MCE_INTEL=y
> CONFIG_X86_MCE_AMD=y
> CONFIG_X86_MCE_THRESHOLD=y
> CONFIG_X86_MCE_INJECT=y
> CONFIG_X86_THERMAL_VECTOR=y
> # CONFIG_X86_16BIT is not set
> CONFIG_I8K=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> CONFIG_MICROCODE_AMD_EARLY=y
> CONFIG_MICROCODE_EARLY=y
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_DIRECT_GBPAGES is not set
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> # CONFIG_BOUNCE is not set
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_MEMORY_FAILURE is not set
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> CONFIG_CMA_AREAS=7
> CONFIG_MEM_SOFT_DIRTY=y
> # CONFIG_ZPOOL is not set
> CONFIG_ZBUD=y
> CONFIG_ZSMALLOC=y
> # CONFIG_PGTABLE_MAPPING is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MTRR is not set
> CONFIG_ARCH_RANDOM=y
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> CONFIG_HZ_100=y
> # CONFIG_HZ_250 is not set
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=100
> CONFIG_SCHED_HRTICK=y
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> # CONFIG_PM_RUNTIME is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
> CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_VIDEO is not set
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> CONFIG_HAVE_ACPI_APEI=y
> CONFIG_HAVE_ACPI_APEI_NMI=y
> # CONFIG_ACPI_APEI is not set
> # CONFIG_ACPI_EXTLOG is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_GOV_LADDER is not set
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Memory power savings
> #
> CONFIG_I7300_IDLE_IOAT_CHANNEL=y
> CONFIG_I7300_IDLE=y
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DIRECT=y
> # CONFIG_PCI_MMCONFIG is not set
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_AMD_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=y
> # CONFIG_COREDUMP is not set
> # CONFIG_IA32_EMULATION is not set
> CONFIG_X86_DEV_DMA_OPS=y
> CONFIG_PMC_ATOM=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> # CONFIG_PACKET is not set
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=y
> CONFIG_XFRM_USER=y
> CONFIG_XFRM_SUB_POLICY=y
> CONFIG_XFRM_MIGRATE=y
> CONFIG_XFRM_STATISTICS=y
> CONFIG_XFRM_IPCOMP=y
> CONFIG_NET_KEY=y
> CONFIG_NET_KEY_MIGRATE=y
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_ROUTE_CLASSID=y
> CONFIG_IP_PNP=y
> CONFIG_IP_PNP_DHCP=y
> CONFIG_IP_PNP_BOOTP=y
> # CONFIG_IP_PNP_RARP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE_DEMUX is not set
> CONFIG_NET_IP_TUNNEL=y
> CONFIG_IP_MROUTE=y
> CONFIG_IP_PIMSM_V1=y
> # CONFIG_IP_PIMSM_V2 is not set
> CONFIG_SYN_COOKIES=y
> CONFIG_NET_IPVTI=y
> CONFIG_NET_UDP_TUNNEL=y
> CONFIG_NET_FOU=y
> # CONFIG_GENEVE is not set
> CONFIG_INET_AH=y
> CONFIG_INET_ESP=y
> CONFIG_INET_IPCOMP=y
> CONFIG_INET_XFRM_TUNNEL=y
> CONFIG_INET_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> # CONFIG_INET_XFRM_MODE_BEET is not set
> CONFIG_INET_LRO=y
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> CONFIG_INET_UDP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_ROUTER_PREF=y
> # CONFIG_IPV6_ROUTE_INFO is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> CONFIG_INET6_AH=y
> CONFIG_INET6_ESP=y
> # CONFIG_INET6_IPCOMP is not set
> CONFIG_IPV6_MIP6=y
> # CONFIG_INET6_XFRM_TUNNEL is not set
> # CONFIG_INET6_TUNNEL is not set
> CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
> CONFIG_INET6_XFRM_MODE_BEET=y
> # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> # CONFIG_IPV6_SIT is not set
> # CONFIG_IPV6_TUNNEL is not set
> # CONFIG_IPV6_GRE is not set
> CONFIG_IPV6_MULTIPLE_TABLES=y
> # CONFIG_IPV6_SUBTREES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_NETLABEL is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NET_PTP_CLASSIFY is not set
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> # CONFIG_NETFILTER_ADVANCED is not set
> 
> #
> # Core Netfilter Configuration
> #
> CONFIG_NETFILTER_NETLINK=y
> CONFIG_NETFILTER_NETLINK_LOG=y
> # CONFIG_NF_CONNTRACK is not set
> CONFIG_NF_LOG_COMMON=y
> CONFIG_NF_TABLES=y
> CONFIG_NF_TABLES_INET=y
> CONFIG_NFT_EXTHDR=y
> CONFIG_NFT_META=y
> # CONFIG_NFT_RBTREE is not set
> # CONFIG_NFT_HASH is not set
> CONFIG_NFT_COUNTER=y
> CONFIG_NFT_LOG=y
> # CONFIG_NFT_LIMIT is not set
> CONFIG_NFT_REJECT=y
> CONFIG_NFT_REJECT_INET=y
> CONFIG_NFT_COMPAT=y
> CONFIG_NETFILTER_XTABLES=y
> 
> #
> # Xtables combined modules
> #
> CONFIG_NETFILTER_XT_MARK=y
> 
> #
> # Xtables targets
> #
> CONFIG_NETFILTER_XT_TARGET_LOG=y
> CONFIG_NETFILTER_XT_TARGET_NFLOG=y
> CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
> 
> #
> # Xtables matches
> #
> CONFIG_NETFILTER_XT_MATCH_POLICY=y
> # CONFIG_IP_SET is not set
> CONFIG_IP_VS=y
> # CONFIG_IP_VS_IPV6 is not set
> # CONFIG_IP_VS_DEBUG is not set
> CONFIG_IP_VS_TAB_BITS=12
> 
> #
> # IPVS transport protocol load balancing support
> #
> CONFIG_IP_VS_PROTO_TCP=y
> CONFIG_IP_VS_PROTO_UDP=y
> CONFIG_IP_VS_PROTO_AH_ESP=y
> CONFIG_IP_VS_PROTO_ESP=y
> # CONFIG_IP_VS_PROTO_AH is not set
> # CONFIG_IP_VS_PROTO_SCTP is not set
> 
> #
> # IPVS scheduler
> #
> CONFIG_IP_VS_RR=y
> # CONFIG_IP_VS_WRR is not set
> # CONFIG_IP_VS_LC is not set
> # CONFIG_IP_VS_WLC is not set
> # CONFIG_IP_VS_FO is not set
> CONFIG_IP_VS_LBLC=y
> # CONFIG_IP_VS_LBLCR is not set
> # CONFIG_IP_VS_DH is not set
> CONFIG_IP_VS_SH=y
> CONFIG_IP_VS_SED=y
> CONFIG_IP_VS_NQ=y
> 
> #
> # IPVS SH scheduler
> #
> CONFIG_IP_VS_SH_TAB_BITS=8
> 
> #
> # IPVS application helper
> #
> 
> #
> # IP: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV4 is not set
> CONFIG_NF_LOG_ARP=y
> CONFIG_NF_LOG_IPV4=y
> CONFIG_NF_TABLES_IPV4=y
> # CONFIG_NFT_CHAIN_ROUTE_IPV4 is not set
> CONFIG_NF_REJECT_IPV4=y
> CONFIG_NFT_REJECT_IPV4=y
> # CONFIG_NF_TABLES_ARP is not set
> # CONFIG_IP_NF_IPTABLES is not set
> 
> #
> # IPv6: Netfilter Configuration
> #
> # CONFIG_NF_DEFRAG_IPV6 is not set
> CONFIG_NF_TABLES_IPV6=y
> # CONFIG_NFT_CHAIN_ROUTE_IPV6 is not set
> CONFIG_NF_REJECT_IPV6=y
> CONFIG_NFT_REJECT_IPV6=y
> CONFIG_NF_LOG_IPV6=y
> # CONFIG_IP6_NF_IPTABLES is not set
> # CONFIG_NF_TABLES_BRIDGE is not set
> # CONFIG_BRIDGE_NF_EBTABLES is not set
> CONFIG_IP_DCCP=y
> CONFIG_INET_DCCP_DIAG=y
> 
> #
> # DCCP CCIDs Configuration
> #
> CONFIG_IP_DCCP_CCID2_DEBUG=y
> CONFIG_IP_DCCP_CCID3=y
> CONFIG_IP_DCCP_CCID3_DEBUG=y
> CONFIG_IP_DCCP_TFRC_LIB=y
> CONFIG_IP_DCCP_TFRC_DEBUG=y
> 
> #
> # DCCP Kernel Hacking
> #
> # CONFIG_IP_DCCP_DEBUG is not set
> CONFIG_IP_SCTP=y
> # CONFIG_SCTP_DBG_OBJCNT is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
> # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
> CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE=y
> CONFIG_SCTP_COOKIE_HMAC_MD5=y
> # CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> CONFIG_L2TP=y
> CONFIG_L2TP_DEBUGFS=y
> CONFIG_L2TP_V3=y
> CONFIG_L2TP_IP=y
> CONFIG_L2TP_ETH=y
> CONFIG_STP=y
> CONFIG_GARP=y
> CONFIG_MRP=y
> CONFIG_BRIDGE=y
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> CONFIG_BRIDGE_VLAN_FILTERING=y
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> CONFIG_DECNET=y
> CONFIG_DECNET_ROUTER=y
> CONFIG_LLC=y
> # CONFIG_LLC2 is not set
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> CONFIG_IPDDP=y
> # CONFIG_IPDDP_ENCAP is not set
> # CONFIG_X25 is not set
> CONFIG_LAPB=y
> # CONFIG_PHONET is not set
> # CONFIG_6LOWPAN is not set
> # CONFIG_IEEE802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> CONFIG_NET_SCH_HTB=y
> CONFIG_NET_SCH_HFSC=y
> # CONFIG_NET_SCH_PRIO is not set
> # CONFIG_NET_SCH_MULTIQ is not set
> CONFIG_NET_SCH_RED=y
> # CONFIG_NET_SCH_SFB is not set
> CONFIG_NET_SCH_SFQ=y
> # CONFIG_NET_SCH_TEQL is not set
> CONFIG_NET_SCH_TBF=y
> # CONFIG_NET_SCH_GRED is not set
> # CONFIG_NET_SCH_DSMARK is not set
> # CONFIG_NET_SCH_NETEM is not set
> CONFIG_NET_SCH_DRR=y
> CONFIG_NET_SCH_MQPRIO=y
> CONFIG_NET_SCH_CHOKE=y
> CONFIG_NET_SCH_QFQ=y
> # CONFIG_NET_SCH_CODEL is not set
> CONFIG_NET_SCH_FQ_CODEL=y
> CONFIG_NET_SCH_FQ=y
> CONFIG_NET_SCH_HHF=y
> CONFIG_NET_SCH_PIE=y
> # CONFIG_NET_SCH_INGRESS is not set
> CONFIG_NET_SCH_PLUG=y
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> # CONFIG_NET_CLS_BASIC is not set
> CONFIG_NET_CLS_TCINDEX=y
> CONFIG_NET_CLS_ROUTE4=y
> # CONFIG_NET_CLS_FW is not set
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> # CONFIG_CLS_U32_MARK is not set
> CONFIG_NET_CLS_RSVP=y
> # CONFIG_NET_CLS_RSVP6 is not set
> CONFIG_NET_CLS_FLOW=y
> CONFIG_NET_CLS_BPF=y
> # CONFIG_NET_EMATCH is not set
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> # CONFIG_NET_ACT_GACT is not set
> CONFIG_NET_ACT_MIRRED=y
> CONFIG_NET_ACT_NAT=y
> CONFIG_NET_ACT_PEDIT=y
> # CONFIG_NET_ACT_SIMP is not set
> CONFIG_NET_ACT_SKBEDIT=y
> CONFIG_NET_ACT_CSUM=y
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=y
> CONFIG_BATMAN_ADV_BLA=y
> CONFIG_BATMAN_ADV_DAT=y
> # CONFIG_BATMAN_ADV_NC is not set
> CONFIG_BATMAN_ADV_MCAST=y
> # CONFIG_BATMAN_ADV_DEBUG is not set
> CONFIG_OPENVSWITCH=y
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> CONFIG_NETLINK_DIAG=y
> # CONFIG_NET_MPLS_GSO is not set
> # CONFIG_HSR is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> CONFIG_NET_PKTGEN=y
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> # CONFIG_CAN_RAW is not set
> CONFIG_CAN_BCM=y
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> # CONFIG_CAN_VCAN is not set
> # CONFIG_CAN_SLCAN is not set
> CONFIG_CAN_DEV=y
> CONFIG_CAN_CALC_BITTIMING=y
> CONFIG_CAN_LEDS=y
> CONFIG_CAN_SJA1000=y
> # CONFIG_CAN_SJA1000_ISA is not set
> CONFIG_CAN_SJA1000_PLATFORM=y
> # CONFIG_CAN_EMS_PCI is not set
> # CONFIG_CAN_PEAK_PCI is not set
> # CONFIG_CAN_KVASER_PCI is not set
> # CONFIG_CAN_PLX_PCI is not set
> CONFIG_CAN_C_CAN=y
> CONFIG_CAN_C_CAN_PLATFORM=y
> # CONFIG_CAN_C_CAN_PCI is not set
> # CONFIG_CAN_M_CAN is not set
> # CONFIG_CAN_CC770 is not set
> 
> #
> # CAN SPI interfaces
> #
> CONFIG_CAN_MCP251X=y
> 
> #
> # CAN USB interfaces
> #
> # CONFIG_CAN_EMS_USB is not set
> # CONFIG_CAN_ESD_USB2 is not set
> # CONFIG_CAN_GS_USB is not set
> CONFIG_CAN_KVASER_USB=y
> # CONFIG_CAN_PEAK_USB is not set
> CONFIG_CAN_8DEV_USB=y
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> # CONFIG_IRDA is not set
> CONFIG_BT=y
> CONFIG_BT_RFCOMM=y
> # CONFIG_BT_RFCOMM_TTY is not set
> CONFIG_BT_BNEP=y
> CONFIG_BT_BNEP_MC_FILTER=y
> CONFIG_BT_BNEP_PROTO_FILTER=y
> CONFIG_BT_HIDP=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=y
> # CONFIG_BT_HCIUART is not set
> CONFIG_BT_HCIBCM203X=y
> CONFIG_BT_HCIBPA10X=y
> # CONFIG_BT_HCIBFUSB is not set
> CONFIG_BT_HCIVHCI=y
> CONFIG_BT_MRVL=y
> CONFIG_BT_ATH3K=y
> CONFIG_AF_RXRPC=y
> # CONFIG_AF_RXRPC_DEBUG is not set
> CONFIG_RXKAD=y
> CONFIG_FIB_RULES=y
> # CONFIG_WIRELESS is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> # CONFIG_RFKILL is not set
> CONFIG_RFKILL_REGULATOR=y
> CONFIG_NET_9P=y
> # CONFIG_NET_9P_DEBUG is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=y
> CONFIG_CAIF_USB=y
> CONFIG_CEPH_LIB=y
> # CONFIG_CEPH_LIB_PRETTYDEBUG is not set
> CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
> CONFIG_NFC=y
> CONFIG_NFC_DIGITAL=y
> CONFIG_NFC_NCI=y
> CONFIG_NFC_NCI_SPI=y
> CONFIG_NFC_HCI=y
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> # CONFIG_NFC_PN533 is not set
> CONFIG_NFC_TRF7970A=y
> CONFIG_NFC_SIM=y
> # CONFIG_NFC_PORT100 is not set
> CONFIG_NFC_PN544=y
> # CONFIG_NFC_PN544_I2C is not set
> CONFIG_NFC_MICROREAD=y
> # CONFIG_NFC_MICROREAD_I2C is not set
> CONFIG_NFC_MRVL=y
> # CONFIG_NFC_MRVL_USB is not set
> CONFIG_NFC_ST21NFCA=y
> # CONFIG_NFC_ST21NFCA_I2C is not set
> CONFIG_NFC_ST21NFCB=y
> CONFIG_NFC_ST21NFCB_I2C=y
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
> # CONFIG_ALLOW_DEV_COREDUMP is not set
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> CONFIG_FENCE_TRACE=y
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> # CONFIG_MTD is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT=y
> # CONFIG_PARPORT_PC is not set
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_ZRAM is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> CONFIG_BLK_DEV_DRBD=y
> # CONFIG_DRBD_FAULT_INJECTION is not set
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SKD is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> CONFIG_CDROM_PKTCDVD_WCACHE=y
> CONFIG_ATA_OVER_ETH=y
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RBD=y
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> CONFIG_AD525X_DPOT=y
> CONFIG_AD525X_DPOT_I2C=y
> CONFIG_AD525X_DPOT_SPI=y
> CONFIG_DUMMY_IRQ=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=y
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> # CONFIG_ISL29003 is not set
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> # CONFIG_SENSORS_BH1770 is not set
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> # CONFIG_DS1682 is not set
> # CONFIG_TI_DAC7512 is not set
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> CONFIG_BMP085_SPI=y
> CONFIG_USB_SWITCH_FSA9480=y
> # CONFIG_LATTICE_ECP3_CONFIG is not set
> CONFIG_SRAM=y
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> # CONFIG_EEPROM_93CX6 is not set
> CONFIG_EEPROM_93XX46=y
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_INTEL_MEI_TXE is not set
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Bus Driver
> #
> # CONFIG_INTEL_MIC_BUS is not set
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_GENWQE is not set
> CONFIG_ECHO=y
> # CONFIG_CXL_BASE is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_BLK_DEV_IDE_SATA=y
> CONFIG_IDE_GD=y
> CONFIG_IDE_GD_ATA=y
> CONFIG_IDE_GD_ATAPI=y
> CONFIG_BLK_DEV_IDECD=y
> # CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS is not set
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> # CONFIG_IDE_PROC_FS is not set
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> CONFIG_BLK_DEV_PLATFORM=y
> CONFIG_BLK_DEV_CMD640=y
> CONFIG_BLK_DEV_CMD640_ENHANCED=y
> # CONFIG_BLK_DEV_IDEPNP is not set
> 
> #
> # PCI IDE chipsets support
> #
> # CONFIG_BLK_DEV_GENERIC is not set
> # CONFIG_BLK_DEV_OPTI621 is not set
> # CONFIG_BLK_DEV_RZ1000 is not set
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_PIIX is not set
> # CONFIG_BLK_DEV_IT8172 is not set
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SIS5513 is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> # CONFIG_BLK_DEV_IDEDMA is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_MQ_DEFAULT is not set
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> CONFIG_BLK_DEV_SR=y
> CONFIG_BLK_DEV_SR_VENDOR=y
> CONFIG_CHR_DEV_SG=y
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_ENCLOSURE=y
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> # CONFIG_SCSI_SAS_ATA is not set
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> CONFIG_SCSI_DH_HP_SW=y
> # CONFIG_SCSI_DH_EMC is not set
> # CONFIG_SCSI_DH_ALUA is not set
> CONFIG_SCSI_OSD_INITIATOR=y
> # CONFIG_SCSI_OSD_ULD is not set
> CONFIG_SCSI_OSD_DPRINT_SENSE=1
> CONFIG_SCSI_OSD_DEBUG=y
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> # CONFIG_ATA_VERBOSE_ERROR is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> # CONFIG_ATA_BMDMA is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> CONFIG_PATA_PLATFORM=y
> # CONFIG_PATA_RZ1000 is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_LEGACY is not set
> # CONFIG_MD is not set
> CONFIG_TARGET_CORE=y
> # CONFIG_TCM_IBLOCK is not set
> # CONFIG_TCM_FILEIO is not set
> CONFIG_TCM_PSCSI=y
> CONFIG_TCM_USER=y
> # CONFIG_LOOPBACK_TARGET is not set
> # CONFIG_ISCSI_TARGET is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> # CONFIG_NETDEVICES is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5588=y
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> CONFIG_KEYBOARD_QT2160=y
> CONFIG_KEYBOARD_LKKBD=y
> # CONFIG_KEYBOARD_TCA6416 is not set
> CONFIG_KEYBOARD_TCA8418=y
> CONFIG_KEYBOARD_LM8323=y
> CONFIG_KEYBOARD_LM8333=y
> CONFIG_KEYBOARD_MAX7359=y
> CONFIG_KEYBOARD_MCS=y
> # CONFIG_KEYBOARD_MPR121 is not set
> CONFIG_KEYBOARD_NEWTON=y
> CONFIG_KEYBOARD_OPENCORES=y
> CONFIG_KEYBOARD_STOWAWAY=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> CONFIG_KEYBOARD_TWL4030=y
> CONFIG_KEYBOARD_XTKBD=y
> CONFIG_KEYBOARD_CROS_EC=y
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> CONFIG_INPUT_TABLET=y
> # CONFIG_TABLET_USB_ACECAD is not set
> # CONFIG_TABLET_USB_AIPTEK is not set
> CONFIG_TABLET_USB_GTCO=y
> CONFIG_TABLET_USB_HANWANG=y
> # CONFIG_TABLET_USB_KBTAB is not set
> # CONFIG_TABLET_SERIAL_WACOM4 is not set
> CONFIG_INPUT_TOUCHSCREEN=y
> CONFIG_TOUCHSCREEN_88PM860X=y
> # CONFIG_TOUCHSCREEN_ADS7846 is not set
> CONFIG_TOUCHSCREEN_AD7877=y
> CONFIG_TOUCHSCREEN_AD7879=y
> CONFIG_TOUCHSCREEN_AD7879_I2C=y
> # CONFIG_TOUCHSCREEN_AD7879_SPI is not set
> CONFIG_TOUCHSCREEN_ATMEL_MXT=y
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
> CONFIG_TOUCHSCREEN_CYTTSP4_I2C=y
> CONFIG_TOUCHSCREEN_CYTTSP4_SPI=y
> CONFIG_TOUCHSCREEN_DA9052=y
> CONFIG_TOUCHSCREEN_DYNAPRO=y
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> CONFIG_TOUCHSCREEN_EETI=y
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> CONFIG_TOUCHSCREEN_ILI210X=y
> # CONFIG_TOUCHSCREEN_GUNZE is not set
> # CONFIG_TOUCHSCREEN_ELO is not set
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> # CONFIG_TOUCHSCREEN_WACOM_I2C is not set
> CONFIG_TOUCHSCREEN_MAX11801=y
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> CONFIG_TOUCHSCREEN_MMS114=y
> # CONFIG_TOUCHSCREEN_MTOUCH is not set
> CONFIG_TOUCHSCREEN_INEXIO=y
> CONFIG_TOUCHSCREEN_MK712=y
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> CONFIG_TOUCHSCREEN_EDT_FT5X06=y
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> CONFIG_TOUCHSCREEN_TOUCHWIN=y
> CONFIG_TOUCHSCREEN_PIXCIR=y
> CONFIG_TOUCHSCREEN_WM831X=y
> # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> CONFIG_TOUCHSCREEN_MC13783=y
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> CONFIG_TOUCHSCREEN_TSC_SERIO=y
> # CONFIG_TOUCHSCREEN_TSC2005 is not set
> CONFIG_TOUCHSCREEN_TSC2007=y
> CONFIG_TOUCHSCREEN_ST1232=y
> CONFIG_TOUCHSCREEN_SUR40=y
> CONFIG_TOUCHSCREEN_TPS6507X=y
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=y
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_N_GSM is not set
> # CONFIG_TRACE_SINK is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> # CONFIG_SERIAL_8250_EXTENDED is not set
> # CONFIG_SERIAL_8250_DW is not set
> # CONFIG_SERIAL_8250_FINTEK is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MAX3100 is not set
> # CONFIG_SERIAL_MAX310X is not set
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_SC16IS7XX is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_MEN_Z135 is not set
> # CONFIG_TTY_PRINTK is not set
> CONFIG_PRINTER=y
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=y
> CONFIG_IPMI_HANDLER=y
> CONFIG_IPMI_PANIC_EVENT=y
> # CONFIG_IPMI_PANIC_STRING is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
> # CONFIG_IPMI_WATCHDOG is not set
> CONFIG_IPMI_POWEROFF=y
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_HW_RANDOM_TPM is not set
> CONFIG_NVRAM=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_ATMEL=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> # CONFIG_TCG_TIS_I2C_NUVOTON is not set
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> # CONFIG_XILLYBUS is not set
> 
> #
> # I2C support
> #
> CONFIG_I2C=y
> CONFIG_ACPI_I2C_OPREGION=y
> CONFIG_I2C_BOARDINFO=y
> # CONFIG_I2C_COMPAT is not set
> # CONFIG_I2C_CHARDEV is not set
> # CONFIG_I2C_MUX is not set
> # CONFIG_I2C_HELPER_AUTO is not set
> CONFIG_I2C_SMBUS=y
> 
> #
> # I2C Algorithms
> #
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCF=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_DIOLAN_U2C is not set
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> CONFIG_I2C_VIPERBOARD=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_CROS_EC_TUNNEL=y
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> CONFIG_SPI_DEBUG=y
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> # CONFIG_SPI_ALTERA is not set
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> # CONFIG_SPI_LM70_LLP is not set
> # CONFIG_SPI_PXA2XX is not set
> # CONFIG_SPI_PXA2XX_PCI is not set
> CONFIG_SPI_SC18IS602=y
> CONFIG_SPI_XCOMM=y
> CONFIG_SPI_XILINX=y
> CONFIG_SPI_DESIGNWARE=y
> # CONFIG_SPI_DW_PCI is not set
> # CONFIG_SPI_DW_MMIO is not set
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> CONFIG_SPI_TLE62X0=y
> CONFIG_SPMI=y
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> # CONFIG_PPS_CLIENT_LDISC is not set
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> CONFIG_W1=y
> # CONFIG_W1_CON is not set
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> # CONFIG_W1_MASTER_DS2482 is not set
> # CONFIG_W1_MASTER_DS1WM is not set
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> CONFIG_W1_SLAVE_SMEM=y
> CONFIG_W1_SLAVE_DS2408=y
> # CONFIG_W1_SLAVE_DS2408_READBACK is not set
> # CONFIG_W1_SLAVE_DS2413 is not set
> # CONFIG_W1_SLAVE_DS2406 is not set
> CONFIG_W1_SLAVE_DS2423=y
> CONFIG_W1_SLAVE_DS2431=y
> # CONFIG_W1_SLAVE_DS2433 is not set
> CONFIG_W1_SLAVE_DS2760=y
> # CONFIG_W1_SLAVE_DS2780 is not set
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> # CONFIG_W1_SLAVE_BQ27000 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> # CONFIG_WM831X_BACKUP is not set
> # CONFIG_WM831X_POWER is not set
> CONFIG_WM8350_POWER=y
> CONFIG_TEST_POWER=y
> # CONFIG_BATTERY_88PM860X is not set
> CONFIG_BATTERY_DS2760=y
> # CONFIG_BATTERY_DS2780 is not set
> CONFIG_BATTERY_DS2781=y
> CONFIG_BATTERY_DS2782=y
> CONFIG_BATTERY_SBS=y
> CONFIG_BATTERY_BQ27x00=y
> # CONFIG_BATTERY_BQ27X00_I2C is not set
> # CONFIG_BATTERY_BQ27X00_PLATFORM is not set
> # CONFIG_BATTERY_DA9052 is not set
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> # CONFIG_BATTERY_TWL4030_MADC is not set
> CONFIG_BATTERY_RX51=y
> CONFIG_CHARGER_ISP1704=y
> CONFIG_CHARGER_MAX8903=y
> # CONFIG_CHARGER_TWL4030 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_MAX14577 is not set
> # CONFIG_CHARGER_MAX8998 is not set
> # CONFIG_CHARGER_BQ2415X is not set
> CONFIG_CHARGER_SMB347=y
> # CONFIG_POWER_RESET is not set
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7314=y
> # CONFIG_SENSORS_AD7414 is not set
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> CONFIG_SENSORS_ADM1029=y
> CONFIG_SENSORS_ADM1031=y
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> CONFIG_SENSORS_ADT7410=y
> # CONFIG_SENSORS_ADT7411 is not set
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> CONFIG_SENSORS_APPLESMC=y
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9052_ADC=y
> # CONFIG_SENSORS_I5K_AMB is not set
> CONFIG_SENSORS_F71805F=y
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=y
> # CONFIG_SENSORS_MC13783_ADC is not set
> CONFIG_SENSORS_FSCHMD=y
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_HIH6130=y
> # CONFIG_SENSORS_IBMAEM is not set
> CONFIG_SENSORS_IBMPEX=y
> # CONFIG_SENSORS_IIO_HWMON is not set
> # CONFIG_SENSORS_CORETEMP is not set
> # CONFIG_SENSORS_IT87 is not set
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_POWR1220=y
> # CONFIG_SENSORS_LINEAGE is not set
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> CONFIG_SENSORS_LTC4222=y
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4260=y
> CONFIG_SENSORS_LTC4261=y
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=y
> # CONFIG_SENSORS_MAX1619 is not set
> CONFIG_SENSORS_MAX1668=y
> CONFIG_SENSORS_MAX197=y
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> CONFIG_SENSORS_MAX6697=y
> # CONFIG_SENSORS_HTU21 is not set
> # CONFIG_SENSORS_MCP3021 is not set
> CONFIG_SENSORS_MENF21BMC_HWMON=y
> CONFIG_SENSORS_ADCXX=y
> CONFIG_SENSORS_LM63=y
> CONFIG_SENSORS_LM70=y
> CONFIG_SENSORS_LM73=y
> CONFIG_SENSORS_LM75=y
> CONFIG_SENSORS_LM77=y
> # CONFIG_SENSORS_LM78 is not set
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> # CONFIG_SENSORS_LM95245 is not set
> CONFIG_SENSORS_PC87360=y
> # CONFIG_SENSORS_PC87427 is not set
> CONFIG_SENSORS_NTC_THERMISTOR=y
> CONFIG_SENSORS_NCT6683=y
> # CONFIG_SENSORS_NCT6775 is not set
> CONFIG_SENSORS_PCF8591=y
> CONFIG_PMBUS=y
> CONFIG_SENSORS_PMBUS=y
> CONFIG_SENSORS_ADM1275=y
> CONFIG_SENSORS_LM25066=y
> CONFIG_SENSORS_LTC2978=y
> # CONFIG_SENSORS_MAX16064 is not set
> # CONFIG_SENSORS_MAX34440 is not set
> # CONFIG_SENSORS_MAX8688 is not set
> CONFIG_SENSORS_TPS40422=y
> # CONFIG_SENSORS_UCD9000 is not set
> CONFIG_SENSORS_UCD9200=y
> # CONFIG_SENSORS_ZL6100 is not set
> CONFIG_SENSORS_SHT21=y
> CONFIG_SENSORS_SHTC1=y
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> CONFIG_SENSORS_EMC1403=y
> CONFIG_SENSORS_EMC2103=y
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=y
> CONFIG_SENSORS_SCH5636=y
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_ADC128D818=y
> CONFIG_SENSORS_ADS1015=y
> CONFIG_SENSORS_ADS7828=y
> CONFIG_SENSORS_ADS7871=y
> # CONFIG_SENSORS_AMC6821 is not set
> CONFIG_SENSORS_INA209=y
> CONFIG_SENSORS_INA2XX=y
> CONFIG_SENSORS_THMC50=y
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP103=y
> CONFIG_SENSORS_TMP401=y
> # CONFIG_SENSORS_TMP421 is not set
> CONFIG_SENSORS_TWL4030_MADC=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=y
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=y
> # CONFIG_SENSORS_W83L786NG is not set
> CONFIG_SENSORS_W83627HF=y
> # CONFIG_SENSORS_W83627EHF is not set
> CONFIG_SENSORS_WM831X=y
> CONFIG_SENSORS_WM8350=y
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_BANG_BANG=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> CONFIG_THERMAL_EMULATION=y
> CONFIG_INTEL_POWERCLAMP=y
> CONFIG_X86_PKG_TEMP_THERMAL=y
> # CONFIG_INT340X_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> # CONFIG_SOFT_WATCHDOG is not set
> CONFIG_DA9052_WATCHDOG=y
> CONFIG_DA9063_WATCHDOG=y
> CONFIG_MENF21BMC_WATCHDOG=y
> CONFIG_WM831X_WATCHDOG=y
> CONFIG_WM8350_WATCHDOG=y
> # CONFIG_XILINX_WATCHDOG is not set
> CONFIG_DW_WATCHDOG=y
> CONFIG_RN5T618_WATCHDOG=y
> CONFIG_TWL4030_WATCHDOG=y
> CONFIG_ACQUIRE_WDT=y
> CONFIG_ADVANTECH_WDT=y
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> CONFIG_F71808E_WDT=y
> # CONFIG_SP5100_TCO is not set
> # CONFIG_SBC_FITPC2_WATCHDOG is not set
> # CONFIG_EUROTECH_WDT is not set
> # CONFIG_IB700_WDT is not set
> CONFIG_IBMASR=y
> CONFIG_WAFER_WDT=y
> # CONFIG_I6300ESB_WDT is not set
> # CONFIG_IE6XX_WDT is not set
> # CONFIG_ITCO_WDT is not set
> # CONFIG_IT8712F_WDT is not set
> CONFIG_IT87_WDT=y
> # CONFIG_HP_WATCHDOG is not set
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> # CONFIG_NV_TCO is not set
> CONFIG_60XX_WDT=y
> CONFIG_CPU5_WDT=y
> # CONFIG_SMSC_SCH311X_WDT is not set
> CONFIG_SMSC37B787_WDT=y
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=y
> # CONFIG_W83877F_WDT is not set
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=y
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_SILENT=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> CONFIG_BCMA_HOST_SOC=y
> # CONFIG_BCMA_DRIVER_GMAC_CMN is not set
> CONFIG_BCMA_DEBUG=y
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_AS3711=y
> # CONFIG_PMIC_ADP5520 is not set
> # CONFIG_MFD_BCM590XX is not set
> CONFIG_MFD_AXP20X=y
> CONFIG_MFD_CROS_EC=y
> # CONFIG_MFD_CROS_EC_I2C is not set
> # CONFIG_PMIC_DA903X is not set
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_SPI=y
> CONFIG_MFD_DA9052_I2C=y
> # CONFIG_MFD_DA9055 is not set
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13XXX=y
> # CONFIG_MFD_MC13XXX_SPI is not set
> CONFIG_MFD_MC13XXX_I2C=y
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> CONFIG_INTEL_SOC_PMIC=y
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> CONFIG_MFD_MAX14577=y
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> # CONFIG_MFD_MAX8907 is not set
> # CONFIG_MFD_MAX8925 is not set
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_MFD_MENF21BMC=y
> # CONFIG_EZX_PCAP is not set
> CONFIG_MFD_VIPERBOARD=y
> # CONFIG_MFD_RETU is not set
> # CONFIG_MFD_PCF50633 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> CONFIG_MFD_RTSX_USB=y
> CONFIG_MFD_RC5T583=y
> CONFIG_MFD_RN5T618=y
> # CONFIG_MFD_SEC_CORE is not set
> # CONFIG_MFD_SI476X_CORE is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_MFD_LP3943=y
> # CONFIG_MFD_LP8788 is not set
> CONFIG_MFD_PALMAS=y
> # CONFIG_TPS6105X is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> CONFIG_MFD_TPS65218=y
> # CONFIG_MFD_TPS6586X is not set
> CONFIG_MFD_TPS80031=y
> CONFIG_TWL4030_CORE=y
> # CONFIG_MFD_TWL4030_AUDIO is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> # CONFIG_MFD_WM8997 is not set
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM831X=y
> CONFIG_MFD_WM831X_I2C=y
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> CONFIG_MFD_WM8994=y
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> # CONFIG_REGULATOR_88PM800 is not set
> CONFIG_REGULATOR_88PM8607=y
> # CONFIG_REGULATOR_ACT8865 is not set
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_ANATOP=y
> CONFIG_REGULATOR_AS3711=y
> CONFIG_REGULATOR_AXP20X=y
> CONFIG_REGULATOR_DA9052=y
> # CONFIG_REGULATOR_DA9063 is not set
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_DA9211=y
> # CONFIG_REGULATOR_FAN53555 is not set
> CONFIG_REGULATOR_ISL9305=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> CONFIG_REGULATOR_LP3972=y
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LTC3589=y
> # CONFIG_REGULATOR_MAX14577 is not set
> CONFIG_REGULATOR_MAX1586=y
> # CONFIG_REGULATOR_MAX8649 is not set
> # CONFIG_REGULATOR_MAX8660 is not set
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> CONFIG_REGULATOR_MAX8998=y
> # CONFIG_REGULATOR_MC13783 is not set
> # CONFIG_REGULATOR_MC13892 is not set
> CONFIG_REGULATOR_PALMAS=y
> # CONFIG_REGULATOR_PFUZE100 is not set
> CONFIG_REGULATOR_RC5T583=y
> CONFIG_REGULATOR_RN5T618=y
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS62360=y
> CONFIG_REGULATOR_TPS65023=y
> # CONFIG_REGULATOR_TPS6507X is not set
> CONFIG_REGULATOR_TPS65217=y
> CONFIG_REGULATOR_TPS6524X=y
> CONFIG_REGULATOR_TPS80031=y
> CONFIG_REGULATOR_TWL4030=y
> CONFIG_REGULATOR_WM831X=y
> CONFIG_REGULATOR_WM8350=y
> CONFIG_REGULATOR_WM8994=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> 
> #
> # Direct Rendering Manager
> #
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> 
> #
> # I2C encoder or helper chips
> #
> # CONFIG_DRM_I2C_CH7006 is not set
> CONFIG_DRM_I2C_SIL164=y
> CONFIG_DRM_I2C_NXP_TDA998X=y
> CONFIG_DRM_PTN3460=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_NOUVEAU is not set
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_DRM_GMA500 is not set
> CONFIG_DRM_UDL=y
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> # CONFIG_DRM_BOCHS is not set
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_CMDLINE=y
> # CONFIG_FB_DDC is not set
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> CONFIG_FB_BOTH_ENDIAN=y
> # CONFIG_FB_BIG_ENDIAN is not set
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_HECUBA=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=y
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> # CONFIG_FB_UVESA is not set
> CONFIG_FB_VESA=y
> CONFIG_FB_N411=y
> CONFIG_FB_HGA=y
> CONFIG_FB_OPENCORES=y
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> CONFIG_FB_SM501=y
> # CONFIG_FB_SMSCUFX is not set
> # CONFIG_FB_UDL is not set
> CONFIG_FB_VIRTUAL=y
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=y
> # CONFIG_FB_AUO_K190X is not set
> CONFIG_FB_SIMPLE=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> # CONFIG_LCD_CLASS_DEVICE is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_LM3533 is not set
> CONFIG_BACKLIGHT_DA9052=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_WM831X=y
> CONFIG_BACKLIGHT_ADP8860=y
> # CONFIG_BACKLIGHT_ADP8870 is not set
> CONFIG_BACKLIGHT_88PM860X=y
> CONFIG_BACKLIGHT_LM3639=y
> # CONFIG_BACKLIGHT_PANDORA is not set
> # CONFIG_BACKLIGHT_TPS65217 is not set
> CONFIG_BACKLIGHT_AS3711=y
> CONFIG_BACKLIGHT_LV5207LP=y
> # CONFIG_BACKLIGHT_BD6107 is not set
> # CONFIG_VGASTATE is not set
> CONFIG_HDMI=y
> # CONFIG_LOGO is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_SEQUENCER=y
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=y
> CONFIG_SND_PCM_OSS=y
> # CONFIG_SND_PCM_OSS_PLUGINS is not set
> CONFIG_SND_SEQUENCER_OSS=y
> CONFIG_SND_HRTIMER=y
> CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=y
> # CONFIG_SND_VERBOSE_PROCFS is not set
> CONFIG_SND_VERBOSE_PRINTK=y
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=y
> # CONFIG_SND_OPL3_LIB_SEQ is not set
> # CONFIG_SND_OPL4_LIB_SEQ is not set
> # CONFIG_SND_SBAWE_SEQ is not set
> # CONFIG_SND_EMU10K1_SEQ is not set
> # CONFIG_SND_DRIVERS is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALS4000 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ASIHPI is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> # CONFIG_SND_CS4281 is not set
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_INDIGOIOX is not set
> # CONFIG_SND_INDIGODJX is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_LOLA is not set
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> 
> #
> # HD-Audio
> #
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_SPI is not set
> # CONFIG_SND_USB is not set
> # CONFIG_SND_SOC is not set
> CONFIG_SOUND_PRIME=y
> CONFIG_SOUND_OSS=y
> CONFIG_SOUND_TRACEINIT=y
> CONFIG_SOUND_DMAP=y
> CONFIG_SOUND_VMIDI=y
> # CONFIG_SOUND_TRIX is not set
> CONFIG_SOUND_MSS=y
> # CONFIG_SOUND_MPU401 is not set
> CONFIG_SOUND_PAS=y
> # CONFIG_PAS_JOYSTICK is not set
> CONFIG_SOUND_PSS=y
> # CONFIG_PSS_MIXER is not set
> CONFIG_SOUND_SB=y
> # CONFIG_SOUND_YM3812 is not set
> CONFIG_SOUND_UART6850=y
> CONFIG_SOUND_AEDSP16=y
> # CONFIG_SC6600 is not set
> CONFIG_SOUND_KAHLUA=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> CONFIG_UHID=y
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> # CONFIG_HID_ACRUX_FF is not set
> # CONFIG_HID_APPLE is not set
> # CONFIG_HID_AUREAL is not set
> # CONFIG_HID_BELKIN is not set
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_PRODIKEYS=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=y
> CONFIG_HID_ELECOM=y
> CONFIG_HID_EZKEY=y
> # CONFIG_HID_KEYTOUCH is not set
> CONFIG_HID_KYE=y
> CONFIG_HID_UCLOGIC=y
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> CONFIG_HID_TWINHAN=y
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> # CONFIG_HID_LENOVO is not set
> CONFIG_HID_LOGITECH=y
> # CONFIG_HID_LOGITECH_DJ is not set
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> # CONFIG_LOGIG940_FF is not set
> CONFIG_LOGIWHEELS_FF=y
> CONFIG_HID_MAGICMOUSE=y
> CONFIG_HID_MICROSOFT=y
> # CONFIG_HID_MONTEREY is not set
> CONFIG_HID_MULTITOUCH=y
> CONFIG_HID_ORTEK=y
> CONFIG_HID_PANTHERLORD=y
> CONFIG_PANTHERLORD_FF=y
> CONFIG_HID_PETALYNX=y
> CONFIG_HID_PICOLCD=y
> # CONFIG_HID_PICOLCD_FB is not set
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LEDS=y
> CONFIG_HID_PRIMAX=y
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SAMSUNG is not set
> # CONFIG_HID_SPEEDLINK is not set
> CONFIG_HID_STEELSERIES=y
> # CONFIG_HID_SUNPLUS is not set
> CONFIG_HID_RMI=y
> CONFIG_HID_GREENASIA=y
> # CONFIG_GREENASIA_FF is not set
> CONFIG_HID_SMARTJOYPLUS=y
> # CONFIG_SMARTJOYPLUS_FF is not set
> CONFIG_HID_TIVO=y
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> CONFIG_HID_WACOM=y
> CONFIG_HID_WIIMOTE=y
> CONFIG_HID_XINMO=y
> # CONFIG_HID_ZEROPLUS is not set
> CONFIG_HID_ZYDACRON=y
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # USB HID support
> #
> # CONFIG_USB_HID is not set
> # CONFIG_HID_PID is not set
> 
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=y
> # CONFIG_USB_MOUSE is not set
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_OTG=y
> # CONFIG_USB_OTG_WHITELIST is not set
> # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> CONFIG_USB_OTG_FSM=y
> # CONFIG_USB_MON is not set
> CONFIG_USB_WUSB=y
> CONFIG_USB_WUSB_CBAF=y
> CONFIG_USB_WUSB_CBAF_DEBUG=y
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PCI=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> # CONFIG_USB_EHCI_TT_NEWSCHED is not set
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> CONFIG_USB_OXU210HP_HCD=y
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_ISP1760_HCD=y
> CONFIG_USB_ISP1362_HCD=y
> # CONFIG_USB_FUSBH200_HCD is not set
> CONFIG_USB_FOTG210_HCD=y
> # CONFIG_USB_MAX3421_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> # CONFIG_USB_UHCI_HCD is not set
> CONFIG_USB_U132_HCD=y
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> CONFIG_USB_HWA_HCD=y
> CONFIG_USB_HCD_BCMA=y
> # CONFIG_USB_HCD_SSB is not set
> # CONFIG_USB_HCD_TEST_MODE is not set
> 
> #
> # USB Device Class drivers
> #
> # CONFIG_USB_ACM is not set
> # CONFIG_USB_PRINTER is not set
> CONFIG_USB_WDM=y
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> CONFIG_USB_STORAGE_DEBUG=y
> CONFIG_USB_STORAGE_REALTEK=y
> CONFIG_USB_STORAGE_DATAFAB=y
> CONFIG_USB_STORAGE_FREECOM=y
> CONFIG_USB_STORAGE_ISD200=y
> # CONFIG_USB_STORAGE_USBAT is not set
> CONFIG_USB_STORAGE_SDDR09=y
> # CONFIG_USB_STORAGE_SDDR55 is not set
> CONFIG_USB_STORAGE_JUMPSHOT=y
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> # CONFIG_USB_UAS is not set
> 
> #
> # USB Imaging devices
> #
> CONFIG_USB_MDC800=y
> CONFIG_USB_MICROTEK=y
> # CONFIG_USBIP_CORE is not set
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_HOST=y
> CONFIG_USB_MUSB_TUSB6010=y
> # CONFIG_USB_MUSB_UX500 is not set
> CONFIG_MUSB_PIO_ONLY=y
> # CONFIG_USB_DWC3 is not set
> # CONFIG_USB_DWC2 is not set
> CONFIG_USB_CHIPIDEA=y
> CONFIG_USB_CHIPIDEA_HOST=y
> CONFIG_USB_CHIPIDEA_DEBUG=y
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=y
> # CONFIG_USB_SERIAL is not set
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> CONFIG_USB_EMI26=y
> CONFIG_USB_ADUTUX=y
> # CONFIG_USB_SEVSEG is not set
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_LED is not set
> CONFIG_USB_CYPRESS_CY7C63=y
> CONFIG_USB_CYTHERM=y
> CONFIG_USB_IDMOUSE=y
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> # CONFIG_USB_SISUSBVGA is not set
> CONFIG_USB_LD=y
> CONFIG_USB_TRANCEVIBRATOR=y
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> CONFIG_USB_LINK_LAYER_TEST=y
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> CONFIG_NOP_USB_XCEIV=y
> CONFIG_USB_ISP1301=y
> # CONFIG_USB_GADGET is not set
> # CONFIG_USB_LED_TRIG is not set
> CONFIG_UWB=y
> CONFIG_UWB_HWA=y
> # CONFIG_UWB_WHCI is not set
> CONFIG_UWB_I1480U=y
> # CONFIG_MMC is not set
> CONFIG_MEMSTICK=y
> CONFIG_MEMSTICK_DEBUG=y
> 
> #
> # MemoryStick drivers
> #
> CONFIG_MEMSTICK_UNSAFE_RESUME=y
> CONFIG_MSPRO_BLOCK=y
> # CONFIG_MS_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> # CONFIG_MEMSTICK_TIFM_MS is not set
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> # CONFIG_MEMSTICK_R592 is not set
> CONFIG_MEMSTICK_REALTEK_USB=y
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_88PM860X is not set
> # CONFIG_LEDS_LM3530 is not set
> CONFIG_LEDS_LM3533=y
> CONFIG_LEDS_LM3642=y
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> # CONFIG_LEDS_LP5523 is not set
> CONFIG_LEDS_LP5562=y
> CONFIG_LEDS_LP8501=y
> CONFIG_LEDS_CLEVO_MAIL=y
> CONFIG_LEDS_PCA955X=y
> # CONFIG_LEDS_PCA963X is not set
> CONFIG_LEDS_WM831X_STATUS=y
> # CONFIG_LEDS_WM8350 is not set
> CONFIG_LEDS_DA9052=y
> CONFIG_LEDS_DAC124S085=y
> # CONFIG_LEDS_REGULATOR is not set
> CONFIG_LEDS_BD2802=y
> # CONFIG_LEDS_INTEL_SS4200 is not set
> CONFIG_LEDS_MC13783=y
> CONFIG_LEDS_TCA6507=y
> # CONFIG_LEDS_LM355x is not set
> CONFIG_LEDS_MENF21BMC=y
> 
> #
> # LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
> #
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> # CONFIG_LEDS_TRIGGER_TIMER is not set
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> CONFIG_LEDS_TRIGGER_IDE_DISK=y
> # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> CONFIG_LEDS_TRIGGER_CPU=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> CONFIG_LEDS_TRIGGER_CAMERA=y
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> # CONFIG_UIO_DMEM_GENIRQ is not set
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> # CONFIG_UIO_MF624 is not set
> # CONFIG_VIRT_DRIVERS is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACERHDF is not set
> # CONFIG_ASUS_LAPTOP is not set
> # CONFIG_DELL_LAPTOP is not set
> # CONFIG_DELL_SMO8800 is not set
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_HP_ACCEL is not set
> # CONFIG_HP_WIRELESS is not set
> # CONFIG_PANASONIC_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_MENLOW is not set
> # CONFIG_ACPI_WMI is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_TOSHIBA_HAPS is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_SAMSUNG_LAPTOP is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_APPLE_GMUX is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_PVPANIC is not set
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> # CONFIG_SOC_TI is not set
> 
> #
> # Hardware Spinlock drivers
> #
> 
> #
> # Clock Source drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_ATMEL_PIT is not set
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> CONFIG_IOMMU_SUPPORT=y
> # CONFIG_AMD_IOMMU is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> # CONFIG_BMA180 is not set
> CONFIG_BMC150_ACCEL=y
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
> CONFIG_KXSD9=y
> # CONFIG_MMA8452 is not set
> CONFIG_KXCJK1013=y
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> CONFIG_AD7266=y
> CONFIG_AD7291=y
> CONFIG_AD7298=y
> CONFIG_AD7476=y
> CONFIG_AD7791=y
> CONFIG_AD7793=y
> CONFIG_AD7887=y
> CONFIG_AD7923=y
> CONFIG_AD799X=y
> # CONFIG_MAX1027 is not set
> # CONFIG_MAX1363 is not set
> CONFIG_MCP320X=y
> CONFIG_MCP3422=y
> # CONFIG_MEN_Z188_ADC is not set
> CONFIG_NAU7802=y
> CONFIG_TI_ADC081C=y
> CONFIG_TI_ADC128S052=y
> CONFIG_TWL4030_MADC=y
> CONFIG_TWL6030_GPADC=y
> # CONFIG_VIPERBOARD_ADC is not set
> 
> #
> # Amplifiers
> #
> # CONFIG_AD8366 is not set
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> CONFIG_AD5064=y
> CONFIG_AD5360=y
> CONFIG_AD5380=y
> # CONFIG_AD5421 is not set
> CONFIG_AD5446=y
> CONFIG_AD5449=y
> CONFIG_AD5504=y
> CONFIG_AD5624R_SPI=y
> CONFIG_AD5686=y
> CONFIG_AD5755=y
> CONFIG_AD5764=y
> # CONFIG_AD5791 is not set
> CONFIG_AD7303=y
> # CONFIG_MAX517 is not set
> CONFIG_MCP4725=y
> CONFIG_MCP4922=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> CONFIG_AD9523=y
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> # CONFIG_ADF4350 is not set
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16080=y
> CONFIG_ADIS16130=y
> CONFIG_ADIS16136=y
> # CONFIG_ADIS16260 is not set
> CONFIG_ADXRS450=y
> CONFIG_BMG160=y
> CONFIG_HID_SENSOR_GYRO_3D=y
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_IIO_ST_GYRO_SPI_3AXIS=y
> # CONFIG_ITG3200 is not set
> 
> #
> # Humidity sensors
> #
> # CONFIG_SI7005 is not set
> 
> #
> # Inertial measurement units
> #
> # CONFIG_ADIS16400 is not set
> CONFIG_ADIS16480=y
> # CONFIG_INV_MPU6050_IIO is not set
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> 
> #
> # Light sensors
> #
> # CONFIG_ADJD_S311 is not set
> CONFIG_AL3320A=y
> # CONFIG_APDS9300 is not set
> CONFIG_CM32181=y
> CONFIG_CM36651=y
> # CONFIG_GP2AP020A00F is not set
> CONFIG_ISL29125=y
> CONFIG_HID_SENSOR_ALS=y
> CONFIG_HID_SENSOR_PROX=y
> CONFIG_SENSORS_LM3533=y
> # CONFIG_LTR501 is not set
> # CONFIG_TCS3414 is not set
> CONFIG_TCS3472=y
> # CONFIG_SENSORS_TSL2563 is not set
> # CONFIG_TSL4531 is not set
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> # CONFIG_AK09911 is not set
> # CONFIG_MAG3110 is not set
> CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
> # CONFIG_IIO_ST_MAGN_3AXIS is not set
> 
> #
> # Inclinometer sensors
> #
> CONFIG_HID_SENSOR_INCLINOMETER_3D=y
> CONFIG_HID_SENSOR_DEVICE_ROTATION=y
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_HID_SENSOR_PRESS=y
> # CONFIG_MPL115 is not set
> # CONFIG_MPL3115 is not set
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_IIO_ST_PRESS_SPI=y
> CONFIG_T5403=y
> 
> #
> # Lightning sensors
> #
> CONFIG_AS3935=y
> 
> #
> # Temperature sensors
> #
> CONFIG_MLX90614=y
> CONFIG_TMP006=y
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> # CONFIG_PWM is not set
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> # CONFIG_GENERIC_PHY is not set
> # CONFIG_BCM_KONA_USB2_PHY is not set
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=y
> CONFIG_MCB=y
> # CONFIG_MCB_PCI is not set
> # CONFIG_THUNDERBOLT is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> CONFIG_DMIID=y
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> CONFIG_EXT2_FS_SECURITY=y
> CONFIG_EXT2_FS_XIP=y
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_USE_FOR_EXT23=y
> # CONFIG_EXT4_FS_POSIX_ACL is not set
> # CONFIG_EXT4_FS_SECURITY is not set
> CONFIG_EXT4_DEBUG=y
> CONFIG_FS_XIP=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> CONFIG_REISERFS_CHECK=y
> CONFIG_REISERFS_PROC_INFO=y
> CONFIG_REISERFS_FS_XATTR=y
> # CONFIG_REISERFS_FS_POSIX_ACL is not set
> # CONFIG_REISERFS_FS_SECURITY is not set
> CONFIG_JFS_FS=y
> CONFIG_JFS_POSIX_ACL=y
> CONFIG_JFS_SECURITY=y
> CONFIG_JFS_DEBUG=y
> # CONFIG_JFS_STATISTICS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_WARN=y
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> # CONFIG_OCFS2_FS_STATS is not set
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> # CONFIG_BTRFS_FS is not set
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> # CONFIG_FSNOTIFY is not set
> # CONFIG_DNOTIFY is not set
> # CONFIG_INOTIFY_USER is not set
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> # CONFIG_PRINT_QUOTA_WARNING is not set
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> CONFIG_CUSE=y
> CONFIG_OVERLAY_FS=y
> 
> #
> # Caches
> #
> CONFIG_FSCACHE=y
> CONFIG_FSCACHE_STATS=y
> CONFIG_FSCACHE_HISTOGRAM=y
> # CONFIG_FSCACHE_DEBUG is not set
> # CONFIG_FSCACHE_OBJECT_LIST is not set
> # CONFIG_CACHEFILES is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> CONFIG_NTFS_DEBUG=y
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> # CONFIG_PROC_KCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> # CONFIG_NLS_CODEPAGE_437 is not set
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> # CONFIG_NLS_CODEPAGE_852 is not set
> CONFIG_NLS_CODEPAGE_855=y
> CONFIG_NLS_CODEPAGE_857=y
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> CONFIG_NLS_CODEPAGE_865=y
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> # CONFIG_NLS_CODEPAGE_936 is not set
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> CONFIG_NLS_CODEPAGE_1250=y
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> # CONFIG_NLS_ISO8859_3 is not set
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> CONFIG_NLS_ISO8859_6=y
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> CONFIG_NLS_KOI8_R=y
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> CONFIG_NLS_MAC_ICELAND=y
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> CONFIG_NLS_UTF8=y
> # CONFIG_DLM is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=2048
> CONFIG_STRIP_ASM_SYMS=y
> CONFIG_READABLE_ASM=y
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> CONFIG_DEBUG_SHIRQ=y
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_SCHED_STACK_END_CHECK=y
> CONFIG_TIMER_STATS=y
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_LOCK_TORTURE_TEST=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_LIST=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> # CONFIG_SPARSE_RCU_POINTER is not set
> CONFIG_TORTURE_TEST=y
> CONFIG_RCU_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_INFO=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_LKDTM is not set
> CONFIG_TEST_LIST_SORT=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> CONFIG_TEST_STRING_HELPERS=y
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_TEST_RHASHTABLE is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> CONFIG_TEST_FIRMWARE=y
> CONFIG_TEST_UDELAY=y
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> # CONFIG_EARLY_PRINTK is not set
> # CONFIG_X86_PTDUMP is not set
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DOUBLEFAULT is not set
> CONFIG_DEBUG_TLBFLUSH=y
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> CONFIG_IO_DELAY_UDELAY=y
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=2
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> CONFIG_OPTIMIZE_INLINING=y
> CONFIG_DEBUG_NMI_SELFTEST=y
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> # CONFIG_TRUSTED_KEYS is not set
> # CONFIG_ENCRYPTED_KEYS is not set
> CONFIG_KEYS_DEBUG_PROC_KEYS=y
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> # CONFIG_SECURITY_NETWORK is not set
> CONFIG_SECURITY_PATH=y
> # CONFIG_SECURITY_SMACK is not set
> # CONFIG_SECURITY_TOMOYO is not set
> # CONFIG_SECURITY_APPARMOR is not set
> CONFIG_SECURITY_YAMA=y
> CONFIG_SECURITY_YAMA_STACKED=y
> # CONFIG_INTEGRITY is not set
> CONFIG_DEFAULT_SECURITY_YAMA=y
> # CONFIG_DEFAULT_SECURITY_DAC is not set
> CONFIG_DEFAULT_SECURITY="yama"
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_MCRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> # CONFIG_CRYPTO_GCM is not set
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
> # CONFIG_CRYPTO_GHASH is not set
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> # CONFIG_CRYPTO_SHA1_SSSE3 is not set
> # CONFIG_CRYPTO_SHA256_SSSE3 is not set
> CONFIG_CRYPTO_SHA512_SSSE3=y
> CONFIG_CRYPTO_SHA1_MB=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> CONFIG_CRYPTO_AES_X86_64=y
> CONFIG_CRYPTO_AES_NI_INTEL=y
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_BLOWFISH_X86_64=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAMELLIA_X86_64=y
> # CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
> CONFIG_CRYPTO_CAST_COMMON=y
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
> CONFIG_CRYPTO_CAST6=y
> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> # CONFIG_CRYPTO_SALSA20 is not set
> CONFIG_CRYPTO_SALSA20_X86_64=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
> CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
> CONFIG_CRYPTO_SERPENT_AVX2_X86_64=y
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_X86_64=y
> CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=y
> CONFIG_CRYPTO_ZLIB=y
> # CONFIG_CRYPTO_LZO is not set
> # CONFIG_CRYPTO_LZ4 is not set
> # CONFIG_CRYPTO_LZ4HC is not set
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_DRBG_MENU=y
> CONFIG_CRYPTO_DRBG_HMAC=y
> # CONFIG_CRYPTO_DRBG_HASH is not set
> CONFIG_CRYPTO_DRBG_CTR=y
> CONFIG_CRYPTO_DRBG=y
> CONFIG_CRYPTO_USER_API=y
> # CONFIG_CRYPTO_USER_API_HASH is not set
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> CONFIG_CRYPTO_DEV_PADLOCK=y
> CONFIG_CRYPTO_DEV_PADLOCK_AES=y
> CONFIG_CRYPTO_DEV_PADLOCK_SHA=y
> # CONFIG_CRYPTO_DEV_CCP is not set
> # CONFIG_CRYPTO_DEV_QAT_DH895xCC is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> # CONFIG_X509_CERTIFICATE_PARSER is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=y
> # CONFIG_CRC8 is not set
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> # CONFIG_XZ_DEC_X86 is not set
> # CONFIG_XZ_DEC_POWERPC is not set
> CONFIG_XZ_DEC_IA64=y
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_DQL=y
> CONFIG_GLOB=y
> # CONFIG_GLOB_SELFTEST is not set
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_LRU_CACHE=y
> # CONFIG_AVERAGE is not set
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_ARCH_HAS_SG_CHAIN=y

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com

