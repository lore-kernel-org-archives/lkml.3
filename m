Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3HMMWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:22:12 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:51591 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3HMMWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:22:08 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-09-520a24ee35d8
Date: Tue, 13 Aug 2013 09:21:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, bhelgaas@google.com,
        rostedt@goodmis.org, rjw@sisk.pl, lance.ortiz@hp.com,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130813092154.1e17385f@concha.lan>
In-reply-to: <520A1A2E.9080500@linux.vnet.ibm.com>
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com>
 <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <20130812123813.GD18018@pd.tnic>
 <20130812114932.52bb0314@samsung.com> <20130812150424.GH18018@pd.tnic>
 <20130812142557.2a43f155@samsung.com> <20130812175631.GI18018@pd.tnic>
 <520A1A2E.9080500@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/hIN13KlxBBhs6DCzaTvxms1jSlGHx
	ecM/NosPfdeYLJbv62e0uLxrDpvF2XnH2Szutzxlt+hf2Mtksa/jAZPFmwv3WBy4Pb639rF4
	tOy7xe6xYFOpx65tO5k8Fu95yeTx4NBmFo/3+66yeTxa3MLo8XmTXABnFJdNSmpOZllqkb5d
	AlfGxJ1dTAVThSoOvW9hbmCcx9fFyMkhIWAi8f56JzuELSZx4d56ti5GLg4hgSWMEt1dTSwQ
	TiOTxOl/3xhBqlgEVCXufH8DZrMJGEm8amxhBbFFBEwljqy4zgTSwCzQzSTx/N9NNpCEsECY
	xJ49zUwgNq+AgUTvkbvMIDYnUPP5209YQGwhgQfMEkt2J3cxcgCd4SSxdaovRLmgxI/J98BK
	mAW0JDZva2KFsOUlNq95yzyBUWAWkrJZSMpmISlbwMi8ilG0tDi5oDgpPddIrzgxt7g0L10v
	OT93EyMkZop3ML7YYHWIUYCDUYmHN+MjR5AQa2JZcWXuIUYJDmYlEd44Rq4gId6UxMqq1KL8
	+KLSnNTiQ4xMHJxSDYzr7s+1fem2Yec3GzfjRgcWs4fGb16uvDZpUap31fKEyimTXJ7N+ndz
	bsuafln9j06ON8Jrv3zguawzaTbrnMLnKaEXz/dedb3a26TeanfnTZLBR8Pzs0+WFj+v7d6r
	WRdep6fx11W/QYvfyKnkzaWSC7ElFuadPRGdKb4Wxh82veFPV92y1FKJpTgj0VCLuag4EQDs
	m1NGdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 13 Aug 2013 17:06:14 +0530
"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> escreveu:

> On 08/12/2013 11:26 PM, Borislav Petkov wrote:
> > On Mon, Aug 12, 2013 at 02:25:57PM -0300, Mauro Carvalho Chehab wrote:
> >> Userspace still needs the EDAC sysfs, in order to identify how the
> >> memory is organized, and do the proper memory labels association.
> >>
> >> What edac_ghes does is to fill those sysfs nodes, and to call the
> >> existing tracing to report errors.
> 
> I suppose you're referring to the entries under /sys/devices/system/edac/mc?

Yes.

> 
> I'm not sure I understand how this helps. ghes_edac seems to just be 
> populating this based on dmi, which if I'm not mistaken, can be obtained 
> in userspace (mcelog as an example).
> 
> Also, on my system, all DIMMs are being reported under mc0. I doubt if 
> the labels there are accurate.

Yes, this is the current status of ghes_edac, where BIOS doesn't provide any
reliable way to associate a given APEI report to a physical DIMM slot label.

The plan is to add more logic there as BIOSes start to provide some reliable
way to do such association. I discussed this subject with a few vendors
while I was working at Red Hat.

> >
> > This is the only reason which justifies EDAC's existence. Naveen, can
> > your BIOS directly report the silkscreen label of the DIMM in error?
> > Generally, can any BIOS do that?
> >
> > More specifically, what are those gdata_fru_id and gdata_fru_text
> > things?
> 
> My understanding was that this provides the DIMM serial number, but I'm 
> double checking just to be sure.

If it provides the DIMM serial number, then it is possible to improve the
ghes_edac driver to associate them. One option could be to write an I2C
driver and dig those information directly from the memories, although 
doing that could be risky, as BIOS could also try to access the same I2C
buses.

> 
> Thanks,
> Naveen
> 
> >
> > Because if it can, then having the memory error tracepoint come direct
> > from APEI should be enough. The ghes_edac functionality could be then
> > fallback for BIOSes which cannot report the silkscreen label and in such
> > case I can imagine keeping both tracepoints, but disabling one of the
> > two...
> >
> 


-- 

Cheers,
Mauro
