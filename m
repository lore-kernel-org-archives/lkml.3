Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaKKTBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:01:05 -0500
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:60060 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbaKKTBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:01:01 -0500
Date: Tue, 11 Nov 2014 13:00:56 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: j.glisse@gmail.com
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        joro@8bytes.org, Mel Gorman <mgorman@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
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
        Oded Gabbay <Oded.Gabbay@amd.com>, linux-fsdevel@vger.kernel.org,
        Linda Wang <lwang@redhat.com>, Kevin E Martin <kem@redhat.com>,
        Jerome Glisse <jglisse@redhat.com>, Jeff Law <law@redhat.com>,
        Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagig@mellanox.com>
Subject: Re: HMM (heterogeneous memory management) v6
In-Reply-To: <1415644096-3513-1-git-send-email-j.glisse@gmail.com>
Message-ID: <alpine.DEB.2.11.1411111259560.6657@gentwo.org>
References: <1415644096-3513-1-git-send-email-j.glisse@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, j.glisse@gmail.com wrote:

> In a nutshell HMM is a subsystem that provide an easy to use api to mirror a
> process address on a device with minimal hardware requirement (mainly device
> page fault and read only page mapping). This does not rely on ATS and PASID
> PCIE extensions. It intends to supersede those extensions by allowing to move
> system memory to device memory in a transparent fashion for core kernel mm
> code (ie cpu page fault on page residing in device memory will trigger
> migration back to system memory).

Could we define a new NUMA node that maps memory from the GPU and
then simply use the existing NUMA features to move a process over there.
