Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbbAKLd4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:33:56 -0500
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:64824
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751983AbbAKLdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:33:55 -0500
X-WSS-ID: 0NI0G4D-08-LDY-02
X-M-MSG: 
Message-ID: <54B25F9A.2020209@amd.com>
Date: Sun, 11 Jan 2015 13:33:46 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
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
	<54B247D0.2090600@amd.com>
 <CALYGNiOpw75TJhXX5czdkEsver0HVf+oGX3d8qVKNPRNLygUpQ@mail.gmail.com>
 <54B25720.2000806@googlemail.com>
In-Reply-To: <54B25720.2000806@googlemail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.11.83]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(51914003)(189002)(199003)(479174004)(377454003)(24454002)(80316001)(68736005)(64706001)(93886004)(83506001)(77096005)(19580395003)(15975445007)(19580405001)(2950100001)(23676002)(64126003)(47776003)(87936001)(101416001)(36756003)(105586002)(62966003)(77156002)(33656002)(65816999)(54356999)(97736003)(46102003)(76176999)(50986999)(59896002)(50466002)(106466001)(92566002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0201MB1076;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0201MB1076;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0201MB1076;
X-Forefront-PRVS: 045315E1EE
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0201MB1076;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 11:33:53.1351
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0201MB1076
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2015 12:57 PM, Chris Clayton wrote:
> Thanks Konstantin.
> 
> [snip]
> 
>>>>
>>>> Looks like degree (%edx) is 1 on anon-vma desruction.
>>>> Probably I've overlooked some weird conrner case in vma splitting/merging.
>>>>
>>>> Could you try this patch. It disables vma merging end eliminates half
>>>> of complicated paths.
>>>> As I see merging is optional, everything should work fine without it.
>>>>
>>>> --- a/mm/mmap.c
>>>> +++ b/mm/mmap.c
>>>> @@ -1048,7 +1048,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>>>>          * We later require that vma->vm_flags == vm_flags,
>>>>          * so this tests vma->vm_flags & VM_SPECIAL, too.
>>>>          */
>>>> -       if (vm_flags & VM_SPECIAL)
>>>> +       if (1)
>>>>                 return NULL;
>>>>
>>>>         if (prev)
>>>>
>>>>
>>>>
>>>>
>>>> Code from your oops.
>>>>
>>>> Code: 00 ad de 48 89 43 18 e8 c5 f9 00 00 48 8b 45 10 48 8d 55 10 48
>>>> 83 e8 10 49 39 d6 74 54 48 8b 7d 08 48 89 eb 8b 57 34 85 d2 74 9e <0f>
>>>> 0b 0f 1f 40 00 e8 6b fc ff ff eb 9a 66 0f 1f 84 00 00 00 00
>>>> All code
>>>> ========
>>>>    0: 00 ad de 48 89 43     add    %ch,0x438948de(%rbp)
>>>>    6: 18 e8                 sbb    %ch,%al
>>>>    8: c5 f9 00             (bad)
>>>>    b: 00 48 8b             add    %cl,-0x75(%rax)
>>>>    e: 45 10 48 8d           adc    %r9b,-0x73(%r8)
>>>>   12: 55                   push   %rbp
>>>>   13: 10 48 83             adc    %cl,-0x7d(%rax)
>>>>   16: e8 10 49 39 d6       callq  0xffffffffd639492b
>>>>   1b: 74 54                 je     0x71
>>>>   1d: 48 8b 7d 08           mov    0x8(%rbp),%rdi
>>>>   21: 48 89 eb             mov    %rbp,%rbx
>>>>   24: 8b 57 34             mov    0x34(%rdi),%edx
>>>>   27: 85 d2                 test   %edx,%edx
>>>>   29: 74 9e                 je     0xffffffffffffffc9
>>>>   2b:* 0f 0b                 ud2     <-- trapping instruction
>>>>   2d: 0f 1f 40 00           nopl   0x0(%rax)
>>>>   31: e8 6b fc ff ff       callq  0xfffffffffffffca1
>>>>   36: eb 9a                 jmp    0xffffffffffffffd2
>>>>   38: 66                   data16
>>>>   39: 0f                   .byte 0xf
>>>>   3a: 1f                   (bad)
>>>>   3b: 84 00                 test   %al,(%rax)
>>>>   3d: 00 00                 add    %al,(%rax)
>>>> ...
>>>>
>>>> Code starting with the faulting instruction
>>>> ===========================================
>>>>    0: 0f 0b                 ud2
>>>>    2: 0f 1f 40 00           nopl   0x0(%rax)
>>>>    6: e8 6b fc ff ff       callq  0xfffffffffffffc76
>>>>    b: eb 9a                 jmp    0xffffffffffffffa7
>>>>    d: 66                   data16
>>>>    e: 0f                   .byte 0xf
>>>>    f: 1f                   (bad)
>>>>   10: 84 00                 test   %al,(%rax)
>>>>   12: 00 00                 add    %al,(%rax)
>>>>
>>>>
>>>> +Added Oded Gabbay <oded.gabbay@amd.com> into cc, he's reported this
>>>> problem too.
>>>>
>>> Thanks for the fast reply.
>>>
>>> I applied the patch and tested it. I wasn't able to reproduce *my* problem,
>>> so you are definitely in the right direction :)
>>
>> Ok. I've found something. Try patch from attachment.
>>
> 
> Your patch has fixed the BUG for me. Thank you.
> 
> Tested-by: Chris Clayton <chris2553@googlemail.com>
> 
Same for me. Thanks.

Tested-by: Oded Gabbay <oded.gabbay@amd.com>

	Oded

>>>
>>>         Oded
>>>
>>>>>
>>>>> In case it helps, I've attached the xz-compressed related config file.
>>>>>
>>>>> Chris
>>>>>
>>>>>>
>>>>>> I've attached the full kernel log file for that boot.
>>>>>>
>>>>>> Chris
>>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
