Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3BKGka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:40:30 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:38696 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3BKGk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:40:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
References: <Pine.LNX.4.44L0.1302051520220.2245-100000@iolanthe.rowland.org>
	<1360466060.3703.15.camel@thor.lan>
	<1360506199.3461.5.camel@thor.lan>
	<CAE9FiQX0Jzqi=Dy=r3MoU9vK7HgAf+919LvbgLygW7VH3O4=bg@mail.gmail.com>
Date: Sun, 10 Feb 2013 22:40:28 -0800
X-Google-Sender-Auth: g6KymtqIgeLE1UyT8wF1LAP94ZE
Message-ID: <CAE9FiQX5wQ8zFzPfgmvm0BESyLVxzDRQ33XPgj+QjBZ0kxuHXg@mail.gmail.com>
Subject: Re: [Bisected] [-next-20130204] usb/hcd: irq 18: nobody cared
From: Yinghai Lu <yinghai@kernel.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Content-Type: multipart/mixed; boundary=14dae9340a7f4ab1ed04d56d2f9f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--14dae9340a7f4ab1ed04d56d2f9f
Content-Type: text/plain; charset=ISO-8859-1

On Sun, Feb 10, 2013 at 12:33 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, Feb 10, 2013 at 6:23 AM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> On Sat, 2013-02-09 at 22:14 -0500, Peter Hurley wrote:
>>> On Tue, 2013-02-05 at 15:26 -0500, Alan Stern wrote:
>>> > On Tue, 5 Feb 2013, Peter Hurley wrote:
>>> >
>>> > > With -next-20130204:
>>> > >
>>> > > [   33.855570] irq 18: nobody cared (try booting with the "irqpoll" option)
>>> > > [   33.855580] Pid: 0, comm: swapper/4 Not tainted 3.8.0-next-20130204-xeon #20130204
>>> > > [   33.855582] Call Trace:
>>> > > [   33.855585]  <IRQ>  [<ffffffff810f1076>] __report_bad_irq+0x36/0xe0
>>> > > [   33.855600]  [<ffffffff810f152a>] note_interrupt+0x1aa/0x200
>>> > > [   33.855606]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>>> > > [   33.855610]  [<ffffffff810eed89>] handle_irq_event_percpu+0xc9/0x260
>>> > > [   33.855614]  [<ffffffff810eef68>] handle_irq_event+0x48/0x70
>>> > > [   33.855618]  [<ffffffff810f20ba>] handle_fasteoi_irq+0x5a/0x100
>>> > > [   33.855624]  [<ffffffff810182f2>] handle_irq+0x22/0x40
>>> > > [   33.855630]  [<ffffffff816e2a9a>] do_IRQ+0x5a/0xd0
>>> > > [   33.855636]  [<ffffffff816d97ad>] common_interrupt+0x6d/0x6d
>>> > > [   33.855638]  <EOI>  [<ffffffff810f8e2a>] ? rcu_eqs_enter_common+0x4a/0x320
>>> > > [   33.855646]  [<ffffffff8101edf2>] ? mwait_idle+0x82/0x1b0
>>> > > [   33.855649]  [<ffffffff8101ed99>] ? mwait_idle+0x29/0x1b0
>>> > > [   33.855653]  [<ffffffff8101f8a6>] cpu_idle+0x116/0x130
>>> > > [   33.855658]  [<ffffffff816c0c0f>] start_secondary+0x251/0x258
>>> > > [   33.855660] handlers:
>>> > > [   33.855664] [<ffffffff814f98a0>] usb_hcd_irq
>>> > > [   33.855667] Disabling IRQ #18
>>> > >
>> https://bugzilla.kernel.org/show_bug.cgi?id=53561
>>
>> Maybe this is some interaction with all the new ACPI code and fixes
>> written in those 8 days.
>
> interrupt routing seems get changed:
> next:
>    5:          0          0          0          0          0
> 0          0          0   IO-APIC-fasteoi   snd_ctxfi
>   18:      99970         13         16         20      99940
> 13         13         16   IO-APIC-fasteoi   uhci_hcd:usb4
> v3.8-rc7:
>   18:        424         15         11        112        420
> 16         18        105   IO-APIC-fasteoi   uhci_hcd:usb4, snd_ctxfi
>
> These messages in the bad dmesg log are interesting since PCI INT A is routed
> on
> irq 18 with the kernels that work.
> [    8.983246] pci 0000:00:1e.0: can't derive routing for PCI INT A
> [    8.983600] snd_ctxfi 0000:09:02.0: PCI INT A: no GSI - using ISA IRQ 5
> ...
>
> acpi_pci_irq_add_prt() add wrong bus for that bridge, because that
> that bridge is not scanned.
>
> Will check if I can produce one patch for it.

Hi Peter,

Can you try attached debug patch?

Thanks

Yinghai

--14dae9340a7f4ab1ed04d56d2f9f
Content-Type: application/octet-stream; name="move_add_irq_prt_down.patch"
Content-Disposition: attachment; filename="move_add_irq_prt_down.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hd193p3m0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL2J1cy5jIGIvZHJpdmVycy9wY2kvYnVzLmMKaW5kZXgg
ODY0N2RjNi4uZTkwMTkwMiAxMDA2NDQKLS0tIGEvZHJpdmVycy9wY2kvYnVzLmMKKysrIGIvZHJp
dmVycy9wY2kvYnVzLmMKQEAgLTE2MCw2ICsxNjAsOCBAQCBwY2lfYnVzX2FsbG9jX3Jlc291cmNl
KHN0cnVjdCBwY2lfYnVzICpidXMsIHN0cnVjdCByZXNvdXJjZSAqcmVzLAogCiB2b2lkIF9fd2Vh
ayBwY2liaW9zX3Jlc291cmNlX3N1cnZleV9idXMoc3RydWN0IHBjaV9idXMgKmJ1cykgeyB9CiAK
K3ZvaWQgX193ZWFrIHBjaWJpb3NfaXJxX3NldHVwKHN0cnVjdCBkZXZpY2UgKmRldikgeyB9CisK
IC8qKgogICogcGNpX2J1c19hZGRfZGV2aWNlIC0gc3RhcnQgZHJpdmVyIGZvciBhIHNpbmdsZSBk
ZXZpY2UKICAqIEBkZXY6IGRldmljZSB0byBhZGQKQEAgLTE3MCw2ICsxNzIsOSBAQCBpbnQgcGNp
X2J1c19hZGRfZGV2aWNlKHN0cnVjdCBwY2lfZGV2ICpkZXYpCiB7CiAJaW50IHJldHZhbDsKIAor
CS8qIG5lZWQgdG8gYWZ0ZXIgYnJpZGdlIGlzIHNjYW5uZWQgKi8KKwlwY2liaW9zX2lycV9zZXR1
cCgmZGV2LT5kZXYpOworCiAJLyoKIAkgKiBDYW4gbm90IHB1dCBpbiBwY2lfZGV2aWNlX2FkZCB5
ZXQgYmVjYXVzZSByZXNvdXJjZXMKIAkgKiBhcmUgbm90IGFzc2lnbmVkIHlldCBmb3Igc29tZSBk
ZXZpY2VzLgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvcGNpLWFjcGkuYyBiL2RyaXZlcnMvcGNp
L3BjaS1hY3BpLmMKaW5kZXggYmE0NTQ1Zi4uODdiZDgwYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9w
Y2kvcGNpLWFjcGkuYworKysgYi9kcml2ZXJzL3BjaS9wY2ktYWNwaS5jCkBAIC0zMDIsMTQgKzMw
MiwxNiBAQCBzdGF0aWMgaW50IGFjcGlfcGNpX2ZpbmRfZGV2aWNlKHN0cnVjdCBkZXZpY2UgKmRl
diwgYWNwaV9oYW5kbGUgKmhhbmRsZSkKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQgcGNp
X2FjcGlfc2V0dXAoc3RydWN0IGRldmljZSAqZGV2KQordm9pZCBwY2liaW9zX2lycV9zZXR1cChz
dHJ1Y3QgZGV2aWNlICpkZXYpCiB7CiAJc3RydWN0IHBjaV9kZXYgKnBjaV9kZXYgPSB0b19wY2lf
ZGV2KGRldik7CiAJYWNwaV9oYW5kbGUgaGFuZGxlID0gQUNQSV9IQU5ETEUoZGV2KTsKLQlzdHJ1
Y3QgYWNwaV9kZXZpY2UgKmFkZXY7CiAJYWNwaV9zdGF0dXMgc3RhdHVzOwogCWFjcGlfaGFuZGxl
IGR1bW15OwogCisJaWYgKGFjcGlfZGlzYWJsZWQgfHwgYWNwaV9wY2lfZGlzYWJsZWQpCisJCXJl
dHVybjsKKwogCS8qCiAJICogRXZhbHVhdGUgYW5kIHBhcnNlIF9QUlQsIGlmIGV4aXN0cy4gIFRo
aXMgY29kZSBhbGxvd3MgcGFyc2luZyBvZgogCSAqIF9QUlQgb2JqZWN0cyB3aXRoaW4gdGhlIHNj
b3BlIG9mIG5vbi1icmlkZ2UgZGV2aWNlcy4gIE5vdGUgdGhhdApAQCAtMzI2LDYgKzMyOCwxMyBA
QCBzdGF0aWMgdm9pZCBwY2lfYWNwaV9zZXR1cChzdHJ1Y3QgZGV2aWNlICpkZXYpCiAJCQlwY2lf
ZGV2LT5zdWJvcmRpbmF0ZS0+bnVtYmVyIDogcGNpX2Rldi0+YnVzLT5udW1iZXI7CiAJCWFjcGlf
cGNpX2lycV9hZGRfcHJ0KGhhbmRsZSwgcGNpX2RvbWFpbl9ucihwY2lfZGV2LT5idXMpLCBidXMp
OwogCX0KK30KKworc3RhdGljIHZvaWQgcGNpX2FjcGlfc2V0dXAoc3RydWN0IGRldmljZSAqZGV2
KQoreworCXN0cnVjdCBwY2lfZGV2ICpwY2lfZGV2ID0gdG9fcGNpX2RldihkZXYpOworCWFjcGlf
aGFuZGxlIGhhbmRsZSA9IEFDUElfSEFORExFKGRldik7CisJc3RydWN0IGFjcGlfZGV2aWNlICph
ZGV2OwogCiAJaWYgKGFjcGlfYnVzX2dldF9kZXZpY2UoaGFuZGxlLCAmYWRldikgfHwgIWFkZXYt
Pndha2V1cC5mbGFncy52YWxpZCkKIAkJcmV0dXJuOwo=
--14dae9340a7f4ab1ed04d56d2f9f--
