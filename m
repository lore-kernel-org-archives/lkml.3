Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbaJ3CGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:06:00 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19703 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837AbaJ3CF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:05:58 -0400
To: "Jason B. Akers" <jason.b.akers@intel.com>
Cc: linux-ide@vger.kernel.org, axboe@fb.com, dan.j.williams@intel.com,
        kapil.karkra@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
Date: Wed, 29 Oct 2014 22:05:52 -0400
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	(Jason B. Akers's message of "Wed, 29 Oct 2014 11:23:38 -0700")
Message-ID: <yq1k33il3b3.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jason" == Jason B Akers <jason.b.akers@intel.com> writes:

Jason> The following series enables the use of Solid State hybrid drives
Jason> ATA standard 3.2 defines the hybrid information feature, which
Jason> provides a means for the host driver to provide hints to the
Jason> SSHDs to guide what to place on the SSD/NAND portion and what to
Jason> place on the magnetic media.

I have been ripping my hair out in this department for a while.

A colleague and I presented our findings at SNIA SDC a few weeks
ago. I'm trying to find out if there's an embargo on the slides or if I
can post them.

First of all I completely agree with Dave's comments about hooking into
fadvise()/madvise().

For my testing I also overloaded the existing priority fields but ended
up deciding that it would be better to have a separate field (and
cleaning up the priority high byte in bi_rw but that's part of a
different patch set).

My challenge with hints has been trying to bridge all the various
existing approaches with the new stuff that's coming down the pipe in
T10/T13 (LBMD hints) and NFS v4.2 ditto. That turned into a huge mapping
table as well as a few amendments to what's currently being worked on in
the standards bodies.

I didn't actively pursue the hybrid drive hints because I didn't think
there was much interest. But since there is we should combine our
efforts. From an application and kernel perspective we need to have one
type of hints that then get translated into whatever is suitable for
NFS, T10, T13 or SATA-IO SSHDs. It looks like the SSHD hints are
reasonably close to fadvise() which is great.

I'll see if I can get a link to the slides out tomorrow. Otherwise I'll
just redo them.

-- 
Martin K. Petersen	Oracle Linux Engineering
