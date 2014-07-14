Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaGNSqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 14:46:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaGNSqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 14:46:05 -0400
Date: Mon, 14 Jul 2014 14:45:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
Message-ID: <20140714184547.GA18896@laptop.dumpdata.com>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
 <768165707.20140714183755@eikelenboom.it>
 <20140714172225.GA10497@laptop.dumpdata.com>
 <652296445.20140714192923@eikelenboom.it>
 <20140714173753.GB12920@laptop.dumpdata.com>
 <9210423415.20140714194304@eikelenboom.it>
 <20140714174525.GD12920@laptop.dumpdata.com>
 <1332864311.20140714202433@eikelenboom.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
In-Reply-To: <1332864311.20140714202433@eikelenboom.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 14, 2014 at 08:24:33PM +0200, Sander Eikelenboom wrote:
> 
> Monday, July 14, 2014, 7:45:25 PM, you wrote:
> 
> > On Mon, Jul 14, 2014 at 07:43:04PM +0200, Sander Eikelenboom wrote:
> >> 
> >> Monday, July 14, 2014, 7:37:53 PM, you wrote:
> >> 
> >> >> >> Ad B)
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-list router
> >> >> >> Vdev Device
> >> >> >> 05.0 0000:00:1b.0
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-assignable-list
> >> >> >> 0000:02:00.0
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-detach router 00:1b.0
> >> >> >> dmesg shows:
> >> >> >> [  199.742668] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
> >> >> >> [  199.743527] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
> >> >> >> [  199.744321] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
> >> >> >> [  199.757184] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff8800589fce40
> >> >> >> [  199.758139] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff8800589fce40
> >> >> >> [  199.862595] xen: xen_unregister_device_domain_owner
> >> >> >> 
> >> >> >> xl dmesg shows:
> >> >> >> (XEN) [2014-07-14 16:28:29] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
> >> >> >> (XEN) [2014-07-14 16:28:29] io.c:322: d1: unbind: m_gsi=22 g_gsi=36 dev=00:00.5 intx=0
> >> >> >> (XEN) [2014-07-14 16:28:29] io.c:390: d1 unmap: m_irq=22 dev=00:00.5 intx=0
> >> >> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
> >> >> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-list router
> >> >> >> root@dom0:~# xl pci-assignable-list
> >> >> >> 0000:00:1b.0
> >> >> >> 0000:02:00.0
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-assignable-remove 00:1b.0
> >> >> >> dmesg shows:
> >> >> >> [  318.827415] xen: xen_unregister_device_domain_owner
> >> >> >> [  318.828771] xen: xen_unregister_device_domain_owner: ENODEV
> >> >> >> [  318.930869] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
> >> >> >> [  318.933435] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
> >> >> >> [  318.935877] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
> >> >> >> 
> >> >> >> root@dom0:~# xl pci-list router
> >> >> >> root@dom0:~# xl pci-assignable-list
> >> >> >> 0000:02:00.0
> >> >> >> 
> >> >> >> 
> >> >> 
> >> >> > And if you do:
> >> >> 
> >> >> > # xl pci-detach router 02:00.0
> >> >> 
> >> 
> >> > Err, I meant
> >> > # xl pci-assignable-remove 02:00.0
> >> 
> >> Ah ok .. so that is:
> >> remove a device from pciback that has never been assigned to any guest .. 
> >> 
> >> will also give that a go .. although that probably won't be a problem. 
> 
> > Right. So I think it all works as expected? That is if you have
> > two PCI devices assigned to a guest and want to re-use them you
> > have to do the 'pci-detach' twice and then follow that with
> >  'pci-assignable-remove' twice as well?
> 
> Well except that's not what i want :-) .. that's about the same as shutting down 
> the guest .. and indeed that works :-)
> 
> What i want to do is to remove just *one* device and leave the other one in the guest.
> 
> The one that i remove .. i would like to be able to remove it from being 
> assignable .. (rebind it in dom0) and/or assign it to another guest.

Aha
> 
> And that fails because pciback still thinks the guest owns the device ..
> while libxl thinks it doesn't (outcome of xl pci-assignable-list).

Oh
> 
> When doing the:
> 
> # xl pci-assignable-list
> 0000:02:00.0
> # xl pci-assignable-remove 02:00.0
> dmesg shows:               
> [  443.292951] xen: xen_unregister_device_domain_owner
> [  443.294308] xen: xen_unregister_device_domain_owner: ENODEV
> [  443.398827] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
> [  443.400797] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
> [  443.401713] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
> 
> which i think is what is expected ..

Right.

> 
> 
> Hmm  /sys/bus/pci/drivers/pciback  doesn't shed much light, because in the state 
> just after a xl pci-detach, the device is still registred by pciback (from dom0's 
> view) which is correct, what is wrong is that pciback still seems to think that 
> it is in turn still owned by the guest. That doesn't get reflected in the info 
> available in the /sys dir.

Oh
> 
> Ok over to xen-store ... 

I think I had a patch for that in libxl. It was the order of operations it was
doing - it did the 'unbind' first and then it did the XenBus operations.

> 
> first a diff between the booted guest with two devices passed through and the 
> state after the "xl pci-detach router 00:1b.0"
> 
> root@creanuc:~# diff -U10 xs-before-detach-first.txt xs-after-detach-first.txt
> --- xs-before-detach-first.txt  2014-07-14 19:56:23.233576000 +0200
> +++ xs-after-detach-first.txt   2014-07-14 20:00:00.053576000 +0200
> @@ -185,35 +185,29 @@
>         feature-rx-flip = "0"
>         feature-split-event-channels = "1"
>         multi-queue-max-queues = "4"
>         hotplug-status = "connected"
>      pci = ""
>       1 = ""
>        0 = ""
>         frontend = "/local/domain/1/device/pci/0"
>         frontend-id = "1"
>         online = "1"
> -       state = "3"
> +       state = "7"
>         domain = "router"
>         key-0 = "0000:02:00.0"
>         dev-0 = "0000:02:00.0"
>         vdevfn-0 = "28"
>         opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
>         state-0 = "3"
> -       key-1 = "0000:00:1b.0"
> -       dev-1 = "0000:00:1b.0"
> -       vdevfn-1 = "30"
> -       opts-1 = "msitranslate=0,power_mgmt=0,permissive=0"
> -       state-1 = "3"
> -       num_devs = "2"
> +       num_devs = "1"
>         vdev-0 = "0000:00:00.00"
> -       vdev-1 = "0000:00:01.00"
>         root-0 = "0000:00"
>         root_num = "1"
>    1 = ""
>     vm = "/vm/a102d97e-8388-414e-97e5-cc394656c47d"
>     name = "router"
>     cpu = ""
>      0 = ""
>       availability = "online"
>      1 = ""
>       availability = "online"
> 
> It seems ok, perhaps apart from the general pci state going from 3 to 7 ?
> Haven't looked up the exact states, but since only one domain is removes i would 
> still expect it to be 3 ?

7 is Reconfiguring which is what it should move to (to update the XenBus).
> 
> 
> Now a diff before and after the "xl pci-assignable-remove 00:1b.0"
> diff xs-after-detach-first.txt xs-after-pci-assignable-remove-first.txt is 
> empty, as expected since this is a pciback only thing now involving any guest.
> 
> 
> And now the last diff, between the state before and after the "xl pci-detach 
> 02:00.0" removing the last pci device from the guest.
> 
> root@creanuc:~# diff -U5 xs-after-pci-assignable-remove-first.txt xs-after-pci-detach-second.txt
> --- xs-after-pci-assignable-remove-first.txt    2014-07-14 20:00:45.161576000 +0200
> +++ xs-after-pci-detach-second.txt      2014-07-14 20:01:20.177576000 +0200
> @@ -184,27 +184,10 @@
>         feature-rx-copy = "1"
>         feature-rx-flip = "0"
>         feature-split-event-channels = "1"
>         multi-queue-max-queues = "4"
>         hotplug-status = "connected"
> -    pci = ""
> -     1 = ""
> -      0 = ""
> -       frontend = "/local/domain/1/device/pci/0"
> -       frontend-id = "1"
> -       online = "1"
> -       state = "7"
> -       domain = "router"
> -       key-0 = "0000:02:00.0"
> -       dev-0 = "0000:02:00.0"
> -       vdevfn-0 = "28"
> -       opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
> -       state-0 = "3"
> -       num_devs = "1"
> -       vdev-0 = "0000:00:00.00"
> -       root-0 = "0000:00"
> -       root_num = "1"
>    1 = ""
>     vm = "/vm/a102d97e-8388-414e-97e5-cc394656c47d"
>     name = "router"
>     cpu = ""
>      0 = ""
> @@ -249,15 +232,10 @@
>        event-channel-rx = "25"
>        request-rx-copy = "1"
>        feature-rx-notify = "1"
>        feature-sg = "1"
>        feature-gso-tcpv4 = "1"
> -    pci = ""
> -     0 = ""
> -      backend = "/local/domain/0/backend/pci/1/0"
> -      backend-id = "0"
> -      state = "1"
>     control = ""
>      shutdown = ""
>      platform-feature-multiprocessor-suspend = "1"
>      platform-feature-xs_reset_watches = "1"
>     hvmloader = ""
> 
> That seems ok.
> 
> So apart from that perhaps incorrect general pci state change, the info in 
> xenstore seems to be OK.
> 
> So it does seem to be a lack of pciback receiving a confirm from libxl / qemu that the 
> device is indeed removed from the guest for the final deregistring of the 
> ownership.
> 
> Because after a pci-detach the pci device is:
> - removed from xen-store as attached to the guest
> - the iommu has assigned/mapped it back to dom0
> - xl pci-assignable-list shows it as assignable again
> 
> So only pciback is the only one left out of the party :-)
> Couldn't it be somehow tied to the iommu events, since it should be in sync with that i suppose ?


Let me find out what is up with this. Once the device
is de-assigned from a guest (even if forcefully) it should
be possible to assign it to another.

> 
> --
> Sander
> 
> BTW, i don't see the "do_flr" anywhere in /sys/*/pciback/ ?

We been having a lengthy discussion about this and David is out
on vacation so will have to wait until he is back.
> 

--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="libxl_pci.patch"

commit 7fb699eced1e58b25203d7f6bae9ef44318d8e6b
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Tue Apr 22 09:58:28 2014 -0400

    libxl: give pciback a chance to do its teardown before we reset the device.
    
    We try to reset the device before we signal the pciback that
    the device is no longer to be used by the guest. As such
    we should give the pciback (or QEMU) a chance first to
    some cleanup before we deploy the sledghammer approach
    of resetting the device.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/tools/libxl/libxl_pci.c b/tools/libxl/libxl_pci.c
index 44d0453..5a7cc9e 100644
--- a/tools/libxl/libxl_pci.c
+++ b/tools/libxl/libxl_pci.c
@@ -1260,6 +1260,8 @@ skip1:
         abort();
     }
 out:
+    libxl__device_pci_remove_xenstore(gc, domid, pcidev);
+
     /* don't do multiple resets while some functions are still passed through */
     if ( (pcidev->vdevfn & 0x7) == 0 ) {
         libxl__device_pci_reset(gc, pcidev->domain, pcidev->bus, pcidev->dev, pcidev->func);
@@ -1277,8 +1279,6 @@ out:
         libxl__device_pci_remove_common(gc, stubdomid, &pcidev_s, force);
     }
 
-    libxl__device_pci_remove_xenstore(gc, domid, pcidev);
-
     rc = 0;
 out_fail:
     free(assigned);

--UugvWAfsgieZRqgk--
