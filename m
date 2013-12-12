Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3LLXRx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:17:53 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38207 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab3LLXRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:17:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo46LZP8t+aLnYOtJ1mXKKkCF7sOy97MFd0hWo+OOoz68Q@mail.gmail.com>
References: <20131127184652.GA1856@kroah.com>
	<CAErSpo46LZP8t+aLnYOtJ1mXKKkCF7sOy97MFd0hWo+OOoz68Q@mail.gmail.com>
Date: Thu, 12 Dec 2013 15:17:50 -0800
X-Google-Sender-Auth: yAFROvn0EsV_Z7LUMJFqRN061tU
Message-ID: <CAE9FiQUeyxN5OAaXqfhdQkzTwjV83BN-L3r6kH0sO0t1b1-63Q@mail.gmail.com>
Subject: Re: [PATCH] PCI: export MSI mode using attributes, not kobjects
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=e89a8f5038e2f1ce5404ed5e8d18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f5038e2f1ce5404ed5e8d18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 7, 2013 at 12:41 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Nov 27, 2013 at 11:46 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> The PCI MSI sysfs code is a mess with kobjects for things that don't
>> really need to be kobjects.  This patch creates attributes dynamically
>> for the MSI interrupts instead of using kobjects.
>>
>> Note, this removes a directory from the current MSI interrupt sysfs
>> code:
>>
>> old MSI kobjects:
>> pci_device
>>    =E2=94=94=E2=94=80=E2=94=80 msi_irqs
>>        =E2=94=94=E2=94=80=E2=94=80 40
>>            =E2=94=94=E2=94=80=E2=94=80 mode
>>
>> new MSI attributes:
>> pci_device
>>    =E2=94=94=E2=94=80=E2=94=80 msi_irqs
>>        =E2=94=94=E2=94=80=E2=94=80 40
>>
>> As there was only one file "mode" with the kobject model, the interrupt
>> number is now a file that returns the "mode" of the interrupt (msi vs.
>> msix).
>>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> I added the acks from Neil and Veaceslav, folded in the
> Documentation/ABI update, and applied the whole thing to my pci/misc
> branch for v3.14.  Thanks!

got:
[   71.429735] BUG: key ffff887fcf082a58 not in .data!
[   71.429737] ------------[ cut here ]------------
[   71.429742] WARNING: CPU: 0 PID: 4 at kernel/locking/lockdep.c:2987 lock=
dep_i
nit_map+0x127/0x5b0()
[   71.429743] DEBUG_LOCKS_WARN_ON(1)
[   71.429744] Modules linked in:
[   71.429747] CPU: 0 PID: 4 Comm: kworker/0:0 Tainted: G          I  3.13.=
0-rc3
-yh-01187-ge0e4e4e-dirty #45
[   71.429757] Workqueue: events work_for_cpu_fn
[   71.429792]  0000000000000009 ffff881fcf95da58 ffffffff82020475 ffff881f=
cf95d
aa0
[   71.429800]  ffff881fcf95da90 ffffffff81097c3d ffff887fcf082a58 ffff88df=
cec1a
d28
[   71.429809]  0000000000000000 0000000000000000 ffff889fcf2eecd0 ffff881f=
cf95d
af0
[   71.429809] Call Trace:
[   71.429814]  [<ffffffff82020475>] dump_stack+0x45/0x56
[   71.429818]  [<ffffffff81097c3d>] warn_slowpath_common+0x7d/0xa0
[   71.429822]  [<ffffffff81097cac>] warn_slowpath_fmt+0x4c/0x50
[   71.429826]  [<ffffffff810e3d97>] lockdep_init_map+0x127/0x5b0
[   71.429835]  [<ffffffff81242fe8>] ? sysfs_new_dirent+0x98/0x140
[   71.429839]  [<ffffffff81242033>] sysfs_add_file_mode_ns+0x63/0xc0
[   71.429843]  [<ffffffff8124491d>] internal_create_group+0x18d/0x260
[   71.429853]  [<ffffffff81556345>] ? populate_msi_sysfs+0x185/0x1d0
[   71.429857]  [<ffffffff81244a52>] sysfs_create_groups+0x42/0xa0
[   71.429861]  [<ffffffff81556367>] populate_msi_sysfs+0x1a7/0x1d0
[   71.429865]  [<ffffffff81556b67>] pci_enable_msi_block+0x1f7/0x2a0
[   71.429870]  [<ffffffff81549795>] pcie_port_device_register+0x335/0x520
[   71.429874]  [<ffffffff81549f08>] pcie_portdrv_probe+0x68/0xa0
[   71.429883]  [<ffffffff8153cf75>] local_pci_probe+0x45/0xa0
[   71.429887]  [<ffffffff810b0af4>] work_for_cpu_fn+0x14/0x20
[   71.429891]  [<ffffffff810b431b>] process_one_work+0x28b/0x4a0
[   71.429895]  [<ffffffff810b4292>] ? process_one_work+0x202/0x4a0
[   71.429899]  [<ffffffff810b55db>] worker_thread+0x26b/0x3a0
[   71.429903]  [<ffffffff810e262d>] ? trace_hardirqs_on+0xd/0x10
[   71.429906]  [<ffffffff810b5370>] ? manage_workers.isra.17+0x340/0x340
[   71.429912]  [<ffffffff810bc031>] kthread+0x111/0x120
[   71.429919]  [<ffffffff810cddab>] ? local_clock+0x2b/0x40
[   71.429923]  [<ffffffff810bbf20>] ? kthread_stop+0xf0/0xf0
[   71.429927]  [<ffffffff8203842c>] ret_from_fork+0x7c/0xb0
[   71.429931]  [<ffffffff810bbf20>] ? kthread_stop+0xf0/0xf0
[   71.429933] ---[ end trace c511e3d74efea94e ]---

looks like Greg forgot adding attr init.

Can you fold attached patch into Greg's patch ?

Index: linux-2.6/drivers/pci/msi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/pci/msi.c
+++ linux-2.6/drivers/pci/msi.c
@@ -547,6 +547,7 @@ static int populate_msi_sysfs(struct pci
                msi_dev_attr =3D kzalloc(sizeof(*msi_dev_attr), GFP_KERNEL)=
;
                if (!msi_dev_attr)
                        return -ENOMEM;
+               sysfs_attr_init(&msi_dev_attr->attr);
                sprintf(name, "%d", entry->irq);
                msi_dev_attr->attr.name =3D name;
                msi_dev_attr->attr.mode =3D S_IRUGO;

--e89a8f5038e2f1ce5404ed5e8d18
Content-Type: text/x-patch; charset=US-ASCII; name="fix_key_data.patch"
Content-Disposition: attachment; filename="fix_key_data.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hp4mmxo30

LS0tCiBkcml2ZXJzL3BjaS9tc2kuYyB8ICAgIDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspCgpJbmRleDogbGludXgtMi42L2RyaXZlcnMvcGNpL21zaS5jCj09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0t
IGxpbnV4LTIuNi5vcmlnL2RyaXZlcnMvcGNpL21zaS5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9w
Y2kvbXNpLmMKQEAgLTU0Nyw2ICs1NDcsNyBAQCBzdGF0aWMgaW50IHBvcHVsYXRlX21zaV9zeXNm
cyhzdHJ1Y3QgcGNpCiAJCW1zaV9kZXZfYXR0ciA9IGt6YWxsb2Moc2l6ZW9mKCptc2lfZGV2X2F0
dHIpLCBHRlBfS0VSTkVMKTsKIAkJaWYgKCFtc2lfZGV2X2F0dHIpCiAJCQlyZXR1cm4gLUVOT01F
TTsKKwkJc3lzZnNfYXR0cl9pbml0KCZtc2lfZGV2X2F0dHItPmF0dHIpOwogCQlzcHJpbnRmKG5h
bWUsICIlZCIsIGVudHJ5LT5pcnEpOwogCQltc2lfZGV2X2F0dHItPmF0dHIubmFtZSA9IG5hbWU7
CiAJCW1zaV9kZXZfYXR0ci0+YXR0ci5tb2RlID0gU19JUlVHTzsK
--e89a8f5038e2f1ce5404ed5e8d18--
