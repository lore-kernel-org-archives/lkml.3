Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936188Ab3DIU0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:26:43 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:42558 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935949Ab3DIU0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:26:40 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUX2sqj+3hoxRvDDMMCz2Sne+QTeu3nc+zDw9P=EKwr1Tg@mail.gmail.com>
References: <CA+icZUU_K9PiFMqMsOEk1+c2DX8LrUojZptPiRVarv4dcB2qFA@mail.gmail.com>
	<31778276.CDMUtaAAnc@vostro.rjw.lan>
	<CA+icZUXXHb9vmcNuFmYha34SV7xch2S8OcgZ+cLVVnNebs5pNQ@mail.gmail.com>
	<CAKohpok+9dRaENjBfnN9gZF3zvFU9v19xV_eFfcM3Pj6Cv=S2w@mail.gmail.com>
	<CA+icZUWH5Ni9koj4V8Ws8jJ7smwmU7JuUWBFh=aiCqkrCpqB5A@mail.gmail.com>
	<CAKohponzmLzPN8ua3p4TCt2waZCQCd+4Znh+tSQ4MBjcy+Ss6A@mail.gmail.com>
	<CA+icZUW8OVk_FiGUtpog4czAuqrgT_q6FWrYG3+wLV5hCvT-Qw@mail.gmail.com>
	<CA+icZUVDp9N1A1OQf_e=+NsoikMUodNa_FjYKOEzJvUCVB+cRA@mail.gmail.com>
	<CA+icZUX2sqj+3hoxRvDDMMCz2Sne+QTeu3nc+zDw9P=EKwr1Tg@mail.gmail.com>
Date: Tue, 9 Apr 2013 22:26:38 +0200
Message-ID: <CA+icZUUR614jBrO2pWQBxFpY_DS=oZpJqQ6gW4oKXDaDrWj0+A@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 9 [cpufreq: NULL pointer deref]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 8:39 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Apr 9, 2013 at 8:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Tue, Apr 9, 2013 at 8:26 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Tue, Apr 9, 2013 at 6:51 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>>> On 9 April 2013 21:38, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> With x=3 the system gets in an unuseable state.
>>>>>
>>>>>      root# echo 0 > /sys/devices/system/cpu/cpu3/online
>>>>>
>>>>> I could not write my reply and had to do a hard/cold reboot.
>>>>> The dmesg log I saw looked similiar to my digicam-shot.
>>>>
>>>> Few things i need from you. First is output of cpufreq-info. Then
>>>> all the steps you did to reproduce above? Removed any other cpus?
>>>>
>>>> I am not able to find next-20130326 tag in my repo, only have 23 and 28.
>>>> Can you debug it a bit to find exact line of code causing this issue using
>>>> objdump?
>>>>
>>>> HINT: Documentation/BUG-HUNTING..
>>>>
>>>> Give me line numbers of both of these functions: __cpufreq_governor() and
>>>> __cpufreq_remove_dev().
>>>
>>> I have recompiled next-20130326 and the REGRESSION is still reproducible.
>>>
>>> Attached are my dmesg, kernel-config, tarball of my drivers/cpufreq
>>> build-dir, objdump of cpufreq_governor.o and the list of my current
>>> amd64-toolchain.
>>>
>>> Hope this helps you!
>>>
>>> Regards,
>>> - Sedat -
>>
>> $ cd linux-next/
>>
>> $ objdump --disassemble-all drivers/cpufreq/cpufreq.o >
>> /tmp/cpufreq_o--disassemble-all.txt
>>
>> ...attached.
>>
>> - Sedat -
>
> Hmm, I remembered Thorsten Glaser told be to pass also "-Mintel"
> parameter ("-D" shortform for "--disassemble-all"):
>
> $ objdump -D -Mintel drivers/cpufreq/cpufreq.o > /tmp/cpufreq_o-D-Mintel.txt
>
> File attached.
>
> Hope this helps you.
>
> - Sedat -

The issue was also seen with a vfs-next-fixed Linux-Next (next-20130409).

- Sedat -

[ 2454.415601] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000030
[ 2454.421017] IP: [<ffffffff8156fefa>] __cpufreq_governor+0x1a/0x100
[ 2454.423777] PGD c6219067 PUD c620d067 PMD 0
[ 2454.426360] Oops: 0000 [#1] SMP
[ 2454.428850] Modules linked in: btrfs xor zlib_deflate raid6_pq xfs
libcrc32c snd_hda_codec_hdmi snd_hda_codec_realtek coretemp kvm_intel
kvm snd_hda_intel snd_hda_codec arc4 iwldvm snd_hwdep joydev i915
snd_pcm ghash_clmulni_intel mac80211 aesni_intel parport_pc
snd_page_alloc xts rfcomm snd_seq_midi aes_x86_64 bnep ppdev
snd_seq_midi_event lrw snd_rawmidi gf128mul snd_seq i2c_algo_bit
ablk_helper uvcvideo iwlwifi cryptd drm_kms_helper snd_timer drm
videobuf2_vmalloc snd_seq_device psmouse btusb videobuf2_memops snd
videobuf2_core microcode bluetooth cfg80211 soundcore videodev
samsung_laptop serio_raw wmi lp mac_hid video lpc_ich parport
hid_generic r8169 usbhid hid
[ 2454.440355] CPU 3
[ 2454.440386] Pid: 5409, comm: bash Not tainted
3.9.0-rc6-next20130409-4-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
[ 2454.446497] RIP: 0010:[<ffffffff8156fefa>]  [<ffffffff8156fefa>]
__cpufreq_governor+0x1a/0x100
[ 2454.449734] RSP: 0018:ffff8800c624bca8  EFLAGS: 00010282
[ 2454.452977] RAX: ffffffff81cc16c0 RBX: ffff880118038200 RCX: 00000001820001fa
[ 2454.456260] RDX: 00000001820001fb RSI: 0000000000000000 RDI: ffff880118038200
[ 2454.459567] RBP: ffff8800c624bcc8 R08: 0000000000000000 R09: ffffea000461fc80
[ 2454.462797] R10: ffffffff81346139 R11: 0000000000000246 R12: 0000000000000005
[ 2454.465940] R13: ffff88011facc348 R14: 0000000000010b40 R15: 0000000000000003
[ 2454.468999] FS:  00007f4e705f7700(0000) GS:ffff88011fac0000(0000)
knlGS:0000000000000000
[ 2454.472097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2454.475132] CR2: 0000000000000030 CR3: 00000000c621e000 CR4: 00000000000407e0
[ 2454.478206] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2454.481288] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2454.484362] Process bash (pid: 5409, threadinfo ffff8800c624a000,
task ffff88005f969740)
[ 2454.487463] Stack:
[ 2454.490545]  0000000000010b40 0000000000000003 ffff880118038200
0000000000000003
[ 2454.493713]  ffff8800c624bd38 ffffffff81570bdd ffffffff81cda920
ffff8800c624be04
[ 2454.496899]  ffffffff816abb28 ffffffff00000001 0000000000000003
0000000000010b48
[ 2454.500101] Call Trace:
[ 2454.503265]  [<ffffffff81570bdd>] __cpufreq_remove_dev.isra.12+0x25d/0x390
[ 2454.506402]  [<ffffffff816abb28>] ? powernowk8_cpu_init_on_cpu+0xa9/0xa9
[ 2454.509527]  [<ffffffff816ab04a>] cpufreq_cpu_callback+0x47/0x5c
[ 2454.512636]  [<ffffffff816c180d>] notifier_call_chain+0x4d/0x70
[ 2454.515716]  [<ffffffff810833ee>] __raw_notifier_call_chain+0xe/0x10
[ 2454.518781]  [<ffffffff8105b930>] __cpu_notify+0x20/0x40
[ 2454.521823]  [<ffffffff8169bd91>] _cpu_down+0x81/0x280
[ 2454.524858]  [<ffffffff8169bfc5>] cpu_down+0x35/0x50
[ 2454.527900]  [<ffffffff8169fff3>] store_online+0x63/0xc0
[ 2454.530958]  [<ffffffff8144d288>] dev_attr_store+0x18/0x30
[ 2454.534039]  [<ffffffff812077bf>] sysfs_write_file+0xef/0x170
[ 2454.537127]  [<ffffffff8119418e>] vfs_write+0xce/0x1e0
[ 2454.540223]  [<ffffffff81194672>] SyS_write+0x52/0xa0
[ 2454.543315]  [<ffffffff811b0df0>] ? __close_fd+0x90/0xc0
[ 2454.546406]  [<ffffffff816c5e5d>] system_call_fastpath+0x1a/0x1f
[ 2454.549495] Code: c3 49 c7 c6 ea ff ff ff eb e2 0f 1f 80 00 00 00
00 66 66 66 66 90 55 48 89 e5 41 54 41 89 f4 53 48 89 fb 48 83 ec 10
48 8b 77 68 <8b> 46 30 85 c0 74 09 3b 47 54 0f 82 a0 00 00 00 48 8b 7e
48 e8
[ 2454.556603] RIP  [<ffffffff8156fefa>] __cpufreq_governor+0x1a/0x100
[ 2454.560102]  RSP <ffff8800c624bca8>
[ 2454.563569] CR2: 0000000000000030
[ 2454.581144] ---[ end trace 62364c4fbb57b30b ]---
- EOT -
