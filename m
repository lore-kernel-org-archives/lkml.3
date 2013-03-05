Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3CEVpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:45:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44631 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3CEVpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:45:23 -0500
Date: Tue, 5 Mar 2013 16:45:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 12/12] xen-block: implement indirect
 descriptors
Message-ID: <20130305214510.GC8235@phenom.dumpdata.com>
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
 <512F46F5.5040105@citrix.com>
 <512F69A002000078000C2020@nat28.tlf.novell.com>
 <20130304204427.GM15386@phenom.dumpdata.com>
 <5135B6B702000078000C2FFF@nat28.tlf.novell.com>
 <20130305141610.GF2589@phenom.dumpdata.com>
 <513624C3.6070808@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <513624C3.6070808@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 06:00:51PM +0100, Roger Pau Monné wrote:
> On 05/03/13 15:16, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 05, 2013 at 08:11:19AM +0000, Jan Beulich wrote:
> >>>>> On 04.03.13 at 21:44, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >>> <nods> 'op' sounds good. With a comment saying it can do all of the 
> >>> BLKIF_OPS_..
> >>> except the BLKIF_OP_INDIRECT one. Thought one could in theory chain
> >>> it that way for fun.
> >>
> >> In fact I'd like to exclude chaining as well as BLKIF_OP_DISCARD here.
> >> The former should - if useful for anything - be controlled by a
> >> separate feature flag, and the latter is plain pointless to indirect.
> >> And I reckon the same would apply to BLKIF_OP_FLUSH_DISKCACHE
> >> and BLKIF_OP_RESERVED_1 - i.e. it might be better to state that
> >> indirection is only permitted for normal I/O (read/write) ops.
> > 
> > <nods> That makes sense. And also of course the new BLKIF_OP should
> > be documented in the Xen tree as well.
> 
> The only ops that can be done indirectly are _READ, _WRITE and
> _BARRIER/_FLUSH. From the implementation in blkfront it seems like
> _FLUSH/_BARRIER requests can indeed contain segments, but I haven't been
> able to spot any _FLUSH op with segments on it. Can you confirm FLUSH
> requests never contain bios?

Not FLUSH per say. But the FUA should be able to provide data and the
flush semantics with it. Except we don't support FUA so this is irrelevant
 - unless in the future we want to intrduce FUA or WRITE with some extra
flags.
