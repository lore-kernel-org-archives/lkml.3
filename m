Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3JLTav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 15:30:51 -0400
Received: from [207.46.163.241] ([207.46.163.241]:33038 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752732Ab3JLTat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 15:30:49 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Anvin <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Len Brown <len.brown@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [GIT PULL] x86 fixes
Thread-Topic: [GIT PULL] x86 fixes
Thread-Index: AQHOx3W1LtwYCBBpZUuTjInp+288M5nxcmW3
Date: Sat, 12 Oct 2013 19:28:55 +0000
Message-ID: <820c2fd2311341ce8a9b59e621c3fd1f@BY2PR05MB222.namprd05.prod.outlook.com>
References: <20131012171553.GA17548@gmail.com>,<CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
In-Reply-To: <CA+55aFxFu9k7xOWd8DqXx8t+PONoV5ijGJv5mshZrYeVsVp32w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 0997523C40
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(85306002)(49866001)(33646001)(74876001)(81816001)(81686001)(47976001)(47736001)(74706001)(50986001)(74366001)(65816001)(56776001)(54316002)(83322001)(69226001)(77982001)(74316001)(80976001)(76482001)(59766001)(81342001)(31966008)(77096001)(47446002)(63696002)(74502001)(56816003)(74662001)(79102001)(80022001)(66066001)(4396001)(54356001)(53806001)(81542001)(46102001)(51856001)(76786001)(76796001)(76576001)(83072001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Windows definitely uses the ACPI reboot vector. The problem with this is that, depending on what the ACPI reboot vector points to, it may also trigger some SMM code. Hitting the PCI reboot vector is likely to skip that in most cases, which results in us breaking a different set of systems that rely on SMM code to reconfigure the hardware to the expectations of the firmware entry point.

The most likely cause of the problem that we're seeing here is that we're leaving the hardware in a state that isn't compatible with assumptions made by Dell's SMM code. We've certainly seen that some previous Dell machines have made incorrect assumptions about VT-d, which probably means that we should be destroying that state before reboot. David Woodhouse had been looking into that - I don't know whether we ever actually merged anything to do so.

