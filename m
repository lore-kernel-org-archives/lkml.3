Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab3BXCt3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 21:49:29 -0500
Received: from mail-ia0-f171.google.com ([209.85.210.171]:48238 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415Ab3BXCt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 21:49:28 -0500
MIME-Version: 1.0
In-Reply-To: <20130223212120.GA4593@google.com>
References: <20130223212120.GA4593@google.com>
Date: Sat, 23 Feb 2013 18:49:27 -0800
X-Google-Sender-Auth: Pr6BkIz7sABosnoMtyhJda0LZoI
Message-ID: <CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
Subject: Re: [GIT PULL] PCI changes for v3.9
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae93411b90dbb2b04d66f799f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae93411b90dbb2b04d66f799f
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Feb 23, 2013 at 1:21 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
>
>   Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.9-changes
>
> for you to fetch changes up to 018ba0a6efada61b9bc17500101d81c3d35807c2:
>
>   Merge branch 'pci/yinghai-root-bus-hotplug' into next (2013-02-19 11:42:17 -0700)

may render of bunch of conflicts...

Please check if attached diff is right, and hope it could save Linus some time.

Thanks

Yinghai

>
> ----------------------------------------------------------------
>
> PCI changes for the v3.9 merge window:
>
>   Host bridge hotplug
>     - Major overhaul of ACPI host bridge add/start (Rafael Wysocki, Yinghai Lu)
>     - Major overhaul of PCI/ACPI binding (Rafael Wysocki, Yinghai Lu)
>     - Split out ACPI host bridge and ACPI PCI device hotplug (Yinghai Lu)
>     - Stop caching _PRT and make independent of bus numbers (Yinghai Lu)
>
>   PCI device hotplug
>     - Clean up cpqphp dead code (Sasha Levin)
>     - Disable ARI unless device and upstream bridge support it (Yijing Wang)
>     - Initialize all hot-added devices (not functions 0-7) (Yijing Wang)
>
>   Power management
>     - Don't touch ASPM if disabled (Joe Lawrence)
>     - Fix ASPM link state management (Myron Stowe)
>
>   Miscellaneous
>     - Fix PCI_EXP_FLAGS accessor (Alex Williamson)
>     - Disable Bus Master in pci_device_shutdown (Konstantin Khlebnikov)
>     - Document hotplug resource and MPS parameters (Yijing Wang)
>     - Add accessor for PCIe capabilities (Myron Stowe)
>     - Drop pciehp suspend/resume messages (Paul Bolle)
>     - Make pci_slot built-in only (not a module) (Jiang Liu)
>     - Remove unused PCI/ACPI bind ops (Jiang Liu)
>     - Removed used pci_root_bus (Bjorn Helgaas)
>
> ----------------------------------------------------------------
> Alex Williamson (1):
>       PCI: Fix PCI Express Capability accessors for PCI_EXP_FLAGS
>
> Bjorn Helgaas (23):
>       ACPI: Remove unused struct acpi_pci_root.id member
>       x86/PCI: Remove unused pci_root_bus
>       frv/PCI: Remove unused pci_root_bus
>       mn10300/PCI: Remove unused pci_root_bus
>       PCI: Use "unsigned long" for __pci_enable_device_flags to match ioport.h
>       PCI: Drop "__" prefix on __pci_enable_device_flags()
>       Merge branch 'pci/misc' into next
>       Merge branch 'pci/yinghai-survey-resources' into next
>       Merge branch 'acpi-scan' of git://git.kernel.org/.../rafael/linux-pm into pci/yinghai-survey-resources+acpi-scan
>       Merge branch 'pci/yinghai-survey-resources+acpi-scan' into next
>       Merge branch 'pci/rafael-set-root-bridge-handle' into next
>       Merge branch 'acpi-scan' of git://git.kernel.org/.../rafael/linux-pm into pci/acpi-scan2
>       Merge branch 'pci/yijing-ari' into next
>       Merge branch 'pci/acpi-scan2' into next
>       Merge branch 'pci/yinghai-root-bus-hotplug' into next
>       Merge branch 'pci/yinghai-root-bus-hotplug' into next
>       Merge branch 'pci/joe-aspm' into next
>       Merge branch 'pci/misc' into next
>       PCI: Use atomic_inc_return() rather than atomic_add_return()
>       Merge branch 'pci/konstantin-runtime-pm' into next
>       Merge branch 'pci/jiang-pci_slot-kconfig' into next
>       Merge branch 'pci/misc' into next
>       Merge branch 'pci/yinghai-root-bus-hotplug' into next
>
> Jiang Liu (6):
>       ACPI: remove unused acpi_op_bind and acpi_op_unbind
>       PCI: Fix reference count leak in pci_dev_present()
>       PCI: Make device create/destroy logic symmetric
>       PCI: acpiphp: Create companion ACPI devices before creating PCI devices
>       PCI: acpiphp: Remove dead code for PCI host bridge hotplug
>       ACPI / PCI: Make pci_slot built-in only, not a module
>
> Joe Lawrence (1):
>       PCI/ASPM: Don't touch ASPM if forcibly disabled
>
> Konstantin Khlebnikov (2):
>       PCI: Disable Bus Master unconditionally in pci_device_shutdown()
>       PCI: Catch attempts to disable already-disabled devices
>
> Mika Westerberg (1):
>       ACPI / scan: Fix check of device_attach() return value.
>
> Myron Stowe (3):
>       PCI: Introduce accessor to retrieve PCIe Capabilities Register
>       PCI: Use PCI Express Capability accessor
>       PCI/ASPM: Deallocate upstream link state even if device is not PCIe
>
> Paul Bolle (1):
>       PCI: pciehp: Drop suspend/resume ENTRY messages
>
> Rafael J. Wysocki (25):
>       ACPI: Separate adding ACPI device objects from probing ACPI drivers
>       ACPI: Change the ordering of PCI root bridge driver registrarion
>       ACPI: Make acpi_bus_add() and acpi_bus_start() visibly different
>       ACPI: Reduce the usage of struct acpi_bus_ops
>       ACPI: Replace struct acpi_bus_ops with enum type
>       ACPI: Change the ordering of acpi_bus_check_add()
>       ACPI / PCI: Fold acpi_pci_root_start() into acpi_pci_root_add()
>       ACPI: Remove acpi_start_single_object() and acpi_bus_start()
>       ACPI: Remove the arguments of acpi_bus_add() that are not used
>       ACPI: Drop the second argument of acpi_bus_scan()
>       ACPI: Replace ACPI device add_type field with a match_driver flag
>       ACPI: Make acpi_bus_scan() and acpi_bus_add() take only one argument
>       ACPI: Add .setup() and .cleanup() callbacks to struct acpi_bus_type
>       ACPI / PCI: Rework the setup and cleanup of device wakeup
>       ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
>       ACPI: Drop ACPI device .bind() and .unbind() callbacks
>       ACPI / scan: Treat power resources in a special way
>       ACPI / PCI: Set root bridge ACPI handle in advance
>       ACPI: Remove the ops field from struct acpi_device
>       ACPI / scan: Drop the second argument of acpi_device_unregister()
>       ACPI / scan: Drop the second argument of acpi_bus_trim()
>       ACPI / scan: Change the implementation of acpi_bus_trim()
>       ACPI / scan: Add second pass to acpi_bus_trim()
>       ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead
>       PCI/PM: Clear state_saved during suspend
>
> Sasha Levin (1):
>       PCI: cpqphp: Cleanup and remove unreachable paths
>
> Tang Chen (1):
>       PCI/ACPI: Print info if host bridge notify handler installation fails
>
> Yijing Wang (10):
>       PCI: Enable ARI if dev and upstream bridge support it; disable otherwise
>       PCI: Rename pci_enable_ari() to pci_configure_ari()
>       PCI: Consolidate "next-function" functions
>       PCI: pciehp: Iterate over all devices in slot, not functions 0-7
>       PCI: cpcihp: Iterate over all devices in slot, not functions 0-7
>       PCI: sgihp: Iterate over all devices in slot, not functions 0-7
>       PCI: shpchp: Iterate over all devices in slot, not functions 0-7
>       PCI: Document hpiosize= and hpmemsize= resource reservation parameters
>       PCI: Document MPS parameters pci=pcie_bus_safe, pci=pcie_bus_perf, etc
>       PCI: Remove unused "rc" in virtfn_add_bus()
>
> Yinghai Lu (19):
>       x86/PCI: Factor out pcibios_allocate_bridge_resources()
>       x86/PCI: Factor out pcibios_allocate_dev_resources()
>       x86/PCI: Allocate resources on a per-bus basis for hot-adding root buses
>       x86/PCI: Factor out pcibios_allocate_dev_rom_resource()
>       x86/PCI: Don't track firmware-assigned BAR values for hot-added devices
>       x86/PCI: Keep resource allocation functions after boot
>       PCI/ACPI: Reserve firmware-allocated resources for hot-added root buses
>       x86/PCI: Implement pcibios_resource_survey_bus()
>       ACPI: update ej_event interface to take acpi_device
>       PCI: Kill pci_is_reassigndev()
>       PCI: acpiphp: Add is_hotplug_bridge detection
>       PCI: Add root bus children dev's res to fail list
>       PCI: Set pci_dev dev_node early so IOAPIC irq_descs are allocated locally
>       PCI/ACPI: acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work()
>       PCI: acpiphp: Move host bridge hotplug to pci_root.c
>       PCI: acpiphp: Keep driver loaded even if no slots found
>       PCI: Skip attaching driver in device_add()
>       PCI: Put pci_dev in device tree as early as possible
>       PCI/ACPI: Don't cache _PRT, and don't associate them with bus numbers
>
>  Documentation/kernel-parameters.txt     |  21 ++
>  arch/frv/mb93090-mb00/pci-frv.h         |   1 -
>  arch/frv/mb93090-mb00/pci-vdk.c         |   4 +-
>  arch/ia64/pci/pci.c                     |   8 +
>  arch/mn10300/unit-asb2305/pci-asb2305.h |   1 -
>  arch/mn10300/unit-asb2305/pci.c         |   4 +-
>  arch/x86/include/asm/pci.h              |   3 +
>  arch/x86/include/asm/pci_x86.h          |   1 -
>  arch/x86/pci/acpi.c                     |   9 +
>  arch/x86/pci/common.c                   |   1 -
>  arch/x86/pci/i386.c                     | 185 +++++++++++-------
>  arch/x86/pci/legacy.c                   |   2 +-
>  arch/x86/pci/numaq_32.c                 |   2 +-
>  drivers/acpi/Kconfig                    |   5 +-
>  drivers/acpi/Makefile                   |   2 +-
>  drivers/acpi/acpi_memhotplug.c          |  26 +--
>  drivers/acpi/container.c                |  31 +--
>  drivers/acpi/device_pm.c                |   2 +-
>  drivers/acpi/dock.c                     |  17 +-
>  drivers/acpi/glue.c                     |  50 +++--
>  drivers/acpi/internal.h                 |   7 +
>  drivers/acpi/osl.c                      |  24 ++-
>  drivers/acpi/pci_bind.c                 | 122 ------------
>  drivers/acpi/pci_irq.c                  | 102 ++++------
>  drivers/acpi/pci_root.c                 | 233 +++++++++++++---------
>  drivers/acpi/pci_slot.c                 |  13 +-
>  drivers/acpi/processor_driver.c         |  32 +---
>  drivers/acpi/scan.c                     | 330 ++++++++++++--------------------
>  drivers/pci/access.c                    |   6 +-
>  drivers/pci/bus.c                       |  81 ++------
>  drivers/pci/hotplug/acpiphp.h           |  14 +-
>  drivers/pci/hotplug/acpiphp_core.c      |  23 +--
>  drivers/pci/hotplug/acpiphp_glue.c      | 292 ++++++----------------------
>  drivers/pci/hotplug/cpci_hotplug_pci.c  |  29 ++-
>  drivers/pci/hotplug/cpqphp_ctrl.c       |  57 ++----
>  drivers/pci/hotplug/pciehp_core.c       |   2 -
>  drivers/pci/hotplug/pciehp_pci.c        |  44 ++---
>  drivers/pci/hotplug/sgi_hotplug.c       |  73 ++++---
>  drivers/pci/hotplug/shpchp_pci.c        |  36 ++--
>  drivers/pci/iov.c                       |  10 +-
>  drivers/pci/pci-acpi.c                  |  45 +++--
>  drivers/pci/pci-driver.c                |  12 +-
>  drivers/pci/pci.c                       |  80 +++-----
>  drivers/pci/pci.h                       |   9 +-
>  drivers/pci/pcie/aspm.c                 |   8 +-
>  drivers/pci/pcie/portdrv_core.c         |   2 +-
>  drivers/pci/probe.c                     | 104 ++++++----
>  drivers/pci/remove.c                    |   4 +-
>  drivers/pci/search.c                    |  10 +-
>  drivers/pci/setup-bus.c                 |   2 +-
>  include/acpi/acpi_bus.h                 |  35 ++--
>  include/acpi/acpi_drivers.h             |   5 -
>  include/acpi/acpiosxf.h                 |   2 -
>  include/linux/acpi.h                    |   5 +
>  include/linux/pci.h                     |  15 +-
>  55 files changed, 919 insertions(+), 1324 deletions(-)
>  delete mode 100644 drivers/acpi/pci_bind.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--14dae93411b90dbb2b04d66f799f
Content-Type: application/octet-stream; name="fix_pci_merge.patch"
Content-Disposition: attachment; filename="fix_pci_merge.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdjlkk030

LS0tCiBhcmNoL2lhNjQvcGNpL3BjaS5jICAgICAgICAgICAgICAgIHwgICAgNiArLS0tLS0KIGRy
aXZlcnMvYWNwaS9pbnRlcm5hbC5oICAgICAgICAgICAgfCAgICA0IC0tLS0KIGRyaXZlcnMvYWNw
aS9zY2FuLmMgICAgICAgICAgICAgICAgfCAgIDEwICstLS0tLS0tLS0KIGRyaXZlcnMvcGNpL2hv
dHBsdWcvYWNwaXBocF9nbHVlLmMgfCAgIDM1ICsrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCiBkcml2ZXJzL3BjaS9wY2ktYWNwaS5jICAgICAgICAgICAgIHwgICAgOCAtLS0tLS0t
LQogNSBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDU4IGRlbGV0aW9ucygtKQoKSW5k
ZXg6IGxpbnV4LTIuNi9hcmNoL2lhNjQvcGNpL3BjaS5jCj09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIu
Ni5vcmlnL2FyY2gvaWE2NC9wY2kvcGNpLmMKKysrIGxpbnV4LTIuNi9hcmNoL2lhNjQvcGNpL3Bj
aS5jCkBAIC0zOTMsOSArMzkzLDYgQEAgb3V0MToKIAlyZXR1cm4gTlVMTDsKIH0KIAotPDw8PDw8
PCBIRUFECi1zdGF0aWMgaW50IGlzX3ZhbGlkX3Jlc291cmNlKHN0cnVjdCBwY2lfZGV2ICpkZXYs
IGludCBpZHgpCi09PT09PT09CiBpbnQgcGNpYmlvc19yb290X2JyaWRnZV9wcmVwYXJlKHN0cnVj
dCBwY2lfaG9zdF9icmlkZ2UgKmJyaWRnZSkKIHsKIAlzdHJ1Y3QgcGNpX2NvbnRyb2xsZXIgKmNv
bnRyb2xsZXIgPSBicmlkZ2UtPmJ1cy0+c3lzZGF0YTsKQEAgLTQwNCw4ICs0MDEsNyBAQCBpbnQg
cGNpYmlvc19yb290X2JyaWRnZV9wcmVwYXJlKHN0cnVjdCBwCiAJcmV0dXJuIDA7CiB9CiAKLXN0
YXRpYyBpbnQgX19kZXZpbml0IGlzX3ZhbGlkX3Jlc291cmNlKHN0cnVjdCBwY2lfZGV2ICpkZXYs
IGludCBpZHgpCi0+Pj4+Pj4+IHBjaS9uZXh0CitzdGF0aWMgaW50IGlzX3ZhbGlkX3Jlc291cmNl
KHN0cnVjdCBwY2lfZGV2ICpkZXYsIGludCBpZHgpCiB7CiAJdW5zaWduZWQgaW50IGksIHR5cGVf
bWFzayA9IElPUkVTT1VSQ0VfSU8gfCBJT1JFU09VUkNFX01FTTsKIAlzdHJ1Y3QgcmVzb3VyY2Ug
KmRldnIgPSAmZGV2LT5yZXNvdXJjZVtpZHhdLCAqYnVzcjsKSW5kZXg6IGxpbnV4LTIuNi9kcml2
ZXJzL2FjcGkvaW50ZXJuYWwuaAo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJz
L2FjcGkvaW50ZXJuYWwuaAorKysgbGludXgtMi42L2RyaXZlcnMvYWNwaS9pbnRlcm5hbC5oCkBA
IC05NCwxNiArOTQsMTIgQEAgc3RydWN0IGFjcGlfZWMgewogCiBleHRlcm4gc3RydWN0IGFjcGlf
ZWMgKmZpcnN0X2VjOwogCi08PDw8PDw8IEhFQUQKLT09PT09PT0KICNpZmRlZglDT05GSUdfQUNQ
SV9QQ0lfU0xPVAogdm9pZCBhY3BpX3BjaV9zbG90X2luaXQodm9pZCk7CiAjZWxzZQogc3RhdGlj
IGlubGluZSB2b2lkIGFjcGlfcGNpX3Nsb3RfaW5pdCh2b2lkKSB7IH0KICNlbmRpZgotaW50IGFj
cGlfcGNpX3Jvb3RfaW5pdCh2b2lkKTsKIHZvaWQgYWNwaV9wY2lfcm9vdF9ocF9pbml0KHZvaWQp
OwotPj4+Pj4+PiBwY2kvbmV4dAogaW50IGFjcGlfZWNfaW5pdCh2b2lkKTsKIGludCBhY3BpX2Vj
X2VjZHRfcHJvYmUodm9pZCk7CiBpbnQgYWNwaV9ib290X2VjX2VuYWJsZSh2b2lkKTsKSW5kZXg6
IGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvc2Nhbi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5v
cmlnL2RyaXZlcnMvYWNwaS9zY2FuLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvc2Nhbi5j
CkBAIC0xNzc5LDE0ICsxNzc5LDExIEBAIGludCBfX2luaXQgYWNwaV9zY2FuX2luaXQodm9pZCkK
IAl9CiAKIAlhY3BpX3BjaV9yb290X2luaXQoKTsKLTw8PDw8PDwgSEVBRAogCWFjcGlfcGNpX2xp
bmtfaW5pdCgpOwogCWFjcGlfcGxhdGZvcm1faW5pdCgpOwogCWFjcGlfY3NydF9pbml0KCk7CiAJ
YWNwaV9jb250YWluZXJfaW5pdCgpOwotPT09PT09PQogCWFjcGlfcGNpX3Nsb3RfaW5pdCgpOwot
Pj4+Pj4+PiBwY2kvbmV4dAogCiAJbXV0ZXhfbG9jaygmYWNwaV9zY2FuX2xvY2spOwogCS8qCkBA
IC0xODA4LDEzICsxODA1LDggQEAgaW50IF9faW5pdCBhY3BpX3NjYW5faW5pdCh2b2lkKQogCiAJ
YWNwaV91cGRhdGVfYWxsX2dwZXMoKTsKIAotPDw8PDw8PCBIRUFECisJYWNwaV9wY2lfcm9vdF9o
cF9pbml0KCk7CiAgb3V0OgogCW11dGV4X3VubG9jaygmYWNwaV9zY2FuX2xvY2spOwogCXJldHVy
biByZXN1bHQ7Ci09PT09PT09Ci0JYWNwaV9wY2lfcm9vdF9ocF9pbml0KCk7Ci0KLQlyZXR1cm4g
MDsKLT4+Pj4+Pj4gcGNpL25leHQKIH0KSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9ob3Rw
bHVnL2FjcGlwaHBfZ2x1ZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMv
cGNpL2hvdHBsdWcvYWNwaXBocF9nbHVlLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9ob3Rw
bHVnL2FjcGlwaHBfZ2x1ZS5jCkBAIC0xMTM1LDMwICsxMTM1LDEwIEBAIHN0YXRpYyB2b2lkIF9o
YW5kbGVfaG90cGx1Z19ldmVudF9icmlkZ2UKIAlocF93b3JrID0gY29udGFpbmVyX29mKHdvcmss
IHN0cnVjdCBhY3BpX2hwX3dvcmssIHdvcmspOwogCWhhbmRsZSA9IGhwX3dvcmstPmhhbmRsZTsK
IAl0eXBlID0gaHBfd29yay0+dHlwZTsKLTw8PDw8PDwgSEVBRAorCWJyaWRnZSA9IChzdHJ1Y3Qg
YWNwaXBocF9icmlkZ2UgKilocF93b3JrLT5jb250ZXh0OwogCiAJYWNwaV9zY2FuX2xvY2tfYWNx
dWlyZSgpOwogCi0JaWYgKGFjcGlfYnVzX2dldF9kZXZpY2UoaGFuZGxlLCAmZGV2aWNlKSkgewot
CQkvKiBUaGlzIGJyaWRnZSBtdXN0IGhhdmUganVzdCBiZWVuIHBoeXNpY2FsbHkgaW5zZXJ0ZWQg
Ki8KLQkJaGFuZGxlX2JyaWRnZV9pbnNlcnRpb24oaGFuZGxlLCB0eXBlKTsKLQkJZ290byBvdXQ7
Ci0JfQotCi0JYnJpZGdlID0gYWNwaXBocF9oYW5kbGVfdG9fYnJpZGdlKGhhbmRsZSk7Ci0JaWYg
KHR5cGUgPT0gQUNQSV9OT1RJRllfQlVTX0NIRUNLKSB7Ci0JCWFjcGlfd2Fsa19uYW1lc3BhY2Uo
QUNQSV9UWVBFX0RFVklDRSwgaGFuZGxlLCBBQ1BJX1VJTlQzMl9NQVgsCi0JCQljb3VudF9zdWJf
YnJpZGdlcywgTlVMTCwgJm51bV9zdWJfYnJpZGdlcywgTlVMTCk7Ci0JfQotCi0JaWYgKCFicmlk
Z2UgJiYgIW51bV9zdWJfYnJpZGdlcykgewotCQllcnIoImNhbm5vdCBnZXQgYnJpZGdlIGluZm9c
biIpOwotCQlnb3RvIG91dDsKLQl9Ci09PT09PT09Ci0JYnJpZGdlID0gKHN0cnVjdCBhY3BpcGhw
X2JyaWRnZSAqKWhwX3dvcmstPmNvbnRleHQ7Ci0+Pj4+Pj4+IHBjaS9uZXh0Ci0KIAlhY3BpX2dl
dF9uYW1lKGhhbmRsZSwgQUNQSV9GVUxMX1BBVEhOQU1FLCAmYnVmZmVyKTsKIAogCXN3aXRjaCAo
dHlwZSkgewpAQCAtMTIxMywxMSArMTE5Myw3IEBAIHN0YXRpYyB2b2lkIF9oYW5kbGVfaG90cGx1
Z19ldmVudF9icmlkZ2UKIAkJYnJlYWs7CiAJfQogCi08PDw8PDw8IEhFQUQKLW91dDoKIAlhY3Bp
X3NjYW5fbG9ja19yZWxlYXNlKCk7Ci09PT09PT09Ci0+Pj4+Pj4+IHBjaS9uZXh0CiAJa2ZyZWUo
aHBfd29yayk7IC8qIGFsbG9jYXRlZCBpbiBoYW5kbGVfaG90cGx1Z19ldmVudF9icmlkZ2UgKi8K
IH0KIApAQCAtMTI1OCwxNSArMTIzNCwxMCBAQCBzdGF0aWMgdm9pZCBfaGFuZGxlX2hvdHBsdWdf
ZXZlbnRfZnVuYyhzCiAJdHlwZSA9IGhwX3dvcmstPnR5cGU7CiAJZnVuYyA9IChzdHJ1Y3QgYWNw
aXBocF9mdW5jICopaHBfd29yay0+Y29udGV4dDsKIAotCWFjcGlfZ2V0X25hbWUoaGFuZGxlLCBB
Q1BJX0ZVTExfUEFUSE5BTUUsICZidWZmZXIpOwotCi08PDw8PDw8IEhFQUQKLQlmdW5jID0gKHN0
cnVjdCBhY3BpcGhwX2Z1bmMgKiljb250ZXh0OwotCiAJYWNwaV9zY2FuX2xvY2tfYWNxdWlyZSgp
OwogCi09PT09PT09Ci0+Pj4+Pj4+IHBjaS9uZXh0CisJYWNwaV9nZXRfbmFtZShoYW5kbGUsIEFD
UElfRlVMTF9QQVRITkFNRSwgJmJ1ZmZlcik7CisKIAlzd2l0Y2ggKHR5cGUpIHsKIAljYXNlIEFD
UElfTk9USUZZX0JVU19DSEVDSzoKIAkJLyogYnVzIHJlLWVudW1lcmF0ZSAqLwpJbmRleDogbGlu
dXgtMi42L2RyaXZlcnMvcGNpL3BjaS1hY3BpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvZHJpdmVycy9wY2kvcGNpLWFjcGkuYworKysgbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS1h
Y3BpLmMKQEAgLTMyOSwxNCArMzI5LDYgQEAgc3RhdGljIHZvaWQgcGNpX2FjcGlfY2xlYW51cChz
dHJ1Y3QgZGV2aQogCQlkZXZpY2Vfc2V0X3J1bl93YWtlKGRldiwgZmFsc2UpOwogCQlwY2lfYWNw
aV9yZW1vdmVfcG1fbm90aWZpZXIoYWRldik7CiAJfQotPDw8PDw8PCBIRUFECi0KLQlpZiAocGNp
X2Rldi0+c3Vib3JkaW5hdGUpCi0JCWFjcGlfcGNpX2lycV9kZWxfcHJ0KHBjaV9kb21haW5fbnIo
cGNpX2Rldi0+YnVzKSwKLQkJCQkgICAgIHBjaV9kZXYtPnN1Ym9yZGluYXRlLT5udW1iZXIpOwot
PT09PT09PQotCWFjcGlfcG93ZXJfcmVzb3VyY2VfdW5yZWdpc3Rlcl9kZXZpY2UoZGV2LCBoYW5k
bGUpOwotPj4+Pj4+PiBwY2kvbmV4dAogfQogCiBzdGF0aWMgc3RydWN0IGFjcGlfYnVzX3R5cGUg
YWNwaV9wY2lfYnVzID0gewo=
--14dae93411b90dbb2b04d66f799f--
