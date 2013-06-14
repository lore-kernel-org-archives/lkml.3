Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3FNRCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:02:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59966 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3FNRC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:02:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5nxKi+dNDRn95GtufddncnsC2VyP+NWa=QBMt0aH3AoA@mail.gmail.com>
References: <op.wyn5vzc89ey1ta@localhost>
	<CAErSpo5nxKi+dNDRn95GtufddncnsC2VyP+NWa=QBMt0aH3AoA@mail.gmail.com>
Date: Sat, 15 Jun 2013 01:02:25 +0800
Message-ID: <CACVXFVPSGcBHj1tPfr16ORkuhkjTvDN3CHJv1Ke=W731pFxU4g@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
From: Ming Lei <ming.lei@canonical.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: nirinA raseliarison <nirina.raseliarison@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>, nic_swsd@realtek.com,
        Hayes Wang <hayeswang@realtek.com>, Guenter Roeck <linux@roeck-us.net>
Content-Type: multipart/mixed; boundary=001a11c22b320cb8f304df203642
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001a11c22b320cb8f304df203642
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jun 14, 2013 at 10:30 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Ming, Hayes, Francois, r8169 list]
>
> On Fri, Jun 14, 2013 at 6:49 AM, nirinA raseliarison
> <nirina.raseliarison@gmail.com> wrote:
>> hello there,
>> i have this ethernet controler:
>>
>>  Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet
>> controller (rev 05)
>>
>> that uses the r8169 module.
>> it works fine, but sometimes after a reboot and issueing:
>>
>>  ifconfig eth0 192.168.1.1 up
>>
>> i got the message below. after another reboot the
>> message disappears. i also get the same message this 3.9.5 and 3.9.4.
>>
>> it seems i catch my first oops and don't know what to do with it.
>> currently running:
>>
>>  cat /proc/version
>>  Linux version 3.9.6.20130614 (root@supernova) (gcc version 4.8.1 (GCC) ) #1
>> SMP Fri Jun 14 09:14:50 EAT 2013
>>
>>  uname -a
>>  Linux supernova 3.9.6.20130614 #1 SMP Fri Jun 14 09:14:50 EAT 2013 x86_64
>> Intel(R) Celeron(R) CPU G1610 @ 2.60GHz GenuineIntel GNU/Linux
>>
>> thanks,
>> -----------------8<------------------------------8<---------------------------------------
>>
>> [   57.877560] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000040
>> [   57.877603] IP: [<ffffffff81491844>] fw_load_abort.isra.5+0x4/0x20
>> [   57.877634] PGD 21330a067 PUD 211a3a067 PMD 0
>> [   57.877660] Oops: 0002 [#1] SMP
>> [   57.877681] Modules linked in: fuse coretemp kvm_intel kvm evdev r8169
>> microcode mii
>> [   57.877735] CPU 0
>> [   57.877746] Pid: 1950, comm: firmware Not tainted 3.9.6.20130614 #1 To be
>> filled by O.E.M. To be filled by O.E.M./ONDA H61V Ver:4.01
>> [   57.877790] RIP: 0010:[<ffffffff81491844>]  [<ffffffff81491844>]
>> fw_load_abort.isra.5+0x4/0x20
>> [   57.877824] RSP: 0018:ffff8802119a7e80  EFLAGS: 00010246
>> [   57.877844] RAX: ffff8802158fe250 RBX: ffff880211a03b40 RCX:
>> 0000000000000000
>> [   57.877869] RDX: ffffffff81c742c8 RSI: ffff8802158fe250 RDI:
>> 0000000000000000
>> [   57.877895] RBP: ffff8802119a7e80 R08: ffff8802119a6000 R09:
>> 00000000000005aa
>> [   57.877920] R10: 0000000000000000 R11: 0000000000000000 R12:
>> ffffffffffffffff
>> [   57.877945] R13: ffff880213d34088 R14: 0000000000000003 R15:
>> ffff88020eafc230
>> [   57.877970] FS:  00007f3c6cb2a740(0000) GS:ffff88021f200000(0000)
>> knlGS:0000000000000000
>> [   57.877998] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   57.878019] CR2: 0000000000000040 CR3: 0000000203155000 CR4:
>> 00000000001407f0
>> [   57.878044] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000
>> [   57.878069] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400
>> [   57.878094] Process firmware (pid: 1950, threadinfo ffff8802119a6000,
>> task ffff8802158fe250)
>> [   57.878124] Stack:
>> [   57.878133]  ffff8802119a7eb0 ffffffff81491917 ffff880211a4d5a0
>> 0000000000000003
>> [   57.878168]  ffff8802119a7f50 ffffffff818765a0 ffff8802119a7ec0
>> ffffffff81483063
>> [   57.878203]  ffff8802119a7f08 ffffffff8119bc9e ffff880213d34098
>> ffff880211a4d5c0
>> [   57.878237] Call Trace:
>> [   57.878251]  [<ffffffff81491917>] firmware_loading_store+0x77/0x150
>> [   57.878275]  [<ffffffff81483063>] dev_attr_store+0x13/0x20
>> [   57.878297]  [<ffffffff8119bc9e>] sysfs_write_file+0xce/0x140
>> [   57.878320]  [<ffffffff81133e8a>] vfs_write+0x9a/0x160
>> [   57.878340]  [<ffffffff81134164>] sys_write+0x44/0x90
>> [   57.878360]  [<ffffffff817d70ed>] system_call_fastpath+0x1a/0x1f
>> [   57.879379] Code: 6b ff ff ff 48 89 df 31 db e8 b9 b0 c9 ff e9 79 ff ff
>> ff 0f 1f 40 00 48 83 c4 10 5b 41 5c 41 5d 41 5e 5d c3 0f 1f 00 55 48 89 e5
>> <f0> 80 4f 40 04 48 83 c7 18 e8 8e a9 bd ff 5d c3 66 66 66 2e 0f
>> [   57.881753] RIP  [<ffffffff81491844>] fw_load_abort.isra.5+0x4/0x20
>> [   57.882888]  RSP <ffff8802119a7e80>
>> [   57.884019] CR2: 0000000000000040
>> [   57.885166] ---[ end trace 6705f6d4ce6b6a12 ]---

Looks it is a double abort race, could you try below patch?
(also attached for applying)

--
diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 6ede229..a217ba8 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -550,7 +550,12 @@ static ssize_t firmware_loading_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
-	int loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
+	int loading = 0;
+
+	mutex_lock(&fw_lock);
+	if (fw_priv->buf)
+		loading = test_bit(FW_STATUS_LOADING, &fw_priv->buf->status);
+	mutex_unlock(&fw_lock);

 	return sprintf(buf, "%d\n", loading);
 }
@@ -592,12 +597,12 @@ static ssize_t firmware_loading_store(struct device *dev,
 				      const char *buf, size_t count)
 {
 	struct firmware_priv *fw_priv = to_firmware_priv(dev);
-	struct firmware_buf *fw_buf = fw_priv->buf;
+	struct firmware_buf *fw_buf;
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;

 	mutex_lock(&fw_lock);
-
+	fw_buf = fw_priv->buf;
 	if (!fw_buf)
 		goto out;

@@ -636,6 +641,7 @@ static ssize_t firmware_loading_store(struct device *dev,
 		/* fallthrough */
 	case -1:
 		fw_load_abort(fw_buf);
+		fw_priv->buf = NULL;
 		break;
 	}
 out:
@@ -704,6 +710,7 @@ static int fw_realloc_buffer(struct firmware_priv
*fw_priv, int min_size)
 				    GFP_KERNEL);
 		if (!new_pages) {
 			fw_load_abort(buf);
+			fw_priv->buf = NULL;
 			return -ENOMEM;
 		}
 		memcpy(new_pages, buf->pages,
@@ -721,6 +728,7 @@ static int fw_realloc_buffer(struct firmware_priv
*fw_priv, int min_size)

 		if (!buf->pages[buf->nr_pages]) {
 			fw_load_abort(buf);
+			fw_priv->buf = NULL;
 			return -ENOMEM;
 		}
 		buf->nr_pages++;
@@ -805,6 +813,7 @@ static void firmware_class_timeout_work(struct
work_struct *work)
 		return;
 	}
 	fw_load_abort(fw_priv->buf);
+	fw_priv->buf = NULL;
 	mutex_unlock(&fw_lock);
 }

@@ -886,8 +895,6 @@ static int _request_firmware_load(struct
firmware_priv *fw_priv, bool uevent,

 	cancel_delayed_work_sync(&fw_priv->timeout_work);

-	fw_priv->buf = NULL;
-
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);


Thanks,
--
Ming Lei

--001a11c22b320cb8f304df203642
Content-Type: application/octet-stream; name="fw-double-abort.patch"
Content-Disposition: attachment; filename="fw-double-abort.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhxminc40

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jIGIvZHJpdmVycy9iYXNl
L2Zpcm13YXJlX2NsYXNzLmMKaW5kZXggNmVkZTIyOS4uYTIxN2JhOCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9iYXNlL2Zpcm13YXJlX2NsYXNzLmMKKysrIGIvZHJpdmVycy9iYXNlL2Zpcm13YXJlX2Ns
YXNzLmMKQEAgLTU1MCw3ICs1NTAsMTIgQEAgc3RhdGljIHNzaXplX3QgZmlybXdhcmVfbG9hZGlu
Z19zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJCQkgICAgIHN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlICphdHRyLCBjaGFyICpidWYpCiB7CiAJc3RydWN0IGZpcm13YXJlX3ByaXYgKmZ3X3ByaXYg
PSB0b19maXJtd2FyZV9wcml2KGRldik7Ci0JaW50IGxvYWRpbmcgPSB0ZXN0X2JpdChGV19TVEFU
VVNfTE9BRElORywgJmZ3X3ByaXYtPmJ1Zi0+c3RhdHVzKTsKKwlpbnQgbG9hZGluZyA9IDA7CisK
KwltdXRleF9sb2NrKCZmd19sb2NrKTsKKwlpZiAoZndfcHJpdi0+YnVmKQorCQlsb2FkaW5nID0g
dGVzdF9iaXQoRldfU1RBVFVTX0xPQURJTkcsICZmd19wcml2LT5idWYtPnN0YXR1cyk7CisJbXV0
ZXhfdW5sb2NrKCZmd19sb2NrKTsKIAogCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCBsb2Fk
aW5nKTsKIH0KQEAgLTU5MiwxMiArNTk3LDEyIEBAIHN0YXRpYyBzc2l6ZV90IGZpcm13YXJlX2xv
YWRpbmdfc3RvcmUoc3RydWN0IGRldmljZSAqZGV2LAogCQkJCSAgICAgIGNvbnN0IGNoYXIgKmJ1
Ziwgc2l6ZV90IGNvdW50KQogewogCXN0cnVjdCBmaXJtd2FyZV9wcml2ICpmd19wcml2ID0gdG9f
ZmlybXdhcmVfcHJpdihkZXYpOwotCXN0cnVjdCBmaXJtd2FyZV9idWYgKmZ3X2J1ZiA9IGZ3X3By
aXYtPmJ1ZjsKKwlzdHJ1Y3QgZmlybXdhcmVfYnVmICpmd19idWY7CiAJaW50IGxvYWRpbmcgPSBz
aW1wbGVfc3RydG9sKGJ1ZiwgTlVMTCwgMTApOwogCWludCBpOwogCiAJbXV0ZXhfbG9jaygmZndf
bG9jayk7Ci0KKwlmd19idWYgPSBmd19wcml2LT5idWY7CiAJaWYgKCFmd19idWYpCiAJCWdvdG8g
b3V0OwogCkBAIC02MzYsNiArNjQxLDcgQEAgc3RhdGljIHNzaXplX3QgZmlybXdhcmVfbG9hZGlu
Z19zdG9yZShzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJCS8qIGZhbGx0aHJvdWdoICovCiAJY2FzZSAt
MToKIAkJZndfbG9hZF9hYm9ydChmd19idWYpOworCQlmd19wcml2LT5idWYgPSBOVUxMOwogCQli
cmVhazsKIAl9CiBvdXQ6CkBAIC03MDQsNiArNzEwLDcgQEAgc3RhdGljIGludCBmd19yZWFsbG9j
X2J1ZmZlcihzdHJ1Y3QgZmlybXdhcmVfcHJpdiAqZndfcHJpdiwgaW50IG1pbl9zaXplKQogCQkJ
CSAgICBHRlBfS0VSTkVMKTsKIAkJaWYgKCFuZXdfcGFnZXMpIHsKIAkJCWZ3X2xvYWRfYWJvcnQo
YnVmKTsKKwkJCWZ3X3ByaXYtPmJ1ZiA9IE5VTEw7CiAJCQlyZXR1cm4gLUVOT01FTTsKIAkJfQog
CQltZW1jcHkobmV3X3BhZ2VzLCBidWYtPnBhZ2VzLApAQCAtNzIxLDYgKzcyOCw3IEBAIHN0YXRp
YyBpbnQgZndfcmVhbGxvY19idWZmZXIoc3RydWN0IGZpcm13YXJlX3ByaXYgKmZ3X3ByaXYsIGlu
dCBtaW5fc2l6ZSkKIAogCQlpZiAoIWJ1Zi0+cGFnZXNbYnVmLT5ucl9wYWdlc10pIHsKIAkJCWZ3
X2xvYWRfYWJvcnQoYnVmKTsKKwkJCWZ3X3ByaXYtPmJ1ZiA9IE5VTEw7CiAJCQlyZXR1cm4gLUVO
T01FTTsKIAkJfQogCQlidWYtPm5yX3BhZ2VzKys7CkBAIC04MDUsNiArODEzLDcgQEAgc3RhdGlj
IHZvaWQgZmlybXdhcmVfY2xhc3NfdGltZW91dF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29y
aykKIAkJcmV0dXJuOwogCX0KIAlmd19sb2FkX2Fib3J0KGZ3X3ByaXYtPmJ1Zik7CisJZndfcHJp
di0+YnVmID0gTlVMTDsKIAltdXRleF91bmxvY2soJmZ3X2xvY2spOwogfQogCkBAIC04ODYsOCAr
ODk1LDYgQEAgc3RhdGljIGludCBfcmVxdWVzdF9maXJtd2FyZV9sb2FkKHN0cnVjdCBmaXJtd2Fy
ZV9wcml2ICpmd19wcml2LCBib29sIHVldmVudCwKIAogCWNhbmNlbF9kZWxheWVkX3dvcmtfc3lu
YygmZndfcHJpdi0+dGltZW91dF93b3JrKTsKIAotCWZ3X3ByaXYtPmJ1ZiA9IE5VTEw7Ci0KIAlk
ZXZpY2VfcmVtb3ZlX2ZpbGUoZl9kZXYsICZkZXZfYXR0cl9sb2FkaW5nKTsKIGVycl9kZWxfYmlu
X2F0dHI6CiAJZGV2aWNlX3JlbW92ZV9iaW5fZmlsZShmX2RldiwgJmZpcm13YXJlX2F0dHJfZGF0
YSk7Cg==
--001a11c22b320cb8f304df203642--
