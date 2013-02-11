Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab3BKTT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:19:57 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42707 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab3BKTTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:19:55 -0500
MIME-Version: 1.0
In-Reply-To: <1360587768.3454.2.camel@thor.lan>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	<1360466060.3703.15.camel@thor.lan>
	<1360506199.3461.5.camel@thor.lan>
	<CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
	<CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
	<1360587768.3454.2.camel@thor.lan>
Date: Mon, 11 Feb 2013 11:19:54 -0800
X-Google-Sender-Auth: Jb4NFbQUc5SwOR0UfKgll8uUmac
Message-ID: <CAE9FiQWUZ3BgLOtcGePppLzWBv-uR8L+7abditH2MNA7zZW-WA@mail.gmail.com>
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: multipart/mixed; boundary=90e6ba6e83b43db9f104d577cbc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6e83b43db9f104d577cbc2
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Feb 11, 2013 at 5:02 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On Sun, 2013-02-10 at 22:40 -0800, Yinghai Lu wrote:
>> On Sun, Feb 10, 2013 at 12:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > On Sun, Feb 10, 2013 at 6:23 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> >> On Sat, 2013-02-09 at 22:14 -0500, Peter Hurley wrote:
>> >>> On Tue, 2013-02-05 at 15:26 -0500, Alan Stern wrote:
>> >>> > On Tue, 5 Feb 2013, Peter Hurley wrote:
>> >>> >
>> >>> > > With -next-20130204:
>> >>> > >
>> >>> > > [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
>> >>> > > [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
>> >>> > > [   33.855582] Call Trace:
>> >>> > > [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
>> >>> > > [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
>> >>> > > [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>> >>> > > [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
>> >>> > > [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
>> >>> > > [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
>> >>> > > [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
>> >>> > > [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
>> >>> > > [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
>> >>> > > [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
>> >>> > > [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>> >>> > > [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
>> >>> > > [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
>> >>> > > [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
>> >>> > > [   33.855660] handlers:
>> >>> > > [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
>> >>> > > [   33.855667] Disabling IRQ #18
>> >>> > >
>> >> https://bugzilla.kernel.org/show_bug.cgi?id=53561
>> >>
>> >> Maybe this is some interaction with all the new ACPI code and fixes
>> >> written in those 8 days.
>> >
>> > interrupt routing seems get changed:
>> > next:
>> >    5:          0          0          0          0          0
>> > 0          0          0   IO-APIC-fasteoi   snd_ctxfi
>> >   18:      99970         13         16         20      99940
>> > 13         13         16   IO-APIC-fasteoi   uhci_hcd:usb4
>> > v3.8-rc7:
>> >   18:        424         15         11        112        420
>> > 16         18        105   IO-APIC-fasteoi   uhci_hcd:usb4, snd_ctxfi
>> >
>> > These messages in the bad dmesg log are interesting since PCI INT A is routed
>> > on
>> > irq 18 with the kernels that work.
>> > [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
>> > [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
>> > ...
>> >
>> > acpi_pci_irq_add_prt() add wrong bus for that bridge, because that
>> > that bridge is not scanned.
>> >
>> > Will check if I can produce one patch for it.
>>
>> Hi Peter,
>>
>> Can you try attached debug patch?
>
> Fixed, thanks.

Bjorn, Rafael,

acpi_pci_irq_add_prt need to be called after pci bridge get scanned,
so we can not call it from pci_acpi_setup, after we move dev_register
for pci_dev early.

The attached debug patch move down that calling into
pci_bus_add_devices and that will make prt works again.

Can acpi provide another hook after bridge get scanned?

Thanks

Yinghai

--90e6ba6e83b43db9f104d577cbc2
Content-Type: application/octet-stream; name="move_add_irq_prt_down.patch"
Content-Disposition: attachment; filename="move_add_irq_prt_down.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hd20albn0

LS0tCiBkcml2ZXJzL3BjaS9idXMuYyAgICAgIHwgICAgNSArKysrKwogZHJpdmVycy9wY2kvcGNp
LWFjcGkuYyB8ICAgMTMgKysrKysrKysrKystLQogMiBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6IGxpbnV4LTIuNi9kcml2ZXJzL3BjaS9idXMu
Ywo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJzL3BjaS9idXMuYworKysgbGlu
dXgtMi42L2RyaXZlcnMvcGNpL2J1cy5jCkBAIC0xNjAsNiArMTYwLDggQEAgcGNpX2J1c19hbGxv
Y19yZXNvdXJjZShzdHJ1Y3QgcGNpX2J1cyAqYgogCiB2b2lkIF9fd2VhayBwY2liaW9zX3Jlc291
cmNlX3N1cnZleV9idXMoc3RydWN0IHBjaV9idXMgKmJ1cykgeyB9CiAKK3ZvaWQgX193ZWFrIHBj
aWJpb3NfaXJxX3NldHVwKHN0cnVjdCBkZXZpY2UgKmRldikgeyB9CisKIC8qKgogICogcGNpX2J1
c19hZGRfZGV2aWNlIC0gc3RhcnQgZHJpdmVyIGZvciBhIHNpbmdsZSBkZXZpY2UKICAqIEBkZXY6
IGRldmljZSB0byBhZGQKQEAgLTE3MCw2ICsxNzIsOSBAQCBpbnQgcGNpX2J1c19hZGRfZGV2aWNl
KHN0cnVjdCBwY2lfZGV2ICpkCiB7CiAJaW50IHJldHZhbDsKIAorCS8qIG5lZWQgdG8gYWZ0ZXIg
YnJpZGdlIGlzIHNjYW5uZWQgKi8KKwlwY2liaW9zX2lycV9zZXR1cCgmZGV2LT5kZXYpOworCiAJ
LyoKIAkgKiBDYW4gbm90IHB1dCBpbiBwY2lfZGV2aWNlX2FkZCB5ZXQgYmVjYXVzZSByZXNvdXJj
ZXMKIAkgKiBhcmUgbm90IGFzc2lnbmVkIHlldCBmb3Igc29tZSBkZXZpY2VzLgpJbmRleDogbGlu
dXgtMi42L2RyaXZlcnMvcGNpL3BjaS1hY3BpLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9y
aWcvZHJpdmVycy9wY2kvcGNpLWFjcGkuYworKysgbGludXgtMi42L2RyaXZlcnMvcGNpL3BjaS1h
Y3BpLmMKQEAgLTMwMiwxNCArMzAyLDE2IEBAIHN0YXRpYyBpbnQgYWNwaV9wY2lfZmluZF9kZXZp
Y2Uoc3RydWN0IGQKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQgcGNpX2FjcGlfc2V0dXAo
c3RydWN0IGRldmljZSAqZGV2KQordm9pZCBwY2liaW9zX2lycV9zZXR1cChzdHJ1Y3QgZGV2aWNl
ICpkZXYpCiB7CiAJc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYgPSB0b19wY2lfZGV2KGRldik7CiAJ
YWNwaV9oYW5kbGUgaGFuZGxlID0gQUNQSV9IQU5ETEUoZGV2KTsKLQlzdHJ1Y3QgYWNwaV9kZXZp
Y2UgKmFkZXY7CiAJYWNwaV9zdGF0dXMgc3RhdHVzOwogCWFjcGlfaGFuZGxlIGR1bW15OwogCisJ
aWYgKGFjcGlfZGlzYWJsZWQgfHwgYWNwaV9wY2lfZGlzYWJsZWQpCisJCXJldHVybjsKKwogCS8q
CiAJICogRXZhbHVhdGUgYW5kIHBhcnNlIF9QUlQsIGlmIGV4aXN0cy4gIFRoaXMgY29kZSBhbGxv
d3MgcGFyc2luZyBvZgogCSAqIF9QUlQgb2JqZWN0cyB3aXRoaW4gdGhlIHNjb3BlIG9mIG5vbi1i
cmlkZ2UgZGV2aWNlcy4gIE5vdGUgdGhhdApAQCAtMzI2LDYgKzMyOCwxMyBAQCBzdGF0aWMgdm9p
ZCBwY2lfYWNwaV9zZXR1cChzdHJ1Y3QgZGV2aWNlCiAJCQlwY2lfZGV2LT5zdWJvcmRpbmF0ZS0+
bnVtYmVyIDogcGNpX2Rldi0+YnVzLT5udW1iZXI7CiAJCWFjcGlfcGNpX2lycV9hZGRfcHJ0KGhh
bmRsZSwgcGNpX2RvbWFpbl9ucihwY2lfZGV2LT5idXMpLCBidXMpOwogCX0KK30KKworc3RhdGlj
IHZvaWQgcGNpX2FjcGlfc2V0dXAoc3RydWN0IGRldmljZSAqZGV2KQoreworCXN0cnVjdCBwY2lf
ZGV2ICpwY2lfZGV2ID0gdG9fcGNpX2RldihkZXYpOworCWFjcGlfaGFuZGxlIGhhbmRsZSA9IEFD
UElfSEFORExFKGRldik7CisJc3RydWN0IGFjcGlfZGV2aWNlICphZGV2OwogCiAJaWYgKGFjcGlf
YnVzX2dldF9kZXZpY2UoaGFuZGxlLCAmYWRldikgfHwgIWFkZXYtPndha2V1cC5mbGFncy52YWxp
ZCkKIAkJcmV0dXJuOwo=
--90e6ba6e83b43db9f104d577cbc2--
