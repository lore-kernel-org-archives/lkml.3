Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220Ab3CZTcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:32:19 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61094 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325Ab3CZTcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:32:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130326152059.GA1698@jshin-Toonie>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
	<CAKohponTZ29BX6CrUvFMy9RXV==0wRFu4C-W1xd6t1RmLASTvQ@mail.gmail.com>
	<2565053.YP0dCLmaW9@vostro.rjw.lan>
	<20130326152059.GA1698@jshin-Toonie>
Date: Wed, 27 Mar 2013 01:02:15 +0530
Message-ID: <CAKohpons4Tr8F2RuRGCxbOFmJaK9YbAafV-3v6=cijRupe2hUA@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: multipart/mixed; boundary=e89a8fb2017e95638204d8d8fa75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8fb2017e95638204d8d8fa75
Content-Type: text/plain; charset=ISO-8859-1

On 26 March 2013 20:50, Jacob Shin <jacob.shin@amd.com> wrote:
> Hi, latest bleeding-edge is spewing this out on boot:
>
> [    3.585157] ------------[ cut here ]------------
> [    3.592227] WARNING: at fs/sysfs/dir.c:536 sysfs_add_one+0xc8/0x100()
> [    3.599521] Hardware name: Dinar
> [    3.606878] sysfs: cannot create duplicate filename '/devices/system/cpu/cpufreq/ondemand'
> [    3.614634] Modules linked in:
> [    3.622382] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc4+ #7
> [    3.630305] Call Trace:
> [    3.638251]  [<ffffffff810589cf>] warn_slowpath_common+0x7f/0xc0
> [    3.646435]  [<ffffffff81058ac6>] warn_slowpath_fmt+0x46/0x50
> [    3.654586]  [<ffffffff8133e2f0>] ? strlcat+0x60/0x80
> [    3.662765]  [<ffffffff811fe7d8>] sysfs_add_one+0xc8/0x100
> [    3.670977]  [<ffffffff811fe9cc>] create_dir+0x7c/0xd0
> [    3.679239]  [<ffffffff811fecaf>] sysfs_create_subdir+0x1f/0x30
> [    3.687601]  [<ffffffff812006c4>] internal_create_group+0x64/0x210
> [    3.696098]  [<ffffffff812008a3>] sysfs_create_group+0x13/0x20
> [    3.704700]  [<ffffffff816bf800>] cpufreq_governor_dbs+0x400/0x590
> [    3.713401]  [<ffffffff816bdc37>] od_cpufreq_governor_dbs+0x17/0x20
> [    3.722191]  [<ffffffff816bb437>] __cpufreq_governor+0x47/0xc0
> [    3.731071]  [<ffffffff816bb94d>] __cpufreq_set_policy+0x19d/0x1b0
> [    3.739968]  [<ffffffff816bca89>] cpufreq_add_dev_interface+0x259/0x2b0
> [    3.748960]  [<ffffffff813cdce6>] ? acpi_processor_get_performance_info+0x21c/0x452
> [    3.758099]  [<ffffffff816bc210>] ? cpufreq_update_policy+0x130/0x130
> [    3.767366]  [<ffffffff816bce90>] cpufreq_add_dev+0x3b0/0x4d0
> [    3.776659]  [<ffffffff821579d4>] ? cpufreq_gov_dbs_init+0x12/0x12
> [    3.785985]  [<ffffffff814e6a39>] subsys_interface_register+0x89/0xd0
> [    3.795452]  [<ffffffff816baf5e>] cpufreq_register_driver+0x8e/0x180
> [    3.804919]  [<ffffffff82157aca>] acpi_cpufreq_init+0xf6/0x1f8
> [    3.814360]  [<ffffffff814f5030>] ? set_trace_device+0x80/0x80
> [    3.823558]  [<ffffffff8100206f>] do_one_initcall+0x3f/0x170
> [    3.832476]  [<ffffffff8211b00a>] kernel_init_freeable+0x13e/0x1cd
> [    3.841131]  [<ffffffff8211a88e>] ? do_early_param+0x86/0x86
> [    3.849506]  [<ffffffff817f4c20>] ? rest_init+0x80/0x80
> [    3.857557]  [<ffffffff817f4c2e>] kernel_init+0xe/0xf0
> [    3.865260]  [<ffffffff8181edec>] ret_from_fork+0x7c/0xb0
> [    3.872886]  [<ffffffff817f4c20>] ? rest_init+0x80/0x80
> [    3.880456] ---[ end trace 1a5c6247c6d9b0ac ]---
> [    3.888201] ------------[ cut here ]------------
>
> This warning is repeated for number of cpus - 1 times.
>
> And when I do:
>
> $ cat /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
>
> [  489.103388] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
> [  489.112064] IP: [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> [  489.120511] PGD a285e6067 PUD a27085067 PMD 0
> [  489.128690] Oops: 0000 [#1] SMP
> [  489.136521] Modules linked in:
> [  489.144134] CPU 15
> [  489.144229] Pid: 1565, comm: cat Tainted: G        W    3.9.0-rc4+ #7 AMD Dinar/Dinar
> [  489.159654] RIP: 0010:[<ffffffff816be02c>]  [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> [  489.167864] RSP: 0018:ffff880423859e88  EFLAGS: 00010246
> [  489.176043] RAX: 0000000000000000 RBX: ffff880a271188c0 RCX: ffffffff81a41810
> [  489.184372] RDX: 0000000000000000 RSI: ffffffff81e02dae RDI: ffffffff820d7860
> [  489.184373] RBP: ffff880423859e88 R08: ffffea0028b6df80 R09: 00000000001f05b8
> [  489.184374] R10: 0000000000001b97 R11: 0000000000000246 R12: ffff880423859f50
> [  489.184374] R13: 0000000000008000 R14: ffff880a271188a0 R15: ffff8804251aa070
> [  489.184377] FS:  00007f3278b31700(0000) GS:ffff880a2fcc0000(0000) knlGS:0000000000000000
> [  489.184378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  489.184378] CR2: 0000000000000010 CR3: 0000000a2db82000 CR4: 00000000000407e0
> [  489.184380] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  489.184381] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  489.184382] Process cat (pid: 1565, threadinfo ffff880423858000, task ffff880424805c00)
> [  489.184382] Stack:
> [  489.184389]  ffff880423859e98 ffffffff8133814f ffff880423859ef8 ffffffff811fd62a
> [  489.184394]  000000002bf67be2 ffff8808260b7a80 ffffffff81a41810 00000000012c8000
> [  489.184399]  ffff880423859ef8 0000000000008000 00000000012c8000 ffff880423859f50
> [  489.184400] Call Trace:
> [  489.184406]  [<ffffffff8133814f>] kobj_attr_show+0xf/0x30
> [  489.184411]  [<ffffffff811fd62a>] sysfs_read_file+0xaa/0x190
> [  489.184415]  [<ffffffff81187e30>] vfs_read+0xb0/0x180
> [  489.184418]  [<ffffffff81187f52>] sys_read+0x52/0xa0
> [  489.184422]  [<ffffffff8181a7fe>] ? do_page_fault+0xe/0x10
> [  489.184426]  [<ffffffff8181ee99>] system_call_fastpath+0x16/0x1b
> [  489.184441] Code: 52 08 e8 78 2c c8 ff 5d 48 98 c3 0f 1f 40 00 66 66 66 66 90 55 48 8b 57 70 48 89 f0 48 89 c7 48 c7 c6 ae 2d e0 81 31 c0 48 89 e5 <48> 8b 52 10 8b 52 0c e8 48 2c c8 ff 5d 48 98 c3 0f 1f 40 00 66
> [  489.184443] RIP  [<ffffffff816be02c>] show_up_threshold+0x1c/0x30
> [  489.184443]  RSP <ffff880423859e88>
> [  489.184444] CR2: 0000000000000010
> [  489.184507] ---[ end trace 1a5c6247c6d9b0c3 ]---
>
> Any ideas?

Yes, i believe i have enough idea about it :)

There are two kind of systems i know:
1 - Single group of cpus controlled by a single clock line,
     i.e. only one policy instance at any time
2 - multipolicy systems where we have more than one group of cpus
     and every group have one clock line.

For the second case also there are two cases:
2.1 - support have_multiple_policies (i.e. have separate instance of governor
        for each policy struct)
2.2 - doesn't support have_multiple_policies

The last one (2.2) is broken with my patch and attached is the fix. I
have tested
it on my Lenovo Thinkpad which is more like 2.2 case.

cat of cpufreq/ondemand/** is still broken and i am too tired of
fixing it now...
Its already midnight here 01:01 AM.

--
viresh

--e89a8fb2017e95638204d8d8fa75
Content-Type: application/octet-stream; 
	name="0001-fixup-cpufreq-governor-Implement-per-policy-instance.patch"
Content-Disposition: attachment; 
	filename="0001-fixup-cpufreq-governor-Implement-per-policy-instance.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_heregcb80

RnJvbSBjOTVjYTU0NDMyNWY0MGY1NTg1OGUwMjUyNmQwYmQ2YTE3NDA0ODBkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Yzk1Y2E1NDQzMjVmNDBmNTU4NThlMDI1MjZkMGJk
NmExNzQwNDgwZC4xMzY0MzIyNTg3LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAyNiBNYXIg
MjAxMyAyMzoyMDoxOCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGZpeHVwISBjcHVmcmVxOiBnb3Zl
cm5vcjogSW1wbGVtZW50IHBlciBwb2xpY3kgaW5zdGFuY2VzIG9mCiBnb3Zlcm5vcnMKCi0tLQog
ZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyAgICAgICAgICB8IDEzICsrKysrKysKIGRyaXZlcnMv
Y3B1ZnJlcS9jcHVmcmVxX2dvdmVybm9yLmMgfCA3NCArKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLQogaW5jbHVkZS9saW51eC9jcHVmcmVxLmggICAgICAgICAgICB8ICAyICsr
CiAzIGZpbGVzIGNoYW5nZWQsIDY4IGluc2VydGlvbnMoKyksIDIxIGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1
ZnJlcS5jCmluZGV4IDhmMmE2MDMuLjNjNzkwMjUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJl
cS9jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTM2LDYgKzEz
NiwxMSBAQCBzdHJ1Y3Qga29iamVjdCAqZ2V0X2dvdmVybm9yX3BhcmVudF9rb2JqKHN0cnVjdCBj
cHVmcmVxX3BvbGljeSAqcG9saWN5KQogCQlyZXR1cm4gY3B1ZnJlcV9nbG9iYWxfa29iamVjdDsK
IH0KIAorYm9vbCBoYXZlX211bHRpcGxlX3BvbGljaWVzKHZvaWQpCit7CisJcmV0dXJuIGNwdWZy
ZXFfZHJpdmVyLT5oYXZlX211bHRpcGxlX3BvbGljaWVzOworfQorCiBzdGF0aWMgc3RydWN0IGNw
dWZyZXFfcG9saWN5ICpfX2NwdWZyZXFfY3B1X2dldCh1bnNpZ25lZCBpbnQgY3B1LCBib29sIHN5
c2ZzKQogewogCXN0cnVjdCBjcHVmcmVxX3BvbGljeSAqZGF0YTsKQEAgLTE1NjEsNiArMTU2Niwx
MyBAQCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9nb3Zlcm5vcihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kg
KnBvbGljeSwKIAkJCQkJCXBvbGljeS0+Y3B1LCBldmVudCk7CiAJcmV0ID0gcG9saWN5LT5nb3Zl
cm5vci0+Z292ZXJub3IocG9saWN5LCBldmVudCk7CiAKKwlpZiAoIXJldCkgeworCQlpZiAoZXZl
bnQgPT0gQ1BVRlJFUV9HT1ZfUE9MSUNZX0lOSVQpCisJCQlwb2xpY3ktPmdvdmVybm9yLT5pbml0
aWFsaXplZCsrOworCQllbHNlIGlmIChldmVudCA9PSBDUFVGUkVRX0dPVl9QT0xJQ1lfRVhJVCkK
KwkJCXBvbGljeS0+Z292ZXJub3ItPmluaXRpYWxpemVkLS07CisJfQorCiAJLyogd2Uga2VlcCBv
bmUgbW9kdWxlIHJlZmVyZW5jZSBhbGl2ZSBmb3IKIAkJCWVhY2ggQ1BVIGdvdmVybmVkIGJ5IHRo
aXMgQ1BVICovCiAJaWYgKChldmVudCAhPSBDUFVGUkVRX0dPVl9TVEFSVCkgfHwgcmV0KQpAQCAt
MTU4NCw2ICsxNTk2LDcgQEAgaW50IGNwdWZyZXFfcmVnaXN0ZXJfZ292ZXJub3Ioc3RydWN0IGNw
dWZyZXFfZ292ZXJub3IgKmdvdmVybm9yKQogCiAJbXV0ZXhfbG9jaygmY3B1ZnJlcV9nb3Zlcm5v
cl9tdXRleCk7CiAKKwlnb3Zlcm5vci0+aW5pdGlhbGl6ZWQgPSAwOwogCWVyciA9IC1FQlVTWTsK
IAlpZiAoX19maW5kX2dvdmVybm9yKGdvdmVybm9yLT5uYW1lKSA9PSBOVUxMKSB7CiAJCWVyciA9
IDA7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jIGIvZHJp
dmVycy9jcHVmcmVxL2NwdWZyZXFfZ292ZXJub3IuYwppbmRleCA0MWU1ZTU2Li5mMjlmZWI0IDEw
MDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jCisrKyBiL2RyaXZl
cnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVybm9yLmMKQEAgLTI5LDYgKzI5LDkgQEAKIAogI2luY2x1
ZGUgImNwdWZyZXFfZ292ZXJub3IuaCIKIAorLyogQ29tbW9uIGRhdGEgZm9yIHBsYXRmb3JtcyB0
aGF0IGRvbid0IG5lZWQgZ292ZXJub3IgaW5zdGFuY2UgcGVyIHBvbGljeSAqLworc3RydWN0IGRi
c19kYXRhICpnZGJzX2RhdGE7CisKIHN0YXRpYyBpbmxpbmUgdTY0IGdldF9jcHVfaWRsZV90aW1l
X2ppZmZ5KHVuc2lnbmVkIGludCBjcHUsIHU2NCAqd2FsbCkKIHsKIAl1NjQgaWRsZV90aW1lOwpA
QCAtMjE2LDEwICsyMTksOSBAQCBzdGF0aWMgdm9pZCBzZXRfc2FtcGxpbmdfcmF0ZShzdHJ1Y3Qg
ZGJzX2RhdGEgKmRic19kYXRhLAogaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVm
cmVxX3BvbGljeSAqcG9saWN5LAogCQlzdHJ1Y3QgY29tbW9uX2Ric19kYXRhICpjZGF0YSwgdW5z
aWduZWQgaW50IGV2ZW50KQogewotCXN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBwb2xpY3kt
PmdvdmVybm9yX2RhdGE7CisJc3RydWN0IGRic19kYXRhICpkYnNfZGF0YTsKIAlzdHJ1Y3Qgb2Rf
Y3B1X2Ric19pbmZvX3MgKm9kX2Ric19pbmZvID0gTlVMTDsKIAlzdHJ1Y3QgY3NfY3B1X2Ric19p
bmZvX3MgKmNzX2Ric19pbmZvID0gTlVMTDsKLQlzdHJ1Y3QgY3Nfb3BzICpjc19vcHMgPSBOVUxM
OwogCXN0cnVjdCBvZF9vcHMgKm9kX29wcyA9IE5VTEw7CiAJc3RydWN0IG9kX2Ric190dW5lcnMg
Km9kX3R1bmVycyA9IE5VTEw7CiAJc3RydWN0IGNzX2Ric190dW5lcnMgKmNzX3R1bmVycyA9IE5V
TEw7CkBAIC0yMjgsMTEgKzIzMCwyMiBAQCBpbnQgY3B1ZnJlcV9nb3Zlcm5vcl9kYnMoc3RydWN0
IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJaW50IGlvX2J1c3kgPSAwOwogCWludCByYzsKIAor
CWlmIChoYXZlX211bHRpcGxlX3BvbGljaWVzKCkpCisJCWRic19kYXRhID0gcG9saWN5LT5nb3Zl
cm5vcl9kYXRhOworCWVsc2UKKwkJZGJzX2RhdGEgPSBnZGJzX2RhdGE7CisKIAlXQVJOX09OKCFk
YnNfZGF0YSAmJiAoZXZlbnQgIT0gQ1BVRlJFUV9HT1ZfUE9MSUNZX0lOSVQpKTsKIAogCXN3aXRj
aCAoZXZlbnQpIHsKIAljYXNlIENQVUZSRVFfR09WX1BPTElDWV9JTklUOgotCQlXQVJOX09OKGRi
c19kYXRhKTsKKwkJaWYgKGhhdmVfbXVsdGlwbGVfcG9saWNpZXMoKSkgeworCQkJV0FSTl9PTihk
YnNfZGF0YSk7CisJCX0gZWxzZSBpZiAoZGJzX2RhdGEpIHsKKwkJCXBvbGljeS0+Z292ZXJub3Jf
ZGF0YSA9IGRic19kYXRhOworCQkJcmV0dXJuIDA7CisJCX0KKwogCQlkYnNfZGF0YSA9IGt6YWxs
b2Moc2l6ZW9mKCpkYnNfZGF0YSksIEdGUF9LRVJORUwpOwogCQlpZiAoIWRic19kYXRhKSB7CiAJ
CQlwcl9lcnIoIiVzOiBQT0xJQ1lfSU5JVDoga3phbGxvYyBmYWlsZWRcbiIsIF9fZnVuY19fKTsK
QEAgLTI0Niw2ICsyNTksMTUgQEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVm
cmVxX3BvbGljeSAqcG9saWN5LAogCQkJa2ZyZWUoZGJzX2RhdGEpOwogCQkJcmV0dXJuIHJjOwog
CQl9CisKKwkJcmMgPSBzeXNmc19jcmVhdGVfZ3JvdXAoZ2V0X2dvdmVybm9yX3BhcmVudF9rb2Jq
KHBvbGljeSksCisJCQkJZGJzX2RhdGEtPmNkYXRhLT5hdHRyX2dyb3VwKTsKKwkJaWYgKHJjKSB7
CisJCQljZGF0YS0+ZXhpdChkYnNfZGF0YSk7CisJCQlrZnJlZShkYnNfZGF0YSk7CisJCQlyZXR1
cm4gcmM7CisJCX0KKwogCQlwb2xpY3ktPmdvdmVybm9yX2RhdGEgPSBkYnNfZGF0YTsKIAogCQkv
KiBwb2xpY3kgbGF0ZW5jeSBpcyBpbiBuUy4gQ29udmVydCBpdCB0byB1UyBmaXJzdCAqLwpAQCAt
MjU4LDEwICsyODAsMzYgQEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVx
X3BvbGljeSAqcG9saWN5LAogCQkJCU1JTl9MQVRFTkNZX01VTFRJUExJRVIgKiBsYXRlbmN5KTsK
IAkJc2V0X3NhbXBsaW5nX3JhdGUoZGJzX2RhdGEsIG1heChkYnNfZGF0YS0+bWluX3NhbXBsaW5n
X3JhdGUsCiAJCQkJCWxhdGVuY3kgKiBMQVRFTkNZX01VTFRJUExJRVIpKTsKKworCQlpZiAoZGJz
X2RhdGEtPmNkYXRhLT5nb3Zlcm5vciA9PSBHT1ZfQ09OU0VSVkFUSVZFKSB7CisJCQlzdHJ1Y3Qg
Y3Nfb3BzICpjc19vcHMgPSBkYnNfZGF0YS0+Y2RhdGEtPmdvdl9vcHM7CisKKwkJCWNwdWZyZXFf
cmVnaXN0ZXJfbm90aWZpZXIoY3Nfb3BzLT5ub3RpZmllcl9ibG9jaywKKwkJCQkJQ1BVRlJFUV9U
UkFOU0lUSU9OX05PVElGSUVSKTsKKwkJfQorCisJCWlmICghaGF2ZV9tdWx0aXBsZV9wb2xpY2ll
cygpKQorCQkJZ2Ric19kYXRhID0gZGJzX2RhdGE7CisKIAkJcmV0dXJuIDA7CiAJY2FzZSBDUFVG
UkVRX0dPVl9QT0xJQ1lfRVhJVDoKLQkJY2RhdGEtPmV4aXQoZGJzX2RhdGEpOwotCQlrZnJlZShk
YnNfZGF0YSk7CisJCWlmICgocG9saWN5LT5nb3Zlcm5vci0+aW5pdGlhbGl6ZWQgPT0gMSkgfHwK
KwkJCQloYXZlX211bHRpcGxlX3BvbGljaWVzKCkpIHsKKwkJCXN5c2ZzX3JlbW92ZV9ncm91cChn
ZXRfZ292ZXJub3JfcGFyZW50X2tvYmoocG9saWN5KSwKKwkJCQkJZGJzX2RhdGEtPmNkYXRhLT5h
dHRyX2dyb3VwKTsKKworCQkJaWYgKGRic19kYXRhLT5jZGF0YS0+Z292ZXJub3IgPT0gR09WX0NP
TlNFUlZBVElWRSkgeworCQkJCXN0cnVjdCBjc19vcHMgKmNzX29wcyA9IGRic19kYXRhLT5jZGF0
YS0+Z292X29wczsKKworCQkJCWNwdWZyZXFfcmVnaXN0ZXJfbm90aWZpZXIoY3Nfb3BzLT5ub3Rp
Zmllcl9ibG9jaywKKwkJCQkJCUNQVUZSRVFfVFJBTlNJVElPTl9OT1RJRklFUik7CisJCQl9CisK
KwkJCWNkYXRhLT5leGl0KGRic19kYXRhKTsKKwkJCWtmcmVlKGRic19kYXRhKTsKKwkJCWdkYnNf
ZGF0YSA9IE5VTEw7CisJCX0KKwogCQlwb2xpY3ktPmdvdmVybm9yX2RhdGEgPSBOVUxMOwogCQly
ZXR1cm4gMDsKIAl9CkBAIC0yNzMsNyArMzIxLDYgQEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJz
KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQljc19kYnNfaW5mbyA9IGRic19kYXRh
LT5jZGF0YS0+Z2V0X2NwdV9kYnNfaW5mb19zKGNwdSk7CiAJCXNhbXBsaW5nX3JhdGUgPSBjc190
dW5lcnMtPnNhbXBsaW5nX3JhdGU7CiAJCWlnbm9yZV9uaWNlID0gY3NfdHVuZXJzLT5pZ25vcmVf
bmljZTsKLQkJY3Nfb3BzID0gZGJzX2RhdGEtPmNkYXRhLT5nb3Zfb3BzOwogCX0gZWxzZSB7CiAJ
CW9kX3R1bmVycyA9IGRic19kYXRhLT50dW5lcnM7CiAJCW9kX2Ric19pbmZvID0gZGJzX2RhdGEt
PmNkYXRhLT5nZXRfY3B1X2Ric19pbmZvX3MoY3B1KTsKQEAgLTMwNywxMyArMzU0LDYgQEAgaW50
IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQkJ
CQkgICAgIGRic19kYXRhLT5jZGF0YS0+Z292X2Ric190aW1lcik7CiAJCX0KIAotCQlyYyA9IHN5
c2ZzX2NyZWF0ZV9ncm91cChnZXRfZ292ZXJub3JfcGFyZW50X2tvYmoocG9saWN5KSwKLQkJCQlk
YnNfZGF0YS0+Y2RhdGEtPmF0dHJfZ3JvdXApOwotCQlpZiAocmMpIHsKLQkJCW11dGV4X3VubG9j
aygmZGJzX2RhdGEtPm11dGV4KTsKLQkJCXJldHVybiByYzsKLQkJfQotCiAJCS8qCiAJCSAqIGNv
bnNlcnZhdGl2ZSBkb2VzIG5vdCBpbXBsZW1lbnQgbWljcm8gbGlrZSBvbmRlbWFuZAogCQkgKiBn
b3Zlcm5vciwgdGh1cyB3ZSBhcmUgYm91bmQgdG8gamlmZmVzL0haCkBAIC0zMjIsOSArMzYyLDYg
QEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5
LAogCQkJY3NfZGJzX2luZm8tPmRvd25fc2tpcCA9IDA7CiAJCQljc19kYnNfaW5mby0+ZW5hYmxl
ID0gMTsKIAkJCWNzX2Ric19pbmZvLT5yZXF1ZXN0ZWRfZnJlcSA9IHBvbGljeS0+Y3VyOwotCi0J
CQljcHVmcmVxX3JlZ2lzdGVyX25vdGlmaWVyKGNzX29wcy0+bm90aWZpZXJfYmxvY2ssCi0JCQkJ
CUNQVUZSRVFfVFJBTlNJVElPTl9OT1RJRklFUik7CiAJCX0gZWxzZSB7CiAJCQlvZF9kYnNfaW5m
by0+cmF0ZV9tdWx0ID0gMTsKIAkJCW9kX2Ric19pbmZvLT5zYW1wbGVfdHlwZSA9IE9EX05PUk1B
TF9TQU1QTEU7CkBAIC0zNDksMTEgKzM4Niw2IEBAIGludCBjcHVmcmVxX2dvdmVybm9yX2Ricyhz
dHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJbXV0ZXhfbG9jaygmZGJzX2RhdGEtPm11
dGV4KTsKIAkJbXV0ZXhfZGVzdHJveSgmY3B1X2NkYnMtPnRpbWVyX211dGV4KTsKIAotCQlzeXNm
c19yZW1vdmVfZ3JvdXAoZ2V0X2dvdmVybm9yX3BhcmVudF9rb2JqKHBvbGljeSksCi0JCQkJZGJz
X2RhdGEtPmNkYXRhLT5hdHRyX2dyb3VwKTsKLQkJaWYgKGRic19kYXRhLT5jZGF0YS0+Z292ZXJu
b3IgPT0gR09WX0NPTlNFUlZBVElWRSkKLQkJCWNwdWZyZXFfdW5yZWdpc3Rlcl9ub3RpZmllcihj
c19vcHMtPm5vdGlmaWVyX2Jsb2NrLAotCQkJCQlDUFVGUkVRX1RSQU5TSVRJT05fTk9USUZJRVIp
OwogCQltdXRleF91bmxvY2soJmRic19kYXRhLT5tdXRleCk7CiAKIAkJYnJlYWs7CmRpZmYgLS1n
aXQgYS9pbmNsdWRlL2xpbnV4L2NwdWZyZXEuaCBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCmlu
ZGV4IDhmZTliMTAuLmYyNTNhM2UgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5o
CisrKyBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCkBAIC0xODcsNiArMTg3LDcgQEAgc3RhdGlj
IGlubGluZSB1bnNpZ25lZCBsb25nIGNwdWZyZXFfc2NhbGUodW5zaWduZWQgbG9uZyBvbGQsIHVf
aW50IGRpdiwgdV9pbnQgbXUKIAogc3RydWN0IGNwdWZyZXFfZ292ZXJub3IgewogCWNoYXIJbmFt
ZVtDUFVGUkVRX05BTUVfTEVOXTsKKwlpbnQJaW5pdGlhbGl6ZWQ7CiAJaW50CSgqZ292ZXJub3Ip
CShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJCQkgdW5zaWduZWQgaW50IGV2ZW50
KTsKIAlzc2l6ZV90CSgqc2hvd19zZXRzcGVlZCkJKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9s
aWN5LApAQCAtMzIzLDYgKzMyNCw3IEBAIGNvbnN0IGNoYXIgKmNwdWZyZXFfZ2V0X2N1cnJlbnRf
ZHJpdmVyKHZvaWQpOwogaW50IGNwdWZyZXFfZ2V0X3BvbGljeShzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSwgdW5zaWduZWQgaW50IGNwdSk7CiBpbnQgY3B1ZnJlcV91cGRhdGVfcG9saWN5
KHVuc2lnbmVkIGludCBjcHUpOwogc3RydWN0IGtvYmplY3QgKmdldF9nb3Zlcm5vcl9wYXJlbnRf
a29iaihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSk7Citib29sIGhhdmVfbXVsdGlwbGVf
cG9saWNpZXModm9pZCk7CiAKICNpZmRlZiBDT05GSUdfQ1BVX0ZSRVEKIC8qIHF1ZXJ5IHRoZSBj
dXJyZW50IENQVSBmcmVxdWVuY3kgKGluIGtIeikuIElmIHplcm8sIGNwdWZyZXEgY291bGRuJ3Qg
ZGV0ZWN0IGl0ICovCi0tIAoxLjcuMTIucmMyLjE4Lmc2MWI0NzJlCgo=
--e89a8fb2017e95638204d8d8fa75--
