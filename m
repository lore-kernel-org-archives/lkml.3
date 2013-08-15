Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab3HONed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 09:34:33 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:26320 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530Ab3HONea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 09:34:30 -0400
X-AuditID: cbfec373-b7fca6d0000018b9-7d-520cd8e4bae2
Date: Thu, 15 Aug 2013 10:34:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "lance.ortiz@hp.com" <lance.ortiz@hp.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski Filho <arozansk@redhat.com>
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
Message-id: <20130815103421.178a5224@samsung.com>
In-reply-to: <20130815100132.GC27616@pd.tnic>
References: <20130810180322.GC4155@pd.tnic>
 <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com>
 <20130812114404.3bd64fa0@samsung.com> <520A1B5E.8040105@linux.vnet.ibm.com>
 <20130813094147.062317f8@concha.lan> <520A6A30.1030406@linux.vnet.ibm.com>
 <3908561D78D1C84285E8C5FCA982C28F31CB8DB5@ORSMSX106.amr.corp.intel.com>
 <520B603E.3040002@linux.vnet.ibm.com> <20130814211504.393cf138@concha.lan>
 <20130815100132.GC27616@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/hYN0nN3iCDGY1G1i0nfjNZrGkKcPi
	84Z/bBYf+q4xWSzf189ocXnXHDaLs/OOs1ncb3nKbtG/sJfJYl/HAyaLNxfusThwe3xv7WPx
	aNl3i91jwaZSj13bdjJ5LN7zksnjwaHNLB7v911l83i0uIXR4/MmuQDOKC6blNSczLLUIn27
	BK6MptVNTAVX+SpmPz7C0sB4kbuLkZNDQsBE4v2dLWwQtpjEhXvrgWwuDiGBJYwSt3ZNYYFw
	upkkLvy8wAxSxSKgKtG7pYUdxGYTMJJ41djCCmKLCChJfF00lwmkgVngDbPEuZdNYGOFBcIk
	9uxpZgKxeQUMJeb0HGAEsTkFdCX2d5xgh9hwjlni39/lQA4H0B1OElun+kLUC0r8mHyPBcRm
	FtCS2LytiRXClpfYvOYt8wRGgVlIymYhKZuFpGwBI/MqRtHS4uSC4qT0XCO94sTc4tK8dL3k
	/NxNjJCoKd7B+GKD1SFGAQ5GJR7eDR3cQUKsiWXFlbmHGCU4mJVEeKdc5QkS4k1JrKxKLcqP
	LyrNSS0+xMjEwSnVwKhTM3NxSNvkiGqTibP3ve3j39ln5t615PoX6csazHkMeyfnf2VLYnrL
	vefxqmfNV6/+2qayvPt557KZHp/eF8+Rui7ik3SS562mUYSvys+8iE+sCY62+RXnpi8zVXJh
	u7rPO95kWYBA+ezdJsLznGcbzIl1rb4ZGmE8e8ohS7mmxGfzb1R+8lViKc5INNRiLipOBABk
	iX88eAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 15 Aug 2013 12:01:32 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Wed, Aug 14, 2013 at 09:15:04PM -0300, Mauro Carvalho Chehab wrote:
> > > - Two, if ghes_edac is enabled, it prevents other edac drivers
> > > from being loaded. It looks like the assumption here is that if
> > > ghes/firmware first is enabled, then *all* memory errors are
> > > reported through ghes which is not true. We could have (a subset
> > > of) corrected errors reported through ghes, some through CMCI
> > > and uncorrected errors through MCE. So, if I'm not mistaken, if
> > > ghes_edac is enabled, we will only receive ghes error events through
> > > mc_event and not the others. Mauro, is this accurate?
> > 
> > Yes, that's the current assumption. It prevents to have both BIOS and a
> > direct-hardware-access-EDAC-driver to race, as this is known to have
> > serious issues.
> 
> Ok, this is getting confusing so let's shed some more light.
> 
> * First of all, Naveen is asking whether other *edac* drivers can
> be loaded. And no, they cannot once the ghes thing is loaded which
> potentially is a problem.
> 
> For example, if the chipset-specific driver has additional functionality
> from ghes_edac, then that functionality is gone when ghes_edac loads
> first. This might be a problem in some cases, we probably need to think
> about this more in depth.

Yes, but the thing is that it is not safe to use the hardware driver if
the BIOS is also reading the hardware error registers directly, as, on
several hardware, a read cause the error data to be cleaned on such 
register.

So, either APEI should be extended to allow some fine-grained that would
provide ways to check/control what resources would be reserved for BIOS 
only, or the user needs to tell BIOS/Kernel if they want BIOS
or OS to access the hardware.

Regards,
Mauro
