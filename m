Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3EOUV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:21:57 -0400
Received: from mx12.netapp.com ([216.240.18.77]:62696 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab3EOUV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:21:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,679,1363158000"; 
   d="scan'208";a="53907488"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: Zach Brown <zab@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [RFC v0 4/4] nfs, nfsd: rough sys_copy_range and COPY support
Thread-Topic: [RFC v0 4/4] nfs, nfsd: rough sys_copy_range and COPY support
Thread-Index: AQHOUOhBN+gy1oMBTUiMWPUv4w0eHJkHJqGAgAAAlQA=
Date: Wed, 15 May 2013 20:21:54 +0000
Message-ID: <1368649314.3568.19.camel@leira.trondhjem.org>
References: <1368566126-17610-1-git-send-email-zab@redhat.com>
	 <1368566126-17610-5-git-send-email-zab@redhat.com>
	 <20130515201949.GD25994@fieldses.org>
In-Reply-To: <20130515201949.GD25994@fieldses.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <B26BD7ACE61EEA4DB5363E08F7E6EECA@hq.netapp.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 16:19 -0400, J. Bruce Fields wrote:
> On Tue, May 14, 2013 at 02:15:26PM -0700, Zach Brown wrote:
> > This crude patch illustrates the simplest plumbing involved in
> > supporting sys_call_range with the NFS COPY operation that's pending in
> > the 4.2 draft spec.
> > 
> > The patch is based on a previous prototype that used the COPY op to
> > implement sys_copyfileat which created a new file (based on the ocfs2
> > reflink ioctl).  By contrast, this copies file contents between existing
> > files.
> > 
> > There's still a lot of implementation and testing to do, but this can
> > get discussion going.
> 
> I'm using:
> 
> 	git://github.com/loghyr/NFSv4.2
> 
> as my reference for the draft protocol.
> 
> On a quick skim, one thing this is missing before it complies is a
> client implementation of CB_OFFLOAD: "If a client desires an
> intra-server file copy, then it MUST support the COPY and CB_OFFLOAD
> operations."

Note that Bryan is currently working on updating the NFS implementation
to match the draft protocol.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
