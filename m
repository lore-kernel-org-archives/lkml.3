Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaKGVgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 16:36:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36074 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbaKGVgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 16:36:52 -0500
Message-ID: <545D3B3D.50907@redhat.com>
Date: Fri, 07 Nov 2014 16:35:57 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: j.glisse@gmail.com, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>, joro@8bytes.org,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>,
        Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jatin Kumar <jakumar@nvidia.com>
Subject: Re: [PATCH 4/5] hmm: heterogeneous memory management v6
References: <1415047353-29160-1-git-send-email-j.glisse@gmail.com> <1415047353-29160-5-git-send-email-j.glisse@gmail.com>
In-Reply-To: <1415047353-29160-5-git-send-email-j.glisse@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/03/2014 03:42 PM, j.glisse@gmail.com wrote:
> From: Jérôme Glisse <jglisse@redhat.com>
> 
> Motivation:
> 
> Heterogeneous memory management is intended to allow a device to
> transparently access a process address space without having to lock
> pages of the process or take references on them. In other word
> mirroring a process address space while allowing the regular memory
> management event such as page reclamation or page migration, to
> happen seamlessly.
> 
> Recent years have seen a surge into the number of specialized
> devices that are part of a computer platform (from desktop to
> phone). So far each of those devices have operated on there own
> private address space that is not link or expose to the process
> address space that is using them. This separation often leads to
> multiple memory copy happening between the device owned memory and
> the process memory. This of course is both a waste of cpu cycle and
> memory.
> 
> Over the last few years most of those devices have gained a full
> mmu allowing them to support multiple page table, page fault and
> other features that are found inside cpu mmu. There is now a strong
> incentive to start leveraging capabilities of such devices and to
> start sharing process address to avoid any unnecessary memory copy
> as well as simplifying the programming model of those devices by
> sharing an unique and common address space with the process that
> use them.
> 
> The aim of the heterogeneous memory management is to provide a
> common API that can be use by any such devices in order to mirror
> process address. The hmm code provide an unique entry point and
> interface itself with the core mm code of the linux kernel avoiding
> duplicate implementation and shielding device driver code from core
> mm code.

Acked-by: Rik van Riel <riel@redhat.com>

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUXTs9AAoJEM553pKExN6DhSYIAI41vr6c/vVdIg2m6Wq3DiSS
KtBTUX5/cFmvh9Zd3S422ZwzJQ6ZZLGsNuh2LajLqR0dhDKkwxS7FWFSdifcAfq2
B/Xq8JyeW98Fa0OP0V4uqMuo1FMvlXFZsDijFefxo5F2T/H6XyRI2M+f4w5w9iZa
3EvUaFHoG+mCjoR+ANuxwR9J048wWF626R6CHPOvvIKDNRVr+LADvLMBXmbnrYJs
643mmjhNT+EdPQbxBVszsUbBo/mGicRBuW+t3XkWy1g+hsa4AewhHnOuSHDr13zM
YBFjeGP1TbOQxtkiJetsAE4pKxSlJDoscp7vbJjYzLz3Kk2Fag3r1kpSU8S8stI=
=ucI+
-----END PGP SIGNATURE-----
