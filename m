Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3FQV00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:26:26 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:52788
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928Ab3FQV0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:26:25 -0400
Message-ID: <51BF7EE9.8060308@caviumnetworks.com>
Date: Mon, 17 Jun 2013 14:26:01 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Daney <david.daney@cavium.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: Linux 3.10-rc6
References: <CA+55aFwdcdf0Zy82P70YsaF2Kqf4UTKKeDfMN0MPXXwSrGr4yw@mail.gmail.com> <CAMuHMdWMYxg9QC_4EpDgcgevsTAt=3v6iaCa0cHxtzYbMheQ-w@mail.gmail.com> <CA+55aFzw7b7qH37ZLSCAZ8xTd5ez2q44LmeY+GLFPsHEqDPfxA@mail.gmail.com> <20130617133055.20463ce157e104af15ef60a1@linux-foundation.org> <51BF7610.10803@caviumnetworks.com> <20130617135920.587959a34da85d7940a6936f@linux-foundation.org> <51BF7ABD.3080508@caviumnetworks.com> <20130617141310.3d62ea2b05041ec5974f9525@linux-foundation.org>
In-Reply-To: <20130617141310.3d62ea2b05041ec5974f9525@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0880FB6EC1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(199002)(479174002)(377454002)(24454002)(189002)(51704005)(53416002)(76786001)(47976001)(77982001)(74366001)(36756003)(74502001)(16406001)(54316002)(81542001)(76796001)(56816003)(80022001)(64126003)(46102001)(53806001)(79102001)(66066001)(47776003)(69226001)(63696002)(51856001)(59896001)(33656001)(74662001)(31966008)(77096001)(23756003)(54356001)(65956001)(47736001)(74876001)(47446002)(59766001)(49866001)(50466002)(56776001)(76482001)(4396001)(81342001)(50986001)(74706001)(65806001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB020;H:BN1PRD0712HT002.namprd07.prod.outlook.com;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 02:13 PM, Andrew Morton wrote:
> On Mon, 17 Jun 2013 14:08:13 -0700 David Daney <ddaney@caviumnetworks.com> wrote:
>
>>>
>>> I think switch-back-to-a-macro is simplest and safest for now.  Perhaps
>>> you can queue a 3.11 patch which restores the C function and fixes up
>>> mn10300 and ia64?
>>>
>>
>> If the patch is reverted, I will do that.
>
> I'm not proposing that we revert f21afc25f9ed4.  Retain its
> functionality, but do it via a macro for 3.10.
>

I misread your patch.  Your patch may be incorrect in that the flags 
variable you introduce has name space collisions with code using the 
macro.  Linus found this exact problem with the first version of my 
patch (which was identical to your patch).

Once you fix the name of 'flags', I hope you don't run into the same 
Include Hell on ia64 and mn10300 that I did.

David Daney

