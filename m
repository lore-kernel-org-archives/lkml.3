Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaLDAyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:54:33 -0500
Received: from mail-bl2on0093.outbound.protection.outlook.com ([65.55.169.93]:20640
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751905AbaLDAyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:54:32 -0500
X-Greylist: delayed 2026 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2014 19:54:31 EST
Message-ID: <547FA8D2.2030703@caviumnetworks.com>
Date: Wed, 3 Dec 2014 16:20:34 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <macro@linux-mips.org>,
        <chenhc@lemote.com>, <cl@linux.com>, <mingo@kernel.org>,
        <richard@nod.at>, <zajec5@gmail.com>, <james.hogan@imgtec.com>,
        <keescook@chromium.org>, <tj@kernel.org>, <alex@alex-smith.me.uk>,
        <pbonzini@redhat.com>, <blogic@openwrt.org>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <markos.chandras@imgtec.com>, <dengcheng.zhu@imgtec.com>,
        <manuel.lauss@gmail.com>, <lars.persson@axis.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com>
In-Reply-To: <547FA2E5.1040105@imgtec.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.194]
X-ClientProxiedBy: BLUPR07CA095.namprd07.prod.outlook.com (25.160.24.50) To
 BN3PR0701MB1105.namprd07.prod.outlook.com (25.160.114.143)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1105;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1105;
X-Forefront-PRVS: 041517DFAB
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(199003)(479174003)(377454003)(64706001)(76176999)(87976001)(87266999)(23746002)(20776003)(95666004)(65806001)(40100003)(66066001)(50466002)(105586002)(81156004)(65956001)(4396001)(47776003)(65816999)(64126003)(80316001)(68736005)(77156002)(62966003)(54356999)(69596002)(46102003)(50986999)(31966008)(92566001)(120916001)(42186005)(101416001)(99396003)(110136001)(97736003)(33656002)(102836001)(106356001)(107046002)(92726001)(122386002)(53416004)(36756003)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0701MB1105;H:dl.caveonetworks.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1105;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0701MB1364;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 03:55 PM, Leonid Yegoshin wrote:
> On 12/03/2014 03:44 PM, David Daney wrote:
>
> (...)
>
> Big work

Not really, although by number of lines of code, it is about 3x the size 
of your patch, it only touches the existing code in one place.  It only 
took about 3 days to write, adding full MIPS64 and R6 support would 
probably be less than another week of work.

microMIPS I haven't looked at as we don't have anything to test it on.

> but it doesn't support customized instructions,

GCC will never put these in the delay slot of a FPU branch, so it is not 
needed.

> multiple ASEs,

Same as above.  But any instructions that are deemed necessary can 
easily be added.

> MIPS R6

It is a proof of concept.  R6 can easily be added if needed.

Your XOL emulation doesn't handle R6 either, so this is no worse than 
your patch in that respect.

> etc.

GCC will never put trapping instructions in the delay slot either.

All we have to support are non-trapping and non-branch/jump instructions 
from the ISA manuals that can be executed from userspace processes. 
That makes it slightly simpler than complete ISA emulation.

>
> Well, it is still not a replacement of XOL emulation.

For use by the FPU emulator, it is probably good enough

> Even close.

I disagree, that is why I took the time to do it.

>
>

