Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbaGNUV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:21:59 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:50769 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757099AbaGNUVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:21:55 -0400
Date: Mon, 14 Jul 2014 22:21:52 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1174271881.20140714222152@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: konrad@kernel.org, xen-devel@lists.xenproject.org,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v4] PCI back fixes for 3.17.
In-Reply-To: <20140714201817.GD23791@laptop.dumpdata.com>
References: <20140714172225.GA10497@laptop.dumpdata.com> <652296445.20140714192923@eikelenboom.it> <20140714173753.GB12920@laptop.dumpdata.com> <9210423415.20140714194304@eikelenboom.it> <20140714174525.GD12920@laptop.dumpdata.com> <1332864311.20140714202433@eikelenboom.it> <20140714184547.GA18896@laptop.dumpdata.com> <1499016487.20140714210129@eikelenboom.it> <20140714195405.GA20567@laptop.dumpdata.com> <6110472183.20140714221618@eikelenboom.it> <20140714201817.GD23791@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Monday, July 14, 2014, 10:18:17 PM, you wrote:

> On Mon, Jul 14, 2014 at 10:16:18PM +0200, Sander Eikelenboom wrote:
>> 
>> Monday, July 14, 2014, 9:54:05 PM, you wrote:
>> 
>> > On Mon, Jul 14, 2014 at 09:01:29PM +0200, Sander Eikelenboom wrote:
>> >> 
>> >> Monday, July 14, 2014, 8:45:47 PM, you wrote:
>> >> 
>> >> > On Mon, Jul 14, 2014 at 08:24:33PM +0200, Sander Eikelenboom wrote:
>> >> >> 
>> >> >> Monday, July 14, 2014, 7:45:25 PM, you wrote:
>> >> >> 
>> >> >> > On Mon, Jul 14, 2014 at 07:43:04PM +0200, Sander Eikelenboom wrote:
>> >> >> >> 
>> >> >> >> Monday, July 14, 2014, 7:37:53 PM, you wrote:
>> >> >> >> 
>> >> >> >> >> >> Ad B)
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-list router
>> >> >> >> >> >> Vdev Device
>> >> >> >> >> >> 05.0 0000:00:1b.0
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-assignable-list
>> >> >> >> >> >> 0000:02:00.0
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-detach router 00:1b.0
>> >> >> >> >> >> dmesg shows:
>> >> >> >> >> >> [  199.742668] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> >> >> >> >> >> [  199.743527] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> >> >> >> >> >> [  199.744321] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> >> >> >> >> >> [  199.757184] xen-pciback pci-1-0: xen_pcibk_xenbus_remove freeing pdev @ 0xffff8800589fce40
>> >> >> >> >> >> [  199.758139] xen-pciback pci-1-0: xen_pcibk_disconnect pdev @ 0xffff8800589fce40
>> >> >> >> >> >> [  199.862595] xen: xen_unregister_device_domain_owner
>> >> >> >> >> >> 
>> >> >> >> >> >> xl dmesg shows:
>> >> >> >> >> >> (XEN) [2014-07-14 16:28:29] memory_map:remove: dom1 gfn=f3070 mfn=f7d30 nr=4
>> >> >> >> >> >> (XEN) [2014-07-14 16:28:29] io.c:322: d1: unbind: m_gsi=22 g_gsi=36 dev=00:00.5 intx=0
>> >> >> >> >> >> (XEN) [2014-07-14 16:28:29] io.c:390: d1 unmap: m_irq=22 dev=00:00.5 intx=0
>> >> >> >> >> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1579: d1:PCIe: unmap 0000:00:1b.0
>> >> >> >> >> >> (XEN) [2014-07-14 16:28:29] [VT-D]iommu.c:1440: d0:PCIe: map 0000:00:1b.0
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-list router
>> >> >> >> >> >> root@dom0:~# xl pci-assignable-list
>> >> >> >> >> >> 0000:00:1b.0
>> >> >> >> >> >> 0000:02:00.0
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-assignable-remove 00:1b.0
>> >> >> >> >> >> dmesg shows:
>> >> >> >> >> >> [  318.827415] xen: xen_unregister_device_domain_owner
>> >> >> >> >> >> [  318.828771] xen: xen_unregister_device_domain_owner: ENODEV
>> >> >> >> >> >> [  318.930869] pciback 0000:00:1b.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7d30004)
>> >> >> >> >> >> [  318.933435] pciback 0000:00:1b.0: restoring config space at offset 0xc (was 0x0, writing 0x10)
>> >> >> >> >> >> [  318.935877] pciback 0000:00:1b.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> >> >> >> >> >> 
>> >> >> >> >> >> root@dom0:~# xl pci-list router
>> >> >> >> >> >> root@dom0:~# xl pci-assignable-list
>> >> >> >> >> >> 0000:02:00.0
>> >> >> >> >> >> 
>> >> >> >> >> >> 
>> >> >> >> >> 
>> >> >> >> >> > And if you do:
>> >> >> >> >> 
>> >> >> >> >> > # xl pci-detach router 02:00.0
>> >> >> >> >> 
>> >> >> >> 
>> >> >> >> > Err, I meant
>> >> >> >> > # xl pci-assignable-remove 02:00.0
>> >> >> >> 
>> >> >> >> Ah ok .. so that is:
>> >> >> >> remove a device from pciback that has never been assigned to any guest .. 
>> >> >> >> 
>> >> >> >> will also give that a go .. although that probably won't be a problem. 
>> >> >> 
>> >> >> > Right. So I think it all works as expected? That is if you have
>> >> >> > two PCI devices assigned to a guest and want to re-use them you
>> >> >> > have to do the 'pci-detach' twice and then follow that with
>> >> >> >  'pci-assignable-remove' twice as well?
>> >> >> 
>> >> >> Well except that's not what i want :-) .. that's about the same as shutting down 
>> >> >> the guest .. and indeed that works :-)
>> >> >> 
>> >> >> What i want to do is to remove just *one* device and leave the other one in the guest.
>> >> >> 
>> >> >> The one that i remove .. i would like to be able to remove it from being 
>> >> >> assignable .. (rebind it in dom0) and/or assign it to another guest.
>> >> 
>> >> > Aha
>> >> >> 
>> >> >> And that fails because pciback still thinks the guest owns the device ..
>> >> >> while libxl thinks it doesn't (outcome of xl pci-assignable-list).
>> >> 
>> >> > Oh
>> >> >> 
>> >> >> When doing the:
>> >> >> 
>> >> >> # xl pci-assignable-list
>> >> >> 0000:02:00.0
>> >> >> # xl pci-assignable-remove 02:00.0
>> >> >> dmesg shows:               
>> >> >> [  443.292951] xen: xen_unregister_device_domain_owner
>> >> >> [  443.294308] xen: xen_unregister_device_domain_owner: ENODEV
>> >> >> [  443.398827] pciback 0000:02:00.0: restoring config space at offset 0x3c (was 0x100, writing 0x104)
>> >> >> [  443.400797] pciback 0000:02:00.0: restoring config space at offset 0x10 (was 0x4, writing 0xf7c00004)
>> >> >> [  443.401713] pciback 0000:02:00.0: restoring config space at offset 0x4 (was 0x100000, writing 0x100006)
>> >> >> 
>> >> >> which i think is what is expected ..
>> >> 
>> >> > Right.
>> >> 
>> >> >> 
>> >> >> 
>> >> >> Hmm  /sys/bus/pci/drivers/pciback  doesn't shed much light, because in the state 
>> >> >> just after a xl pci-detach, the device is still registred by pciback (from dom0's 
>> >> >> view) which is correct, what is wrong is that pciback still seems to think that 
>> >> >> it is in turn still owned by the guest. That doesn't get reflected in the info 
>> >> >> available in the /sys dir.
>> >> 
>> >> > Oh
>> >> >> 
>> >> >> Ok over to xen-store ... 
>> >> 
>> >> > I think I had a patch for that in libxl. It was the order of operations it was
>> >> > doing - it did the 'unbind' first and then it did the XenBus operations.
>> >> 
>> >> >> 
>> >> >> first a diff between the booted guest with two devices passed through and the 
>> >> >> state after the "xl pci-detach router 00:1b.0"
>> >> >> 
>> >> >> root@creanuc:~# diff -U10 xs-before-detach-first.txt xs-after-detach-first.txt
>> >> >> --- xs-before-detach-first.txt  2014-07-14 19:56:23.233576000 +0200
>> >> >> +++ xs-after-detach-first.txt   2014-07-14 20:00:00.053576000 +0200
>> >> >> @@ -185,35 +185,29 @@
>> >> >>         feature-rx-flip = "0"
>> >> >>         feature-split-event-channels = "1"
>> >> >>         multi-queue-max-queues = "4"
>> >> >>         hotplug-status = "connected"
>> >> >>      pci = ""
>> >> >>       1 = ""
>> >> >>        0 = ""
>> >> >>         frontend = "/local/domain/1/device/pci/0"
>> >> >>         frontend-id = "1"
>> >> >>         online = "1"
>> >> >> -       state = "3"
>> >> >> +       state = "7"
>> >> >>         domain = "router"
>> >> >>         key-0 = "0000:02:00.0"
>> >> >>         dev-0 = "0000:02:00.0"
>> >> >>         vdevfn-0 = "28"
>> >> >>         opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >> >>         state-0 = "3"
>> >> >> -       key-1 = "0000:00:1b.0"
>> >> >> -       dev-1 = "0000:00:1b.0"
>> >> >> -       vdevfn-1 = "30"
>> >> >> -       opts-1 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >> >> -       state-1 = "3"
>> >> >> -       num_devs = "2"
>> >> >> +       num_devs = "1"
>> >> >>         vdev-0 = "0000:00:00.00"
>> >> >> -       vdev-1 = "0000:00:01.00"
>> >> >>         root-0 = "0000:00"
>> >> >>         root_num = "1"
>> >> >>    1 = ""
>> >> >>     vm = "/vm/a102d97e-8388-414e-97e5-cc394656c47d"
>> >> >>     name = "router"
>> >> >>     cpu = ""
>> >> >>      0 = ""
>> >> >>       availability = "online"
>> >> >>      1 = ""
>> >> >>       availability = "online"
>> >> >> 
>> >> >> It seems ok, perhaps apart from the general pci state going from 3 to 7 ?
>> >> >> Haven't looked up the exact states, but since only one domain is removes i would 
>> >> >> still expect it to be 3 ?
>> >> 
>> >> > 7 is Reconfiguring which is what it should move to (to update the XenBus).
>> >> 
>> >> Ok, but that should than be acknowledged somewhere by someone i suppose .. and 
>> >> not stay in that state ?
>> >> 
>> >> >> 
>> >> >> 
>> >> >> Now a diff before and after the "xl pci-assignable-remove 00:1b.0"
>> >> >> diff xs-after-detach-first.txt xs-after-pci-assignable-remove-first.txt is 
>> >> >> empty, as expected since this is a pciback only thing now involving any guest.
>> >> >> 
>> >> >> 
>> >> >> And now the last diff, between the state before and after the "xl pci-detach 
>> >> >> 02:00.0" removing the last pci device from the guest.
>> >> >> 
>> >> >> root@creanuc:~# diff -U5 xs-after-pci-assignable-remove-first.txt xs-after-pci-detach-second.txt
>> >> >> --- xs-after-pci-assignable-remove-first.txt    2014-07-14 20:00:45.161576000 +0200
>> >> >> +++ xs-after-pci-detach-second.txt      2014-07-14 20:01:20.177576000 +0200
>> >> >> @@ -184,27 +184,10 @@
>> >> >>         feature-rx-copy = "1"
>> >> >>         feature-rx-flip = "0"
>> >> >>         feature-split-event-channels = "1"
>> >> >>         multi-queue-max-queues = "4"
>> >> >>         hotplug-status = "connected"
>> >> >> -    pci = ""
>> >> >> -     1 = ""
>> >> >> -      0 = ""
>> >> >> -       frontend = "/local/domain/1/device/pci/0"
>> >> >> -       frontend-id = "1"
>> >> >> -       online = "1"
>> >> >> -       state = "7"
>> >> >> -       domain = "router"
>> >> >> -       key-0 = "0000:02:00.0"
>> >> >> -       dev-0 = "0000:02:00.0"
>> >> >> -       vdevfn-0 = "28"
>> >> >> -       opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >> >> -       state-0 = "3"
>> >> >> -       num_devs = "1"
>> >> >> -       vdev-0 = "0000:00:00.00"
>> >> >> -       root-0 = "0000:00"
>> >> >> -       root_num = "1"
>> >> >>    1 = ""
>> >> >>     vm = "/vm/a102d97e-8388-414e-97e5-cc394656c47d"
>> >> >>     name = "router"
>> >> >>     cpu = ""
>> >> >>      0 = ""
>> >> >> @@ -249,15 +232,10 @@
>> >> >>        event-channel-rx = "25"
>> >> >>        request-rx-copy = "1"
>> >> >>        feature-rx-notify = "1"
>> >> >>        feature-sg = "1"
>> >> >>        feature-gso-tcpv4 = "1"
>> >> >> -    pci = ""
>> >> >> -     0 = ""
>> >> >> -      backend = "/local/domain/0/backend/pci/1/0"
>> >> >> -      backend-id = "0"
>> >> >> -      state = "1"
>> >> >>     control = ""
>> >> >>      shutdown = ""
>> >> >>      platform-feature-multiprocessor-suspend = "1"
>> >> >>      platform-feature-xs_reset_watches = "1"
>> >> >>     hvmloader = ""
>> >> >> 
>> >> >> That seems ok.
>> >> >> 
>> >> >> So apart from that perhaps incorrect general pci state change, the info in 
>> >> >> xenstore seems to be OK.
>> >> >> 
>> >> >> So it does seem to be a lack of pciback receiving a confirm from libxl / qemu that the 
>> >> >> device is indeed removed from the guest for the final deregistring of the 
>> >> >> ownership.
>> >> >> 
>> >> >> Because after a pci-detach the pci device is:
>> >> >> - removed from xen-store as attached to the guest
>> >> >> - the iommu has assigned/mapped it back to dom0
>> >> >> - xl pci-assignable-list shows it as assignable again
>> >> >> 
>> >> >> So only pciback is the only one left out of the party :-)
>> >> >> Couldn't it be somehow tied to the iommu events, since it should be in sync with that i suppose ?
>> >> 
>> >> 
>> >> > Let me find out what is up with this. Once the device
>> >> > is de-assigned from a guest (even if forcefully) it should
>> >> > be possible to assign it to another.
>> >> 
>> >> Yes .. at least for the rebinding to dom0 case, because the 
>> >> pci-assignable-remove seems to do it forcefully now. But i haven't tried what it 
>> >> does when reassigning to another guest (if it forcefully swaps ownership then, 
>> >> since the pci-assignable-remove isn't involved then).
>> >> 
>> >> Will give the xen patch a try.
>> 
>> > I found out what the problem is. It has been in the code for eons and 
>> > I think we never tested for it because the older toolstack (xend) would
>> > do things differently.
>> 
>> That .. and probably not many people testing .. 
>> Until now i used the automatic assign and deassign on guest creation
>> and shutdown which doesn't exhibit this problem.
>> 
>> > The issue here is:
>> 
>> >  1) xl pci-detach <dom-id> <BDF>
>> 
>> > 'xl' removes the whole device from the XenStore, so from:
>> >        domain = "USB"
>> 
>> >        vdevfn-0 = "28" 
>> >        opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >        state-0 = "3"
>> >        vdev-0 = "0000:00:00.00"
>> >        root-0 = "0000:00"
>> >        key-0 = "0000:07:00.0"
>> >        dev-0 = "0000:07:00.0"
>> 
>> >        key-1 = "0000:04:00.0"
>> >        dev-1 = "0000:04:00.0"
>> >        vdevfn-1 = "30" 
>> >        opts-1 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >        state-1 = "3"
>> >        num_devs = "2"
>> >        vdev-1 = "0000:00:01.00"
>> >        root_num = "1"
>> 
>> > it just yanks out the '*-1' values, so we have:
>> 
>> >        domain = "USB"
>> 
>> >        vdevfn-0 = "28" 
>> >        opts-0 = "msitranslate=0,power_mgmt=0,permissive=0"
>> >        state-0 = "3"
>> >        vdev-0 = "0000:00:00.00"
>> >        root-0 = "0000:00"
>> >        key-0 = "0000:07:00.0"
>> >        dev-0 = "0000:07:00.0"
>> 
>> >         num_devs = "1"
>> 
>> > While if the frontend was PV (so xen-pcifront) it would first but
>> > the state-1 to 5 (Closed) which would let the Xen pciback deallocate this.
>> 
>> > Anyhow, Xen pciback should be able to deal with this, but the patch
>> > is going to take a bit of time to figure out.
>> 
>> > Thank you for reporting it and helping me with the XenStore output to
>> > narrow down the culprit!
>> 
>> The thing i don't understand then is:
>> How is it different for the last (or all ) device(s) ?
>> (since the last device (or removing all devices) before doing the 
>> assignable-remove doesn't trigger the warning)
>> 
>> Or does the complete removal of the pci-part of the tree in xenstore trigger something ?

> Yup. It removes the whole 'pci' directory in XenStore which triggers
> in Xen pciback the code to deal with that.
So that essentially needs to be changed to watch the individual devices in the 
xenstore tree instead of the whole pci stuff.
Then it all makes sense :-)  

>> You know if you got a patch cooked up, i'm more than happy to test !

> Hehe!
>> 
>> --
>> Sander
>> 


