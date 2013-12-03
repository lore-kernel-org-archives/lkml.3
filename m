Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3LCMzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:55:33 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56343 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753225Ab3LCMza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:55:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next list <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: randconfig build error with next-20131202, in arch/x86/pci
Date: Tue, 03 Dec 2013 14:08:26 +0100
Message-ID: <3737409.hAs7519lnE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo4a2CcEpt6okjTS-wyGCgc7JsHWnGPn7FXrhRfwXqj=oA@mail.gmail.com>
References: <CA+r1ZhiKj_0HXb7s1oDc-Pgm6n63rYNpxzqXfxKDgdKZU27LcQ@mail.gmail.com> <CAErSpo4a2CcEpt6okjTS-wyGCgc7JsHWnGPn7FXrhRfwXqj=oA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 02, 2013 04:14:32 PM Bjorn Helgaas wrote:
> [+cc Lv, Rafael, linux-acpi]
> 
> Is this fallout related to "ACPI: Cleanup <acpi/acpi.h>,
> <acpi/acpi_bus.h> and <acpi/acpi_drivers.h> inclusions"?

We have a new version of that patch that should avoid at least some of these
errors.  I'm going to replace the one in my tree with it shortly.

> On Mon, Dec 2, 2013 at 7:57 AM, Jim Davis <jim.epost@gmail.com> wrote:
> > Building with the attached random configuration file,
> >
> > arch/x86/pci/mmconfig-shared.c:373:1: error: unknown type name ‘acpi_status’
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >  ^
> > arch/x86/pci/mmconfig-shared.c:373:47: warning: ‘struct acpi_resource’
> > declared inside parameter list [enabled by default]
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >                                                ^
> > arch/x86/pci/mmconfig-shared.c:373:47: warning: its scope is only this
> > definition or declaration, which is probably not what you want
> > [enabled by default]
> > arch/x86/pci/mmconfig-shared.c: In function ‘check_mcfg_resource’:
> > arch/x86/pci/mmconfig-shared.c:376:33: error: storage size of
> > ‘address’ isn’t known
> >   struct acpi_resource_address64 address;
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c:377:2: error: unknown type name ‘acpi_status’
> >   acpi_status status;
> >   ^
> > arch/x86/pci/mmconfig-shared.c:379:9: error: dereferencing pointer to
> > incomplete type
> >   if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
> >          ^
> > arch/x86/pci/mmconfig-shared.c:379:19: error:
> > ‘ACPI_RESOURCE_TYPE_FIXED_MEMORY32’ undeclared (first use in this
> > function)
> >   if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
> >                    ^
> > arch/x86/pci/mmconfig-shared.c:379:19: note: each undeclared
> > identifier is reported only once for each function it appears in
> > arch/x86/pci/mmconfig-shared.c:381:8: error: dereferencing pointer to
> > incomplete type
> >     &res->data.fixed_memory32;
> >         ^
> > arch/x86/pci/mmconfig-shared.c:383:11: error: ‘AE_OK’ undeclared
> > (first use in this function)
> >     return AE_OK;
> >            ^
> > arch/x86/pci/mmconfig-shared.c:384:35: error: dereferencing pointer to
> > incomplete type
> >    if ((mcfg_res->start >= fixmem32->address) &&
> >                                    ^
> > arch/x86/pci/mmconfig-shared.c:385:33: error: dereferencing pointer to
> > incomplete type
> >        (mcfg_res->end < (fixmem32->address +
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c:386:19: error: dereferencing pointer to
> > incomplete type
> >            fixmem32->address_length))) {
> >                    ^
> > arch/x86/pci/mmconfig-shared.c:388:11: error: ‘AE_CTRL_TERMINATE’
> > undeclared (first use in this function)
> >     return AE_CTRL_TERMINATE;
> >            ^
> > arch/x86/pci/mmconfig-shared.c:391:10: error: dereferencing pointer to
> > incomplete type
> >   if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
> >           ^
> > arch/x86/pci/mmconfig-shared.c:391:20: error:
> > ‘ACPI_RESOURCE_TYPE_ADDRESS32’ undeclared (first use in this function)
> >   if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
> >                     ^
> > arch/x86/pci/mmconfig-shared.c:392:10: error: dereferencing pointer to
> > incomplete type
> >       (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
> >           ^
> > arch/x86/pci/mmconfig-shared.c:392:20: error:
> > ‘ACPI_RESOURCE_TYPE_ADDRESS64’ undeclared (first use in this function)
> >       (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
> >                     ^
> > arch/x86/pci/mmconfig-shared.c:395:2: error: implicit declaration of
> > function ‘acpi_resource_to_address64’
> > [-Werror=implicit-function-declaration]
> >   status = acpi_resource_to_address64(res, &address);
> >   ^
> > arch/x86/pci/mmconfig-shared.c:396:2: error: implicit declaration of
> > function ‘ACPI_FAILURE’ [-Werror=implicit-function-declaration]
> >   if (ACPI_FAILURE(status) ||
> >   ^
> > arch/x86/pci/mmconfig-shared.c:398:31: error: ‘ACPI_MEMORY_RANGE’
> > undeclared (first use in this function)
> >      (address.resource_type != ACPI_MEMORY_RANGE))
> >                                ^
> > arch/x86/pci/mmconfig-shared.c:376:33: warning: unused variable
> > ‘address’ [-Wunused-variable]
> >   struct acpi_resource_address64 address;
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:409:1: error: unknown type name ‘acpi_status’
> >  static acpi_status find_mboard_resource(acpi_handle handle, u32 lvl,
> >  ^
> > arch/x86/pci/mmconfig-shared.c:409:41: error: unknown type name ‘acpi_handle’
> >  static acpi_status find_mboard_resource(acpi_handle handle, u32 lvl,
> >                                          ^
> > arch/x86/pci/mmconfig-shared.c: In function ‘is_acpi_reserved’:
> > arch/x86/pci/mmconfig-shared.c:431:2: error: implicit declaration of
> > function ‘acpi_get_devices’ [-Werror=implicit-function-declaration]
> >   acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
> >   ^
> > arch/x86/pci/mmconfig-shared.c:431:30: error: ‘find_mboard_resource’
> > undeclared            ^
> > jim@krebstar:~$ more errs
> > jim@krebstar:~$ cat errs
> > arch/x86/pci/mmconfig-shared.c:373:1: error: unknown type name ‘acpi_status’
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >  ^
> > arch/x86/pci/mmconfig-shared.c:373:47: warning: ‘struct acpi_resource’
> > declared inside parameter list [enabled by default]
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >                                                ^
> > arch/x86/pci/mmconfig-shared.c:373:47: warning: its scope is only this
> > definition or declaration, which is probably not what you want
> > [enabled by default]
> > arch/x86/pci/mmconfig-shared.c: In function ‘check_mcfg_resource’:
> > arch/x86/pci/mmconfig-shared.c:376:33: error: storage size of
> > ‘address’ isn’t known
> >   struct acpi_resource_address64 address;
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c:377:2: error: unknown type name ‘acpi_status’
> >   acpi_status status;
> >   ^
> > arch/x86/pci/mmconfig-shared.c:379:9: error: dereferencing pointer to
> > incomplete type
> >   if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
> >          ^
> > arch/x86/pci/mmconfig-shared.c:379:19: error:
> > ‘ACPI_RESOURCE_TYPE_FIXED_MEMORY32’ undeclared (first use in this
> > function)
> >   if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
> >                    ^
> > arch/x86/pci/mmconfig-shared.c:379:19: note: each undeclared
> > identifier is reported only once for each function it appears in
> > arch/x86/pci/mmconfig-shared.c:381:8: error: dereferencing pointer to
> > incomplete type
> >     &res->data.fixed_memory32;
> >         ^
> > arch/x86/pci/mmconfig-shared.c:383:11: error: ‘AE_OK’ undeclared
> > (first use in this function)
> >     return AE_OK;
> >            ^
> > arch/x86/pci/mmconfig-shared.c:384:35: error: dereferencing pointer to
> > incomplete type
> >    if ((mcfg_res->start >= fixmem32->address) &&
> >                                    ^
> > arch/x86/pci/mmconfig-shared.c:385:33: error: dereferencing pointer to
> > incomplete type
> >        (mcfg_res->end < (fixmem32->address +
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c:386:19: error: dereferencing pointer to
> > incomplete type
> >            fixmem32->address_length))) {
> >                    ^
> > arch/x86/pci/mmconfig-shared.c:388:11: error: ‘AE_CTRL_TERMINATE’
> > undeclared (first use in this function)
> >     return AE_CTRL_TERMINATE;
> >            ^
> > arch/x86/pci/mmconfig-shared.c:391:10: error: dereferencing pointer to
> > incomplete type
> >   if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
> >           ^
> > arch/x86/pci/mmconfig-shared.c:391:20: error:
> > ‘ACPI_RESOURCE_TYPE_ADDRESS32’ undeclared (first use in this function)
> >   if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
> >                     ^
> > arch/x86/pci/mmconfig-shared.c:392:10: error: dereferencing pointer to
> > incomplete type
> >       (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
> >           ^
> > arch/x86/pci/mmconfig-shared.c:392:20: error:
> > ‘ACPI_RESOURCE_TYPE_ADDRESS64’ undeclared (first use in this function)
> >       (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
> >                     ^
> > arch/x86/pci/mmconfig-shared.c:395:2: error: implicit declaration of
> > function ‘acpi_resource_to_address64’
> > [-Werror=implicit-function-declaration]
> >   status = acpi_resource_to_address64(res, &address);
> >   ^
> > arch/x86/pci/mmconfig-shared.c:396:2: error: implicit declaration of
> > function ‘ACPI_FAILURE’ [-Werror=implicit-function-declaration]
> >   if (ACPI_FAILURE(status) ||
> >   ^
> > arch/x86/pci/mmconfig-shared.c:398:31: error: ‘ACPI_MEMORY_RANGE’
> > undeclared (first use in this function)
> >      (address.resource_type != ACPI_MEMORY_RANGE))
> >                                ^
> > arch/x86/pci/mmconfig-shared.c:376:33: warning: unused variable
> > ‘address’ [-Wunused-variable]
> >   struct acpi_resource_address64 address;
> >                                  ^
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:409:1: error: unknown type name ‘acpi_status’
> >  static acpi_status find_mboard_resource(acpi_handle handle, u32 lvl,
> >  ^
> > arch/x86/pci/mmconfig-shared.c:409:41: error: unknown type name ‘acpi_handle’
> >  static acpi_status find_mboard_resource(acpi_handle handle, u32 lvl,
> >                                          ^
> > arch/x86/pci/mmconfig-shared.c: In function ‘is_acpi_reserved’:
> > arch/x86/pci/mmconfig-shared.c:431:2: error: implicit declaration of
> > function ‘acpi_get_devices’ [-Werror=implicit-function-declaration]
> >   acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
> >   ^
> > arch/x86/pci/mmconfig-shared.c:431:30: error: ‘find_mboard_resource’
> > undeclared (first use in this function)
> >   acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
> >                               ^
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:544:13: warning: ‘struct
> > acpi_mcfg_allocation’ declared inside parameter list [enabled by
> > default]
> >       struct acpi_mcfg_allocation *cfg)
> >              ^
> > arch/x86/pci/mmconfig-shared.c:544:13: warning: ‘struct
> > acpi_table_mcfg’ declared inside parameter list [enabled by default]
> > arch/x86/pci/mmconfig-shared.c: In function ‘acpi_mcfg_check_entry’:
> > arch/x86/pci/mmconfig-shared.c:548:9: error: dereferencing pointer to
> > incomplete type
> >   if (cfg->address < 0xFFFFFFFF)
> >          ^
> > arch/x86/pci/mmconfig-shared.c:551:19: error: dereferencing pointer to
> > incomplete type
> >   if (!strncmp(mcfg->header.oem_id, "SGI", 3))
> >                    ^
> > arch/x86/pci/mmconfig-shared.c:554:10: error: dereferencing pointer to
> > incomplete type
> >   if (mcfg->header.revision >= 1) {
> >           ^
> > In file included from include/linux/kernel.h:13:0,
> >                  from include/linux/kernfs.h:10,
> >                  from include/linux/sysfs.h:15,
> >                  from include/linux/kobject.h:21,
> >                  from include/linux/pci.h:28,
> >                  from arch/x86/pci/mmconfig-shared.c:13:
> > arch/x86/pci/mmconfig-shared.c:561:39: error: dereferencing pointer to
> > incomplete type
> >          "is above 4GB, ignored\n", cfg->pci_segment,
> >                                        ^
> > include/linux/printk.h:217:33: note: in definition of macro ‘pr_err’
> >   printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
> >                                  ^
> >            ^
> > arch/x86/pci/mmconfig-shared.c:600:32: error: dereferencing pointer to
> > incomplete type
> >         cfg->end_bus_number, cfg->address) == NULL) {
> >                                 ^
> > arch/x86/pci/mmconfig-shared.c: In function ‘pci_mmcfg_early_init’:
> > arch/x86/pci/mmconfig-shared.c:642:25: error: ‘ACPI_SIG_MCFG’
> > undeclared (first use in this function)
> >     acpi_sfi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> >                          ^
> > arch/x86/pci/mmconfig-shared.c: In function ‘pci_mmcfg_late_init’:
> > arch/x86/pci/mmconfig-shared.c:658:24: error: ‘ACPI_SIG_MCFG’
> > undeclared (first use in this function)
> >    acpi_sfi_table_parse(ACPI_SIG_MCFG, pci_parse_mcfg);
> >                         ^
> > arch/x86/pci/mmconfig-shared.c: At top level:
> > arch/x86/pci/mmconfig-shared.c:373:20: warning: ‘check_mcfg_resource’
> > defined but not used [-Wunused-function]
> >  static acpi_status check_mcfg_resource(struct acpi_resource *res, void *data)
> >                     ^
> > cc1: some warnings being treated as errors
> > make[1]: *** [arch/x86/pci/mmconfig-shared.o] Error 1
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
