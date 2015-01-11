Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbbAKL6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 06:58:12 -0500
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:12000
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750807AbbAKL6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 06:58:09 -0500
X-WSS-ID: 0NI0H8R-08-LPR-02
X-M-MSG: 
Message-ID: <54B26547.2030400@amd.com>
Date: Sun, 11 Jan 2015 13:57:59 +0200
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@linux.intel.com>,
        Alex Deucher <alexdeucher@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Dana Elifaz" <Dana.Elifaz@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Maling list - DRI developers" <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [PATCH] drm/radeon: Try to init amdkfd only if 64 bit kernel
References: <1419246673-7222-1-git-send-email-oded.gabbay@amd.com>
 <CADnq5_MY3+4BdWzUYffTnRWF3J4Z7nb6zyrGZK4RNwVU3axvuw@mail.gmail.com>
 <20141222184940.GB17192@tassilo.jf.intel.com>
 <20141222190041.GC17192@tassilo.jf.intel.com> <54986EA2.106@amd.com>
 <874msmt1hi.fsf@rustcorp.com.au> <549A85DE.1040006@amd.com>
 <87r3v96ebd.fsf@rustcorp.com.au>
 <CAGXu5jJ71tM99uaRoq74AkcB5KhxsfBS3NyDuJ2rJncKmfCWwg@mail.gmail.com>
 <87mw5v4iug.fsf@rustcorp.com.au>
In-Reply-To: <87mw5v4iug.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.11.83]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(199003)(377454003)(189002)(52314003)(24454002)(479174004)(83506001)(87936001)(76176999)(54356999)(65816999)(97736003)(50466002)(64126003)(92566002)(50986999)(19580395003)(19580405001)(33656002)(62966003)(101416001)(46102003)(106466001)(110136001)(23746002)(105586002)(36756003)(93886004)(59896002)(77156002)(2950100001)(68736005)(77096005)(80316001)(64706001)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0201MB1008;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DM2PR0201MB1008;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0201MB1008;
X-Forefront-PRVS: 045315E1EE
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0201MB1008;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 11:58:06.1478
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0201MB1008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/07/2015 12:58 AM, Rusty Russell wrote:
> Kees Cook <keescook@chromium.org> writes:
>> On Sun, Jan 4, 2015 at 8:28 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Kees, as far as I can tell you need another 0-terminated vmlinux.relocs
>>> section for weak symbols.  These should not be relocated if already 0.
>>
>> A few questions:
>>
>> Why doesn't this break on 32-bit without kASLR? 32-bit does relocation
>> by default, even without CONFIG_RANDOMIZE_BASE.
> 
> Well, the offset was 0 until I removed CONFIG_HIBERNATE.
> 
>> Are there any symbols that are NULL that aren't weak? I'd expect all
>> strong symbols to have non-zero offsets, but I must be
>> misunderstanding something here.
> 
> I don't think there would be.  Anyway, you might be able to filter them
> out in x86/tools/relocs itself.
> 
> Cheers,
> Rusty.
> 

Hi Kees,

Did you had time to look at the problem ?

	Oded
