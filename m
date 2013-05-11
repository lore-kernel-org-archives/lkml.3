Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3EKRcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 13:32:31 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33974 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3EKRc3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 13:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3921C703A5F@365EXCH-MBX-P1.nbttech.com>
References: <2CE44BD3DBCF9541909CCB42F11CA3921C6FAA49@SFO1EXC-MBXP06.nbttech.com>
	<3908561D78D1C84285E8C5FCA982C28F2DA4C92B@ORSMSX106.amr.corp.intel.com>
	<2CE44BD3DBCF9541909CCB42F11CA3921C6FAACA@SFO1EXC-MBXP06.nbttech.com>
	<3908561D78D1C84285E8C5FCA982C28F2DA4C9B9@ORSMSX106.amr.corp.intel.com>
	<2CE44BD3DBCF9541909CCB42F11CA3921C6FAB06@SFO1EXC-MBXP06.nbttech.com>
	<3908561D78D1C84285E8C5FCA982C28F2DA4CB19@ORSMSX106.amr.corp.intel.com>
	<2CE44BD3DBCF9541909CCB42F11CA3921C6FAB84@SFO1EXC-MBXP06.nbttech.com>
	<3908561D78D1C84285E8C5FCA982C28F2DA4CD58@ORSMSX106.amr.corp.intel.com>
	<2CE44BD3DBCF9541909CCB42F11CA3921C703A5F@365EXCH-MBX-P1.nbttech.com>
Date: Sat, 11 May 2013 10:32:29 -0700
Message-ID: <CA+8MBb+uqmG=a9EEEHfQwymy5N+eBuJwoCEQy9nETX9=nAnNdg@mail.gmail.com>
Subject: Re: x86_mce: mce_start uses number of phsical cores instead of
 logical cores
From: Tony Luck <tony.luck@gmail.com>
To: Ming Lei <Ming.Lei@riverbed.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I understand from above in intel 64 Arch software Developer's manual are:
> 1) this manual is written for software developer;
> 2) It says that MCE handler only requires to synchronize among the logical cores in the same package/core(what I assume here is same CPU socket).
>
> I have two CPU sockets on motherboard and total 24 logical cores(12 cores each CPU). Each CPU has its own integrated memory controller. Each memory controller controls three channels of DIMMs. I can understand that if one dimm has error, the memory controller can trigger the MCE exception to it's own CPU, but why should this memory controller sends the MCE exception to the other CPU or the rest CPUs on the motherboard? Is there any hardware standard or specification for it?

The Software Developer Manual is the specification of the architecture
- there are data sheets for each processor which describe
implementation details (e.g. perhaps which types of errors are
reported in whcih banks, an MCi_STATUS.MSCOD field values providing
more information about an error).

Your "1&2" understanding is correct. Your question on "why should this
memory controller send the MCE exception ..." is a good one. The
answer is because the architecture requires it; even though you and I
can imagine that it is possible for OS to do its work if the error is
just sent to the processors on the socket where the error was found in
some cases. There may be some cases where this is less easy (e.g. a
logical processor on one socket issues a NUMA read to a location that
is on the memory controller on the other socket).

-Tony
