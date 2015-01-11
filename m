Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbbAKJwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 04:52:33 -0500
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:7520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751005AbbAKJw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 04:52:28 -0500
X-WSS-ID: 0NI0BF9-08-JZL-02
X-M-MSG: 
Message-ID: <54B247D0.2090600@amd.com>
Date: Sun, 11 Jan 2015 11:52:16 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>,
        Chris Clayton <chris2553@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Elifaz, Dana" <Dana.Elifaz@amd.com>,
        "Bridgman, John" <John.Bridgman@amd.com>
Subject: Re: BUG in 3.19.0-rc3+
References: <54B188BF.3020304@googlemail.com>
	<54B2316F.9040608@googlemail.com>
 <CALYGNiO5zyGHWh0MxjLTYy8-JHrei7Cqoi1QrDwgo8_Xhb8Vxg@mail.gmail.com>
In-Reply-To: <CALYGNiO5zyGHWh0MxjLTYy8-JHrei7Cqoi1QrDwgo8_Xhb8Vxg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.11.83]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(51704005)(199003)(479174004)(24454002)(51914003)(377454003)(80316001)(19580405001)(19580395003)(62966003)(105586002)(83506001)(50466002)(87936001)(59896002)(77096005)(46102003)(92566002)(68736005)(106466001)(15975445007)(47776003)(97736003)(2950100001)(77156002)(64706001)(23676002)(86362001)(575784001)(33656002)(76176999)(54356999)(50986999)(65816999)(101416001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB0994;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0201MB0994;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0201MB0994;
X-Forefront-PRVS: 045315E1EE
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB0994;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 09:52:24.4785
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0201MB0994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2015 11:37 AM, Konstantin Khlebnikov wrote:
> On Sun, Jan 11, 2015 at 11:16 AM, Chris Clayton
> <chris2553@googlemail.com> wrote:
>> Hi,
>>
>> I've done the bisect and the outcome is below, but, because I almost always forget to mention it, I'll say here that I
>> am running a 32 bit user space on a 64 bit kernel.
>>
>> On 01/10/15 20:17, Chris Clayton wrote:
>>> Hi,
>>>
>>> I'm getting a bug a BUG report from a kernel built from a pull (earlier today) of the current development kernel
>>> (running git describe gives v3.19-rc3-169-geb74926). So that I have useable wireless networking, I have also applied the
>>> latest seven iwlwifi patches from the wireless-drivers git tree. Prior to today's pull, I was not seeing anything
>>> unusual in dmesg.
>>>
>>> The BUG reported is as follows:
>>>
>>> Jan 10 19:41:32 laptop kernel: ------------[ cut here ]------------
>>> Jan 10 19:41:32 laptop kernel: kernel BUG at mm/rmap.c:399!
>>> Jan 10 19:41:32 laptop kernel: invalid opcode: 0000 [#1] PREEMPT SMP
>>> Jan 10 19:41:32 laptop kernel: Modules linked in: rfcomm snd_hda_codec_via iwlmvm coretemp snd_hda_codec_hdmi
>>> snd_hda_codec_generic snd_hda_intel mac80211 hwmon snd_hda_controller x86_pkg_temp_thermal acpi_cpufreq iwlwifi cfg80211
>>> snd_hda_codec snd_hwdep
>>> Jan 10 19:41:32 laptop kernel: CPU: 1 PID: 353 Comm: fc-cache Not tainted 3.19.0-rc3+ #42
>>> Jan 10 19:41:32 laptop kernel: Hardware name: Notebook                         W65_67SZ                        /W65_67SZ
>>>                        , BIOS 1.03.05 02/26/2014
>>> Jan 10 19:41:32 laptop kernel: task: ffff8800da98c5c0 ti: ffff880408dd4000 task.ti: ffff880408dd4000
>>> Jan 10 19:41:32 laptop kernel: RIP: 0010:[<ffffffff810ef7ea>]  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
>>> Jan 10 19:41:33 laptop kernel: RSP: 0018:ffff880408dd7d88  EFLAGS: 00010286
>>> Jan 10 19:41:33 laptop kernel: RAX: ffff88040b79e150 RBX: ffff88040b79e140 RCX: 00000000ffffffff
>>> Jan 10 19:41:33 laptop kernel: RDX: ffffffff00000001 RSI: ffff880409f04360 RDI: ffff880409f04320
>>> Jan 10 19:41:33 laptop kernel: RBP: ffff88040cb13278 R08: 0000000000000000 R09: ffff88040d801c00
>>> Jan 10 19:41:33 laptop kernel: R10: ffff88041fa546e0 R11: ffff88040b79e160 R12: ffff880409f04320
>>> Jan 10 19:41:33 laptop kernel: R13: ffff88040cb13278 R14: ffff88040cb13288 R15: ffff88040cb13210
>>> Jan 10 19:41:33 laptop kernel: FS:  0000000000000000(0000) GS:ffff88041fa40000(0000) knlGS:0000000000000000
>>> Jan 10 19:41:33 laptop kernel: CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
>>> Jan 10 19:41:33 laptop kernel: CR2: 00000000f722c8d4 CR3: 00000004082a8000 CR4: 00000000001407e0
>>> Jan 10 19:41:33 laptop kernel: Stack:
>>> Jan 10 19:41:33 laptop kernel:  ffff88040d6cfbd8 ffff88040d6cfba0 ffff88040cecd160 ffff88040cb13210
>>> Jan 10 19:41:33 laptop kernel:  ffff88040cbbb630 00000000f7151000 ffff880408dd7e28 0000000000000000
>>> Jan 10 19:41:33 laptop kernel:  0000000000000000 ffffffff810e3633 0000000000000000 0000000000000000
>>> Jan 10 19:41:33 laptop kernel: Call Trace:
>>> Jan 10 19:41:33 laptop kernel:  [<ffffffff810e3633>] ? free_pgtables+0x83/0xf0
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff810ec3c3>] ? exit_mmap+0xc3/0x150
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff8103980d>] ? __do_page_fault+0x17d/0x4b0
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff81042a21>] ? mmput+0x21/0xc0
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff8104673d>] ? do_exit+0x26d/0xa50
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff8111fe89>] ? mntput_no_expire+0x9/0x140
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff8105ca1c>] ? task_work_run+0xbc/0xf0
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff81047d44>] ? do_group_exit+0x34/0xb0
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff81047dcf>] ? SyS_exit_group+0xf/0x10
>>> Jan 10 19:41:34 laptop kernel:  [<ffffffff815e0f9f>] ? sysenter_dispatch+0x7/0x1e
>>> Jan 10 19:41:34 laptop kernel: Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48 83 e8 10 49 39 d6 74
>>> 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
>>> Jan 10 19:41:34 laptop kernel: RIP  [<ffffffff810ef7ea>] unlink_anon_vmas+0x17a/0x200
>>> Jan 10 19:41:34 laptop kernel:  RSP <ffff880408dd7d88>
>>> Jan 10 19:41:34 laptop kernel: ---[ end trace 4aa713b2a9aa664b ]---
>>> Jan 10 19:41:34 laptop kernel: Fixing recursive fault but reboot is needed!
>>> Jan 10 19:41:34 laptop kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>>
>> [snip]
>>
>>>
>>> I won't get time tonight, but I can bisect it tomorrow, so this is just a heads up in case the problem (and fix) jumps
>>> out at anyone.  Before I bisect I'll build and run a kernel without the iwlwifi patches.
>>
>> The bisect ended up at:
>>
>> 7a3ef208e662f4b63d43a23f61a64a129c525bbc is the first bad commit
>> commit 7a3ef208e662f4b63d43a23f61a64a129c525bbc
>> Author: Konstantin Khlebnikov <koct9i@gmail.com>
>> Date:   Thu Jan 8 14:32:15 2015 -0800
>>
>>     mm: prevent endless growth of anon_vma hierarchy
>>
>>     Constantly forking task causes unlimited grow of anon_vma chain.  Each
>>     next child allocates new level of anon_vmas and links vma to all
>>     previous levels because pages might be inherited from any level.
>>
>>     This patch adds heuristic which decides to reuse existing anon_vma
>>     instead of forking new one.  It adds counter anon_vma->degree which
>>     counts linked vmas and directly descending anon_vmas and reuses anon_vma
>>     if counter is lower than two.  As a result each anon_vma has either vma
>>     or at least two descending anon_vmas.  In such trees half of nodes are
>>     leafs with alive vmas, thus count of anon_vmas is no more than two times
>>     bigger than count of vmas.
>>
>>     This heuristic reuses anon_vmas as few as possible because each reuse
>>     adds false aliasing among vmas and rmap walker ought to scan more ptes
>>     when it searches where page is might be mapped.
>>
>>     Link: http://lkml.kernel.org/r/20120816024610.GA5350@evergreen.ssec.wisc.edu
>>     Fixes: 5beb49305251 ("mm: change anon_vma linking to fix multi-process server scalability issue")
>>     [akpm@linux-foundation.org: fix typo, per Rik]
>>     Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
>>     Reported-by: Daniel Forrest <dan.forrest@ssec.wisc.edu>
>>     Tested-by: Michal Hocko <mhocko@suse.cz>
>>     Tested-by: Jerome Marchand <jmarchan@redhat.com>
>>     Reviewed-by: Michal Hocko <mhocko@suse.cz>
>>     Reviewed-by: Rik van Riel <riel@redhat.com>
>>     Cc: <stable@vger.kernel.org>        [2.6.34+]
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>>
>> :040000 040000 ca27f69d02743e7347b19b1e07976732a49698d1 7104c9ec5eb200ee4a21548e15d2b71a5806e107 M      include
>> :040000 040000 5440efbda5ac44c2a2da7e068f40ee6f0d4c0c7e b76fd93bffebec1acdef5f1785eb578c5f4f6cc3 M      mm
>>
>> I'm more than happy to provide additional diagnostics and/or test any patches, but please cc me as I'm not subscribed.
> 
> Looks like degree (%edx) is 1 on anon-vma desruction.
> Probably I've overlooked some weird conrner case in vma splitting/merging.
> 
> Could you try this patch. It disables vma merging end eliminates half
> of complicated paths.
> As I see merging is optional, everything should work fine without it.
> 
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1048,7 +1048,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>          * We later require that vma->vm_flags == vm_flags,
>          * so this tests vma->vm_flags & VM_SPECIAL, too.
>          */
> -       if (vm_flags & VM_SPECIAL)
> +       if (1)
>                 return NULL;
> 
>         if (prev)
> 
> 
> 
> 
> Code from your oops.
> 
> Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48
> 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f>
> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
> All code
> ========
>    0: 00 ad de 48 89 43     add    %ch,0x438948de(%rbp)
>    6: 18 e8                 sbb    %ch,%al
>    8: c5 f9 00             (bad)
>    b: 00 48 8b             add    %cl,-0x75(%rax)
>    e: 45 10 48 8d           adc    %r9b,-0x73(%r8)
>   12: 55                   push   %rbp
>   13: 10 48 83             adc    %cl,-0x7d(%rax)
>   16: e8 10 49 39 d6       callq  0xffffffffd639492b
>   1b: 74 54                 je     0x71
>   1d: 48 8b 7d 08           mov    0x8(%rbp),%rdi
>   21: 48 89 eb             mov    %rbp,%rbx
>   24: 8b 57 34             mov    0x34(%rdi),%edx
>   27: 85 d2                 test   %edx,%edx
>   29: 74 9e                 je     0xffffffffffffffc9
>   2b:* 0f 0b                 ud2     <-- trapping instruction
>   2d: 0f 1f 40 00           nopl   0x0(%rax)
>   31: e8 6b fc ff ff       callq  0xfffffffffffffca1
>   36: eb 9a                 jmp    0xffffffffffffffd2
>   38: 66                   data16
>   39: 0f                   .byte 0xf
>   3a: 1f                   (bad)
>   3b: 84 00                 test   %al,(%rax)
>   3d: 00 00                 add    %al,(%rax)
> ...
> 
> Code starting with the faulting instruction
> ===========================================
>    0: 0f 0b                 ud2
>    2: 0f 1f 40 00           nopl   0x0(%rax)
>    6: e8 6b fc ff ff       callq  0xfffffffffffffc76
>    b: eb 9a                 jmp    0xffffffffffffffa7
>    d: 66                   data16
>    e: 0f                   .byte 0xf
>    f: 1f                   (bad)
>   10: 84 00                 test   %al,(%rax)
>   12: 00 00                 add    %al,(%rax)
> 
> 
> +Added Oded Gabbay <oded.gabbay@amd.com> into cc, he's reported this
> problem too.
> 
Thanks for the fast reply.

I applied the patch and tested it. I wasn't able to reproduce *my* problem,
so you are definitely in the right direction :)

	Oded

>>
>> In case it helps, I've attached the xz-compressed related config file.
>>
>> Chris
>>
>>>
>>> I've attached the full kernel log file for that boot.
>>>
>>> Chris
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
