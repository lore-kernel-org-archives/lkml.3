Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab3JRQau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:30:50 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:55745
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751277Ab3JRQat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:30:49 -0400
Message-ID: <52616228.80002@caviumnetworks.com>
Date: Fri, 18 Oct 2013 09:30:32 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Michael Bohan <mbohan@codeaurora.org>,
        Guenter Roeck <linux@roeck-us.net>,
        David Gibson <david@gibson.dropbear.id.au>,
        <linux-kernel@vger.kernel.org>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <ralf@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        <david.daney@cavium.com>, <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] of/lib: Export fdt routines to modules
References: <1381966065-16854-1-git-send-email-mbohan@codeaurora.org> <525F2397.40203@caviumnetworks.com> <20131017002731.GA22830@codeaurora.org> <525F6D83.1050808@roeck-us.net> <20131017235132.GA6241@codeaurora.org> <52608457.5040609@roeck-us.net> <20131018025405.GA3722@codeaurora.org> <33103C16-6472-4AAE-ADB8-50807CC96C85@antoniou-consulting.com> <52615A64.9040803@gmail.com>
In-Reply-To: <52615A64.9040803@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 00032065B2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(24454002)(377454003)(189002)(199002)(54094003)(51704005)(479174003)(77096001)(83072001)(63696002)(53416003)(47776003)(69226001)(56816003)(65956001)(76796001)(64126003)(65806001)(47446002)(74662001)(80022001)(74502001)(31966008)(66066001)(83322001)(80976001)(59766001)(77982001)(76482001)(56776001)(54316002)(83506001)(47736001)(49866001)(47976001)(50986001)(81816001)(74876001)(53806001)(46102001)(51856001)(54356001)(4396001)(1411001)(85306002)(81686001)(81542001)(50466002)(74366001)(23756003)(81342001)(74706001)(36756003)(76786001)(79102001)(62816006);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB042;H:BY2PRD0712HT004.namprd07.prod.outlook.com;CLIP:64.2.3.195;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 08:57 AM, Rob Herring wrote:
[...]
>
> Unflattening is definitely the right
> direction to go here.
>

I wonder if that is really true.

The device tree in question is very short lived, and used to control the 
configuration of some hardware device when loading the driver.

The use of it is completely contained within a single driver (at least 
that is my understanding), it is not information that needs to be shared 
system wide.

Given that it is a driver implementation issue, rather than making 
things work nicely system wide, I don't think it really matters what is 
done.

It may be that the overhead of unflattening the tree and then freeing 
it, is much greater than just extracting a few things from the FDT.

That said, I don't really have a preference for what is done.  My 
original questions were targeted at understanding this particular use case.

David Daney

