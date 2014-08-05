Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaHEN4g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:56:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbaHEN4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:56:35 -0400
Date: Tue, 5 Aug 2014 09:56:27 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs extents related oops.
Message-ID: <20140805135627.GB25110@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140805012845.GA7836@redhat.com>
 <20140805015758.GA9831@redhat.com>
 <53E0E057.1060007@fb.com>
 <53E0E1AE.3050705@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E0E1AE.3050705@fb.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 09:52:46AM -0400, Chris Mason wrote:
 > On 08/05/2014 09:47 AM, Chris Mason wrote:
 > > On 08/04/2014 09:57 PM, Dave Jones wrote:
 > >> On Mon, Aug 04, 2014 at 09:28:45PM -0400, Dave Jones wrote:
 > >>  > Possibly related to some changes I've been making to my fuzz tester today
 > >>  > to operate on the same file from multiple threads.
 > >>  > This was on v3.16-829-g98959948a7ba, but probably exists on earlier trees too
 > >>  > given the lack of btrfs specific commits so far this merge window.
 > >>
 > >> reproducer:
 > >>
 > >> trinity -q -l off -c lseek -c write
 > >>
 > >> (Things also go very, very bad if you then try to umount that
 > >>  partition - endless oopses, too mangled to parse).
 > > 
 > > So we're fuzzing lseek and btrfs goes crazy?  Looking.
 > 
 > Ugh, that's wrong in exciting ways.  Thanks Dave, I'll test a patch with
 > trinity and get it in.

You'll need the latest tree from git to hit this btw.
https://github.com/kernelslacker/trinity

	Dave


